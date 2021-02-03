<?php
$method = $_POST['method'];
$script = "38242EEbAbbbE56A7eDf1E09";
$login = "FdCdcCDcDa4a58Fe9dc042BA";

if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") 
{
    // Login Script
    if ($method == $login) { 
        echo file_get_contents('../func/login.lua');
    }

    // Main Script
    if ($method == $script) { 
        echo file_get_contents('../func/w0rst.lua');
    }
}
else {
    echo("fuckoff");
}

?>
