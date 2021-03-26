<?php

class Local {
    public function Info() {
        return $GLOBALS['database']->GetContent('users', ['token' => $_SESSION['token']])[0];
    }

    public function ChangePassword($oldpass, $newpass) {
        $LocalInfo = Local::Info();
        $username = $LocalInfo['username'];
        $password = $LocalInfo['password'];

        // password salt encryption
        $salt = $LocalInfo['salt'];
        $oldpass = md5($salt.":".md5($oldpass));
        $newpass = md5($salt.":".md5($newpass));

        if($oldpass != $password) { 
            $Error[] = "Incorrect password";
        }

        if($oldpass == $newpass) {
            $Error[] = "Passwords cannot match";
        }

        if(empty($Error)) {
            Account::Edit($username, "password", $newpass);
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

    public function UpdateIp() {
        $LocalInfo = Local::Info();
        $IpAddress = Secure::IpAddress();

        if($IpAddress != $LocalInfo['ip']) {
            Account::Edit($LocalInfo['username'], "ip", $IpAddress);
        }
    }
    
    public function Disconnect() {
        session_unset();
        session_destroy();
    }

    public function Redirect($reason) {
        // if theres a reason then add that 
        if($reason) { $extra = "?reason=$reason"; }
        header("Location: https://w0rst.xyz/error$extra");
    }
}

class Account {
    public function Create($user, $pass, $mail, $captcha) {
        if(empty($user)) { $Error[] = "Invalid username"; }
        if(empty($pass)) { $Error[] = "Invalid password"; }
        if(empty($mail)) { $Error[] = "Invalid email"; }
        if(Secure::AntiVpn()) { $Error[] = "Vpns against tos"; }
        if(Secure::AntiAlt()) { $Error[] = "Altings against tos"; }
        if(Secure::AntiProxy()) { $Error[] = "Proxys against tos"; }

        $res = $GLOBALS['database']->Count('users', ['username' => $user]);
        if($res > 0) { $Error[] = "Username exists"; }

        $res = $GLOBALS['database']->Count('users', ['email' => $mail]);
        if($res > 0) { $Error[] = "Email exists"; }

        if($captcha->success == 0 || $captcha->score < 0.5) {
            $Error[] = "Failed captcha";
        } 

        if(empty($Error)) {
            $token = Secure::Randomize();
            $salt = Secure::Randomize();
            $date = date("y:m:d h:i:sa");

            // password salt encryption
            $pass = md5($salt.":".md5($pass));

            // activate the session
            $_SESSION['active'] = true;
            $_SESSION['token'] = $token;

            // email verification link
            $subject= "Account Verfication.";
            $headers = "From: <support@w0rst.xyz>\r\nMIME-Version: 1.0\r\nContent-Type: text/html; charset=ISO-8859-1\r\n";
            $message= "<html><p>Hello, $user.\nEmail verification required.</p><a href='https://w0rst.xyz/panel/req/simple.php?request=verify&token=$token'><h1>Verify</h1></a></html>";

            mail($mail, $subject, $message, $headers);

            $GLOBALS['database']->Insert('users', ['username' => $user, 'password' => $pass, 'salt' => $salt, 'email' => $mail, 'token' => $token, 'ip' => $_SERVER['REMOTE_ADDR'], 'date' => $date]);
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
        if(Secure::AntiVpn()) { $Error[] = "Vpns against tos"; }
        if(Secure::AntiProxy()) { $Error[] = "Proxys against tos"; }

        $AccountInfo = Account::Info($user);
        $IpAddress = Secure::IpAddress();

        // password salt encryption
        $salt = $AccountInfo['salt'];
        $pass = md5($salt.":".md5($pass));

        if($pass != $AccountInfo['password']) { 
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

        if(empty($Error)) {
            $_SESSION['token'] = $AccountInfo['token'];
            $_SESSION['active'] = true;
            Local::UpdateIp();
            return;
        }
        
        else { 
            foreach($Error as $Errors) {
                echo("$Errors.\n");
            }
        }
    }

    public function IsAdmin($user) {
        $role  = Account::Info($user)['role'];
        $roles = array('admin', 'funky', 'sex', 'monkey', 'wow');
        if(in_array($role, $roles)) {
            return true;
        }

        return false;
    }

    public function IsBlacklisted($user) {
        $blacklist = Local::Info($user)['blacklist'];
        if($blacklist == "true") {
            return true;
        }

        return false;
    }

    public function Info($user) {
        return $GLOBALS['database']->GetContent('users', ['username' => $user])[0];
    }
}

class Secure {
    public function IpAddress() { 
        // this should stop the php errors !!!!
        if (isset($_SERVER['REMOTE_ADDR'])) {
            return $_SERVER['REMOTE_ADDR'];
        }
    }

    public function Randomize() {
        return substr(str_shuffle(str_repeat($x='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ceil(12/strlen($x)))), 1, 12);
    }

    public function AntiAlt() {
        // if the users ip is found in the database
        $IpAddress = Secure::IpAddress(); // get the ipaddress for checking the db
        $response = $GLOBALS['database']->GetContent('users', ['ip' => $IpAddress]);

	    if($_SESSION['active'] == true) { return true; } // if the sessions active
        
        if($response) { return true; } // on reg if there associated by ip then they alting!>!>!

        return false;
    }

    public function AntiVpn() {
        $IpAddress = Secure::IpAddress();

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, "http://check.getipintel.net/check.php?ip=$IpAddress&contact=sumsspiffy@gmail.com&format=json");
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, TRUE);

        $response = curl_exec($curl);
        curl_close($curl); // close curl after getting response
        $response = json_decode($response, true); // decode json

        if($response['status'] == "error") { return false; } // there was an error with the response so cancel
        if($response['result'] > 0.75) { return true; } // if the result is more then its likely a vpn

        return false;
    }

    public function AntiProxy() { 
        // these headers are likely to be used by proxys, very basic checks
        $proxys = array('HTTP_CLIENT_IP','CLIENT_IP','HTTP_PROXY_CONNECTION');

        foreach($proxys as $x){
            if (isset($_SERVER[$x])) { return true; }
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
            case "public": return $GLOBALS['database']->GetContent('backdoors', ['type' => 'public']);
            case "private": return $GLOBALS['database']->GetContent('backdoors', ['type' => 'private', 'token' => $_SESSION['token']]);
        }
    }
}

class Script {
    // this is the same as account:login() 
    // but recaptcha isn't used because gmod
    function Login($user, $pass) {
        if(empty($user)) { $Error[] = "Invalid username"; }
        if(empty($pass)) { $Error[] = "Invalid password"; }
        if(Secure::AntiVpn()) { $Error[] = "Vpns against tos"; }
        if(Secure::AntiProxy()) { $Error[] = "Proxys against tos"; }

        $AccountInfo = Account::Info($user);
        $IpAddress = Secure::IpAddress();

        // password salt encryption
        $salt = $AccountInfo['salt'];
        $pass = md5($salt.":".$pass); // pass comes encrypted

        // incorrect information
        if($pass != $AccountInfo['password']) { 
            $Error[] = "Incorrect password";
        } 

        // currently blacklisted
        if($AccountInfo['blacklist'] == "true") {
            $Error[] = "Currently blacklisted";
        } 

        // account needs verification
        if($AccountInfo['verified'] == "false") { 
            $Error[] = "Awaiting email verification";
        }

        // account never linked discord 
        if($AccountInfo['discord'] == "NULL") {
            $Error[] = "Awaiting discord link";
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
