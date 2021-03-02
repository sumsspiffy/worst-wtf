<?php

class Local {
    public function Info() {
        return $GLOBALS['database']->GetContent('users', ['userkey' => $_SESSION['userkey']])[0];
    }

    public function IsAdmin() {
        $group = Local::Info()['usergroup'];
        $roles = array('admin', 'funky');
        if(in_array($group, $roles)) {
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
        if(empty($mail) || !filter_var($mail, FILTER_VALIDATE_EMAIL)) { $Error[] = "Invalid mail"; }
        if(Secure::AntiVpn()) { $Error[] = "Vpn not allowed"; }
        if(Secure::AntiAlt()) { $Error[] = "Altings not allowed"; }

        $res = $GLOBALS['database']->Count('users', ['username' => $user]);
        if($res > 0) { $Error[] = "Username exists"; }

        $res = $GLOBALS['database']->Count('users', ['mail' => $mail]);
        if($res > 0) { $Error[] = "Email exists"; }

        if($captcha->success == 0 || $captcha->score < 0.5) {
            $Error[] = "Failed captcha";
        } 

        if(empty($Error)) {
            $key = md5(mt_rand(100000, 999999));
            date_default_timezone_set('UTC');
            $date = date("Y:m:d H:i:s");

            // activate the session
            $_SESSION['active'] = true;
            $_SESSION['userkey'] = $key;

            $GLOBALS['database']->Insert('users', ['username' => $user, 'password' => md5($pass), 'mail' => $mail, 'userkey' => $key, 'ip' => $_SERVER['REMOTE_ADDR'], 'date' => $date]);
            return;
        }

        else { 
            foreach($Error as $Errors) {
                echo("$Errors.\n");
            }
        }
    }

    public function Verify($user, $token) {

    }

    public function Login($user, $pass, $captcha) {
        if(empty($user)) { $Error[] = "Invalid username"; }
        if(empty($pass)) { $Error[] = "Invalid password"; }
        if(Secure::AntiVpn()) { $Error[] = "Vpn not allowed"; }

        $res = $GLOBALS['database']->GetContent('users', ['username' => $user, 'password' => md5($pass)])[0];

        if($res == 0) { 
            $Error[] = "Invalid credentials";
        }

        if($captcha->success == 0 || $captcha->score < 0.5) {
            $Error[] = "Failed captcha";
        }

        if(empty($Error)) {
            $_SESSION['userkey'] = $res['userkey'];
            $_SESSION['active'] = true;
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

    public function Info($user) {
        return $GLOBALS['database']->GetContent('users', ['username' => $user])[0];
    }
}

class Secure {
    public function AntiAlt() {
        $Address = $_SERVER['REMOTE_ADDR'];

        // update ip address if it had changed
        if(Local::Info()['ip'] != $Address) {
            $GLOBALS['database']->Update('users', ['userkey' => $_SESSION['userkey']], ['ip' => $Address]);
        }

        $res = $GLOBALS['database']->GetContent('users', ['ip' => $Address]);
        
        foreach($res as $user) {
            if ($user['userkey'] != Local::Info()['userkey']) {
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