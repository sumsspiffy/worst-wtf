<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

$method = $_POST['method'];
if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") {
    if($method == "display") {
        echo file_get_contents('../bin/nets');
    }

    if($method == "upload") {
        $user = $_POST['user'];
        $pass = $_POST['pass'];
        $net = $_POST['net'];

        if($Script::Login($user, $pass)) {
            if($Script::IsAdmin($user)) {
                file_put_contents($_SERVER['DOCUMENT_ROOT']."/project/bin/nets", "$net ", FILE_APPEND | LOCK_EX); 
                echo 0; // just a response for the script to know it was uploaded
            } else {echo 1;}
        }
    }
}

?>