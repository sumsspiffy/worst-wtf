<?php

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

$request = $_GET['request']; // for each

// for servers
$id = $_POST['id'];
$type = $_POST['type'];

// for users
$token = $_GET['token'];
$email = $_POST['email'];
$username = trim($_POST['username']);
$password = trim($_POST['password']);
$recaptcha_url = 'https://www.google.com/recaptcha/api/siteverify';
$recaptcha_secret = '6Lc3-FwaAAAAAGTJV3fJ_mzE5kU_1H8mj7sVqh6a';
$recaptcha_response = $_POST['captcha'];
$recaptcha = file_get_contents($recaptcha_url . '?secret=' . $recaptcha_secret . '&response=' . $recaptcha_response);
$recaptcha = json_decode($recaptcha);
$oldpass = $_POST['oldpass'];
$newpass = $_POST['newpass'];

if($request == "update") { 
    $Local::ChangePassword($oldpass, $newpass);
}

if($request == "blacklist") {
    $LocalInfo = $Local::Info(); // yes you!!
    $AccountInfo = $Account::Info($username);

    // security flaw avoided omegalul
    if($LocalInfo['blacklist'] == "false") {
        if($AccountInfo['blacklist'] == "true") { 
            // remove the blacklist if its been added
            $Account::Edit($username, "blacklist", "false"); 
        } else { 
            // add the blacklist if they weren't before
            $Account::Edit($username, "blacklist", "true"); 
        }
    }
}

if($request == "login") { 
    $Account::Login($username, $password, $recaptcha);
}

if($request == "register") { 
    $Account::Create($username, $password, $email, $recaptcha);
}

if($request == "verify") { 
    if($Account::Verify($token)) {
        header("Location: https://w0rst.xyz/panel/dashboard"); 
    }
}

if($request == "logout") { 
    $Local::Disconnect(); // clear session info
    header("Location: https://w0rst.xyz/panel/authorize"); 
}

if($request == "server" && $type == "remove") {
    if($Local::IsAdmin() || $token == $_SESSION['token']) { 
        $GLOBALS['database']->Delete('backdoors', ['id' => $id]); 
    } else { echo("Invalid Permissions."); }
}

?>