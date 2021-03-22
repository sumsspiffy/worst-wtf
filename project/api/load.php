<?php

$method = $_POST['method'];
$script = "38242EEbAbbbE56A7eDf1E09";
$login = "FdCdcCDcDa4a58Fe9dc042BA";

if ($method == $login) { echo file_get_contents('../func/login.lua'); } // Login Script
if ($method == $script) { echo file_get_contents('../func/w0rst.lua'); } // Main Script

?>
