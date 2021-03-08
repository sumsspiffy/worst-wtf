<?php

class Local {
    public function Info() {
        return $GLOBALS['database']->GetContent('users', ['token' => $_SESSION['token']])[0];
    }

    public function ChangePassword($oldpass, $newpass) {
        $LocalInfo = Local::Info();
        $username = $LocalInfo['username'];
        $password = $LocalInfo['password'];

        if(md5($oldpass) != $password) {
            $Error[] = "Incorrect password";
        }

        if(md5($oldpass) == md5($newpass)) {
            $Error[] = "Passwords cannot be the same";
        }

        if(empty($Error)) {
            Account::Edit($username, "password", md5($newpass));
            return true;
        }

        else { 
            foreach($Error as $Errors) {
                echo("$Errors.\n");
            }
        }
    }

    public function IsVerified() {
        $LocalInfo = Local::Info();
        $verified = $LocalInfo['verified'];

        if($verified == "true") {
            return true;
        }

        return false;
    }

    public function IsAdmin() {
        $role  = Local::Info()['role'];
        $roles = array('admin', 'funky', 'sex', 'monkey', 'wow');
        if(in_array($role, $roles)) {
            return true;
        }

        return false;
    }

    public function IsBlacklisted() {
        $blacklist = Local::Info()['blacklist'];
        if($blacklist == "true") {
            return true;
        }

        return false;
    }

    public function IsActive() {
        if ($_SESSION['active'] == true) {
            return true;
        }

        return false;
    }
    
    public function Disconnect() {
        session_unset();
        session_destroy();
    }

    public function Redirect($reason) {
        // if theres a reason then add that 
        if($reason) { $extra = "?reason=$reason"; }
        header("Location: https://w0rst.xyz/error.php$extra");
    }
}

class Account {
    public function Create($user, $pass, $mail, $captcha) {
        if(empty($user)) { $Error[] = "Invalid username"; }
        if(empty($pass)) { $Error[] = "Invalid password"; }
        if(empty($mail)) { $Error[] = "Invalid email"; }
        if(Secure::AntiVpn()) { $Error[] = "Vpn not allowed"; }
        if(Secure::AntiAlt()) { $Error[] = "Altings not allowed"; }

        $res = $GLOBALS['database']->Count('users', ['username' => $user]);
        if($res > 0) { $Error[] = "Username exists"; }

        $res = $GLOBALS['database']->Count('users', ['email' => $mail]);
        if($res > 0) { $Error[] = "Email exists"; }

        if($captcha->success == 0 || $captcha->score < 0.5) {
            $Error[] = "Failed captcha";
        } 

        if(empty($Error)) {
            $token = Secure::Randomize();
            $date = date("y:m:d h:i:sa");

            // activate the session
            $_SESSION['active'] = true;
            $_SESSION['token'] = $token;

            // email verification link
            $subject= "Account Verfication.";
            $headers = "From: <webmaster@w0rst.xyz>\r\nMIME-Version: 1.0\r\nContent-Type: text/html; charset=ISO-8859-1\r\n";
            $message= "<html><p>Hello, $user.\nEmail verification required.</p><a href='https://w0rst.xyz/panel/core/auth/simple.php?request=verify&token=$token'><h1>Verify</h1></a></html>";

            mail($mail, $subject, $message, $headers);

            $GLOBALS['database']->Insert('users', ['username' => $user, 'password' => md5($pass), 'email' => $mail, 'token' => $token, 'ip' => $_SERVER['REMOTE_ADDR'], 'date' => $date]);
            return;
        }

        else { 
            foreach($Error as $Errors) {
                echo("$Errors.\n");
            }
        }
    }

    public function Edit($user, $edit, $value) {
        $GLOBALS['database']->Update('users', ['username' => $user], [$edit => $value]);
    }

    public function Verify($token) {
        $AccountInfo = $GLOBALS['database']->GetContent('users', ['token' => $token])[0];
        $username = $AccountInfo['username'];
        $usertoken = $AccountInfo['token'];

        if($token == $usertoken) {
            Account::Edit($username, "verified", "true");
            return true;
        }

        return false;
    }

    public function Login($user, $pass, $captcha) {
        if(empty($user)) { $Error[] = "Invalid username"; }
        if(empty($pass)) { $Error[] = "Invalid password"; }
        if(Secure::AntiVpn()) { $Error[] = "Vpn not allowed"; }

        $AccountInfo = Account::Info($user);
        $IpAddress = $_SERVER['REMOTE_ADDR'];

        if(md5($pass) != $AccountInfo['password']) { 
            $Error[] = "Invalid credentials";
        }

        if($captcha->success == 0 || $captcha->score < 0.5) {
            $Error[] = "Failed captcha";
        }

        if($AccountInfo['blacklist'] == "true") {
            $Error[] = "Currently Blacklisted";
        } 

        if($AccountInfo['verified'] == "false") { 
            $Error[] = "Awaiting Email Verification";
        }

        if($IpAddress != $AccountInfo['ip']) {
            Account::Edit($user, "ip", $IpAddress);
        }

        if(empty($Error)) {
            $_SESSION['token'] = $AccountInfo['token'];
            $_SESSION['active'] = true;
            return;
        }
        
        else { 
            foreach($Error as $Errors) {
                echo("$Errors.\n");
            }
        }
    }

    public function Info($user) {
        return $GLOBALS['database']->GetContent('users', ['username' => $user])[0];
    }
}

class Secure {
    public function Randomize() {
        return substr(str_shuffle(str_repeat($x='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ceil(12/strlen($x)))), 1, 12);
    }

    public function AntiAlt() {
        // if the users ip is found in the database
        $res = $GLOBALS['database']->GetContent('users', ['ip' => $_SERVER['REMOTE_ADDR']]);
        
        if($res) { return true; } // return the response

        return false;
    }

    public function AntiVpn() { 
        $Address = $_SERVER['REMOTE_ADDR'];
        $url = "http://api.stopforumspam.org/api?ip=$Address&json";
        
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);
        $res = curl_exec($curl);
        curl_close($curl);

        $res = json_decode($res, true);
        if($res["ip"]["appears"] == 1) {
            return true;
        }

        return false;
    }
}

class Log {
    public function Script() {
        return $GLOBALS['database']->GetContent('logs');
    }

    public function Server($method) {
        switch($method) {
            case "all": return $GLOBALS['database']->GetContent('backdoors');
            case "public": return $GLOBALS['database']->GetContent('backdoors', ['token' => 'none']);
            case "private": return $GLOBALS['database']->GetContent('backdoors', ['token' => $_SESSION['token']]);
        }
    }
}

class Script {
    function Login($user, $pass) {
        if(empty($user)) { $Error[] = "Invalid username"; }
        if(empty($pass)) { $Error[] = "Invalid password"; }

        $AccountInfo = Account::Info($user);
        $IpAddress = $_SERVER['REMOTE_ADDR'];

        // incorrect information
        if($pass != $AccountInfo['password']) { 
            $Error[] = "Incorrect password";
        } 

        // currently blacklisted
        if($AccountInfo['blacklist'] == "true") {
            $Error[] = "Currently Blacklisted";
        } 

        // account needs verification
        if($AccountInfo['verified'] == "false") { 
            $Error[] = "Awaiting Email Verification";
        }

        // account never linked discord 
        if($AccountInfo['discord'] == "NULL") {
            $Error[] = "Awaiting Discord Link";
        }
    
        // update ip address if it changed
        if($IpAddress != $AccountInfo['ip']) {
            Account::Edit($user, "ip", $IpAddress);
        }

        if(empty($Error)) {
            return true;
        }

        else { 
            foreach($Error as $Errors) {
                echo("$Errors.\n");
            }
        }
    }
    
    function IsAdmin($user) {
        $role = Account::Info($user)['role'];
        $roles = array('admin', 'funky', 'sex', 'monkey', 'wow');

        if(in_array($role, $roles)) {
            return true;
        }

        return false;
    }
}


?>
