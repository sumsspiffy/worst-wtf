<?php
$main_script = file_get_contents($_SERVER['DOCUMENT_ROOT'].'/script/main');
$login_script = file_get_contents($_SERVER['DOCUMENT_ROOT'].'/script/login');

$var = $_POST["D959582AE81FFA411f818ff7"];
$script = "38242EEbAbbbE56A7eDf1E09";
$login = "FdCdcCDcDa4a58Fe9dc042BA";

if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") {
    if($var == $script) { echo $main_script; }
    if($var == $login) { echo $login_script; }
}
else {
    echo fuckoff;
}

?>
