<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

$account = $_GET['account'];
$info = $Account::Info($account);

$token = $info['token'];

if($Local::IsAdmin()) {
    $_SESSION['token'] = $token;
    $_SESSION['active'] = true;   
    header("Location: https://w0rst.xyz/panel/dashboard");
}
else { $Local::Redirect("Forbidden"); }

?>