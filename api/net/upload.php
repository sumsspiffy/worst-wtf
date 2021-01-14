<?php
$str = $_POST["s"];
$net_path = fopen($_SERVER['DOCUMENT_ROOT'].'/bin/nets', "a");

if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") { 
    fwrite($net_path, "$str ");
}
else { 
    echo fuckoff;
}

fclose($net_path);
?>