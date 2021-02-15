<?php 
require_once('config.php');

// Required User Requests
$username = $_POST['user']; 
$password = $_POST['pass'];

// Authentication Checks
$Authorized = false;
$Verified;

///////////////////////////////////////
$results = $link->query("SELECT * FROM usertable WHERE username = '$username'");

if ($results->num_rows > 0) {
    while($row = $results->fetch_assoc()) {
        $uid = $row['uid'];
        $group = $row['usergroup'];
        $blacklist = $row['blacklist'];

        if($password == $row['password']) { $Authorized = true; }
        if($blacklist == "true") { $Verified = 0; }

        switch($group) {
            case "user": $Verified = 1; break; 
            case "admin": $Verified = 1; break; 
        }
    }
}
else { 
    // source credentials were incorrect
    $Verified = 2;
}

// Server To Game Responses
$Authed = "8C86cCa59c14Dad83ddB4D0A";
$Failed = "20BC7d5E2fd1D6FF9bea2BFf";

if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") {
    if ($Authorized && $Verified == 1) { 
        echo $Authed;
    }

    elseif($Authorized && $Verified == 0) { 
        echo $Failed;
    }

    else { 
        echo $Failed;
    }
}
else { 
    echo("fuckoff");
}


?>