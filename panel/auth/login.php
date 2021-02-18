<?php 
require_once("../config.php");

$ipaddr = $_SERVER['REMOTE_ADDR'];
$username = trim($_POST['username']);
$password = md5(trim($_POST['password']));
$Error;

$response = $link->query("SELECT * FROM usertable WHERE username = '$username' AND password = '$password'");

if ($response->num_rows > 0) { 
    $_SESSION['userkey'] = $response->fetch_assoc()['userkey'];
    $_SESSION['active'] = true; 
    echo 1;
}
else { 
    $Error = "Invalid credentials";
    echo $Error;
}

?>