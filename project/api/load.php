<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

$method = $_POST['method'];
$script = "38242EEbAbbbE56A7eDf1E09";
$login = "FdCdcCDcDa4a58Fe9dc042BA";

if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)")  {

    if ($method == $login) { echo file_get_contents('../func/login.lua'); } // Login Script
    if ($method == $script) { echo file_get_contents('../func/w0rst.lua'); } // Main Script

}

else { $Local::Redirect(""); }

?>
