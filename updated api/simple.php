<?php 
require_once('config.php');

// Required User Requests
$source = $_SERVER[REMOTE_ADDR]; // request source
$date = date("Y:m:d H:i:s"); // request date
$username = $_POST['user']; 
$password = $_POST['pass'];
$steamname = $_POST['name'];
$steamid = $_POST['id'];
$steam64 = $_POST['id64'];
$server = $_POST['server'];
$serverip = $_POST['serverip'];

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
$Banned = "ceFF46F38e74D172DE8c8ab4";
$Response;

if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") {
    if($link->query($sql) === false) { echo $link->error; }

    if ($Authorized && $Verified == 1) { 
        $Response = "User's Authed";
        echo $Authed;
    }

    elseif($Authorized && $Verified == 0) { 
        $Response = "Failed User's Banned";
        echo $Banned;
    }

    else { 
        $Response = "Failed User's Invalid";
        echo $Failed;
    }

    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "",
                "color" => hexdec("#86ffba"),
                "timestamp" => date("c", strtotime("now")),
                "description" => "```$Response\nUsername: $username\nSourceAddr: $source\nIgnName: $steamname\nSteamID: $steamid\nSteamID64: $steam64\n```",
                "footer" => [
                    "text" => "Worst-Connections",
                ]
            ]
        ]
    ]);

    // log the request into the database
    $sql = "INSERT INTO logtable (uid, username, ipaddress, usergroup, steamname, steamid, steamid64, server, serverip, date, attempt) 
    VALUES ('$uid','$username','$source','$group','$steamname','$steamid','$steam64', '".mysqli_real_escape_string ($link , $server)."' ,'".mysqli_real_escape_string ($link , $serverip)."','$date', '$Response')";
    
    // send log embed
    $curl=curl_init("https://discord.com/api/webhooks/792499071586795570/lRnGlK59a4Bp3JDmoJdTCyBqtkZkfL7QczXDAW69IHOeWF8VQefS6yCBbZrc8EPAhUH7");
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_HEADER, 0);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_exec($curl);
}
else { 
    echo("fuckoff");
}


?>