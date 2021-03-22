<?php
require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

$token = $_GET['token'];
$email = $_POST['email'];
$request = $_GET['request'];
$username = trim($_POST['username']);
$password = trim($_POST['password']);
$recaptcha_url = 'https://www.google.com/recaptcha/api/siteverify';
$recaptcha_secret = '6Lc3-FwaAAAAAGTJV3fJ_mzE5kU_1H8mj7sVqh6a';
$recaptcha_response = $_POST['captcha'];
$recaptcha = file_get_contents($recaptcha_url . '?secret=' . $recaptcha_secret . '&response=' . $recaptcha_response);
$recaptcha = json_decode($recaptcha);

if($request == "update") { 
    $Local::ChangePassword($_POST['oldpass'], $_POST['newpass']);
}

if($request == "blacklist") {
    $AccountInfo = $Account::Info($username);
    if($AccountInfo['blacklist'] == "true") { $Account::Edit($username, "blacklist", "false"); }
    else { $Account::Edit($username, "blacklist", "true"); }
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
    header("Location: https://w0rst.xyz/panel/"); 
}

?>