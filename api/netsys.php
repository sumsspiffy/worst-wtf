<?php
// Database Link
$ini = parse_ini_file('config.ini');
$link = mysqli_connect($ini['db_host'], $ini['db_user'], $ini['db_password']);
$database = mysqli_select_db($link, $ini['db_name']);
$tables = $ini['mybb_usertable'];

// Required Requests
$username = $_POST['u'];
$password = $_POST['p'];
$NetString = $_POST['n'];

// User Check Responses
$Authorized = false;
$Verified = false;

// Upload/View Methods
$method = $_POST['method']; 
$varUpload = "A0791AfFA0F30EdCee1EdADb";
$varDisplay = "02C2C6A1Ded7183AeDAA8650";

///////////////////////////////////////

$sql = "SELECT * FROM ". $tables ." WHERE username = '". mysqli_real_escape_string($link, $username) ."'" ;
$results = $link->query($sql);

if ($results->num_rows > 0)
{
    while($row = $results->fetch_assoc()) 
    {
        $password = md5(md5($row['salt']).$password);
        $group = $row['usergroup'].$row['additionalgroups'];
        if($password == $row['password']) { $Authorized = true; }

        switch($group) {
            case 2: $Verified = false; break; // registered
            case 3: $Verified = true; break; // super-moderator
            case 4: $Verified = true; break; // administrator
            case 6: $Verified = true; break; // moderator
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
            fwrite($path, "$NetString ");
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