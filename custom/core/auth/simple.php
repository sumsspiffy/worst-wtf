<?php
require_once($_SERVER["DOCUMENT_ROOT"]."/beta/config.php");
$request = $_GET['request'];
$email = $_POST['email'];
$username = trim($_POST['username']);
$password = trim($_POST['password']);
$recaptcha_url = 'https://www.google.com/recaptcha/api/siteverify';
$recaptcha_secret = '6Lc3-FwaAAAAAGTJV3fJ_mzE5kU_1H8mj7sVqh6a';
$recaptcha_response = $_POST['token'];
$recaptcha = file_get_contents($recaptcha_url . '?secret=' . $recaptcha_secret . '&response=' . $recaptcha_response);
$recaptcha = json_decode($recaptcha);

if($request == "login") { 
    Account::Login($username, $password, $recaptcha);
}

if($request == "register") { 
    Account::Create($username, $password, $email, $recaptcha);
}

if($request == "logout") { 
    Local::Disconnect(); // clear session info
    header("Location: https://w0rst.xyz/beta/"); 
}

?>