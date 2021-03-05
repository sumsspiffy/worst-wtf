<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

// request date
date_default_timezone_set('UTC');
$date = date("Y:m:d H:i:s");

// website info
$ip = $_SERVER[REMOTE_ADDR];
$user = $_POST['user'];
$pass = $_POST['pass'];

if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") {

    // the new session activity is really simple
    // simple check if the login infos correct
    if($Script::Login($user, $pass)) { echo("Authed"); }

}

?>