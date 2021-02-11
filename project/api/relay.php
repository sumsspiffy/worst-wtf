<?php
// Database Link
$ini = parse_ini_file('config.ini');
$link = mysqli_connect($ini['db_host'], $ini['db_user'], $ini['db_password']);
$database = mysqli_select_db($link, $ini['db_name']);
$tables = $ini['mybb_usertable'];

// Required User Requests
$source = $_SERVER[REMOTE_ADDR]; // request source
$username = $_POST['user']; 
$password = $_POST['pass'];
$steamname = $_POST['name'];
$steamid = $_POST['id'];
$steam64 = $_POST['id64'];

// Required Server Requests
$server_ip = $_POST['server_ip'];
$server_name = $_POST['server_name'];

// Authentication Checks
$Authorized = false;
$Verified;

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
            case 2: $Verified = 1; break; // registered
            case 3: $Verified = 1; break; // super-moderator
            case 4: $Verified = 1; break; // administrator
            case 6: $Verified = 1; break; // moderator
            case 7: $Verified = 0; break; // banned
        }
    }
}
else { 
    // source credentials were incorrect
    $Verified = 2;
}

// Server To Game Responses
$Failed = "a4dF91aE25c2BFD11F879e42";
$Response;

if ($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") 
{
    if ($Authorized && $Verified == 1) { 
        $Response = "User's Authed";
    }

    elseif($Authorized && $Verified == 0) { 
        $Response = "User's Banned";
        echo $Failed;
    }

    else { 
        $Response = "User's Invalid";
        echo $Failed;
    }

    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "",
                "color" => hexdec("#86ffba"),
                "timestamp" => date("c", strtotime("now")),
                "description" => "```$Response\nUsername: $username\nSourceAddr: $source\nIgnName: $steamname\nSteamID: $steamid\nSteamID64: $steam64\nServer: $server_name\nServerIp: $server_ip```",
                "footer" => [
                    "text" => "Worst-Relay",
                ]
            ]
        ]
    ]);
    
    $curl=curl_init("https://discord.com/api/webhooks/792498983997276191/PQ4t15hYAeRJbqSkpOYLgyfjXnvP_6d-CYIBjcrsFxuCSfjESXXrYAAzuYnM-fQs0QNi");
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_HEADER, 0);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
    curl_exec($curl);
}
else { 
    echo("fuckoff");
}

?>