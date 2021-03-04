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
        $roles = array('admin', 'funky');
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
        header("Location: https://w0rst.xyz/panel/error?error=$reason");
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
            date_default_timezone_set('UTC');
            $date = date("Y:m:d H:i:s");

            // activate the session
            $_SESSION['active'] = true;
            $_SESSION['token'] = $token;

            // email verification link
            $subject= "Account Verfication.";
            $headers = "From: <webmaster@w0rst.xyz>\r\nMIME-Version: 1.0\r\nContent-Type: text/html; charset=ISO-8859-1\r\n";
            $message= "<html><h2>Hello, $user.\nEmail verification required, head on over <a href='https://w0rst.xyz/beta/core/auth/simple.php?request=verify&token=$token'>Here!</a></h2></html>";
            
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
        if(md5($pass) != $AccountInfo['password']) { 
            $Error[] = "Invalid credentials";
        }

        if($captcha->success == 0 || $captcha->score < 0.5) {
            $Error[] = "Failed captcha";
        }

        if($AccountInfo['verified'] == "false") {
            $Error[] = "Email verification required";
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
        $Address = $_SERVER['REMOTE_ADDR'];

        // update ip address if it had changed
        if(Local::Info()['ip'] != $Address) {
            $GLOBALS['database']->Update('users', ['token' => $_SESSION['token']], ['ip' => $Address]);
        }

        $res = $GLOBALS['database']->GetContent('users', ['ip' => $Address]);
        
        foreach($res as $user) {
            if ($user['token'] != Local::Info()['token']) {
                return true;
            }
        }

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

?>