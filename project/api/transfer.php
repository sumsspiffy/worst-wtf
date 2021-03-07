<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

$method = $_POST['method'];

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
            echo("added"); // just a response for the script to know it was uploaded
        }
    }
}

?>