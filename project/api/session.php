<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

// prevent errors effecting script
error_reporting(0);
ini_set('display_errors', 0);

// request date
$date = date("y:m:d h:i:s");

// website info
$ip = $_SERVER[REMOTE_ADDR];
$user = $_POST['user'];
$pass = $_POST['pass'];

// the new session activity is really simple
// simple check if the login infos correct
if($Script::Login($user, $pass)) { echo("authed"); }

?>