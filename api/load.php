<?php
$main_script = file_get_contents($_SERVER['DOCUMENT_ROOT'].'/script/main');
$login_script = file_get_contents($_SERVER['DOCUMENT_ROOT'].'/script/login');

$var = $_POST["Ecb32De6EDdfB3Dd49e5A93c"];

if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") { 
    if($var == "Ce4c88f3E9969F4fcFD93400") { echo $main_script; }
    if($var == "fd1f4ab23dFbd98DCd275Ed4") { echo $login_script; }
}
else { 
    echo fuckoff;
}
?>