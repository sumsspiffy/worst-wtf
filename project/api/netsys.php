<?php
require_once('config.php');

// Required Requests
$username = $_POST['u'];
$password = $_POST['p'];
$netstring = $_POST['n'];

// User Check Responses
$Authorized = false;
$Verified = false;

// Upload/View Methods
$method = $_POST['method']; 
$varUpload = "A0791AfFA0F30EdCee1EdADb";
$varDisplay = "9fbDeC7b2bA1656b26dC4b7a";

///////////////////////////////////////
$results = $link->query("SELECT * FROM usertable WHERE username = '$username'");

if ($results->num_rows > 0) {
    while($row = $results->fetch_assoc()) {
        if($password == $row['password']) { $Authorized = true; }

        switch($row['usergroup']) {
            case "user": $Verified = false; break; 
            case "admin": $Verified = true; break; 
        }
    }
}

// Detect Game Server
if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") 
{
    // Display 
    if ($method == $varDisplay) {
        $content = file_get_contents('../bin/nets');
        echo $content;
    }

    // Upload 
    if ($method == $varUpload) {
        if ($Authorized && $Verified) { 
            $path = fopen("../bin/nets", "a");
            fwrite($path, "$netstring ");
            echo 0;
        }
        else {
            echo 1;
        }
    }
}
else {
    echo("fuckoff");
}

?>