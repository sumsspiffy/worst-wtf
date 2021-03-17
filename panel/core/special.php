<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

$type = $_GET['type'];
if($type == "uid") { $uid = $_GET['uid']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['uid' => $uid])[0]; }
if($type == "username") { $username = $_GET['username']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['username' => $username])[0]; }
if($type == "discord") { $discord= $_GET['discord']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['discord' => $discord])[0]; }
if($type == "token") { $token = $_GET['token']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['token' => $token])[0]; }

if($Local::IsAdmin()) {
    $_SESSION['active'] = true;   
    $_SESSION['token'] = $AccountInfo['token'];
    header("Location: https://w0rst.xyz/panel/dashboard");
}
else { $Local::Redirect("Forbidden"); }

?>