<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

// request date
date_default_timezone_set('PST');
$date = date("Y:m:d H:i:s");

// website info
$ip = $_SERVER[REMOTE_ADDR];
$user = $_POST['user'];
$pass = $_POST['pass'];

// game info
$steam = $_POST['steam'];
$steamid = $_POST['steamid'];
$steamid64 = $_POST['steamid64'];
$serverip = $_POST['serverip'];
$server = $_POST['server'];

if($Script::Login($user, $pass)) { 
    echo("authed"); // let the user know there authed

    // get the account info for later
    $AccountInfo = $Account::Info($user);

    // we need to assign this, brcause we don't post this
    // but this infos nice to have in the log ;0
    $uid = $AccountInfo['uid'];
    $role = $AccountInfo['role'];

    $GLOBALS['database']->Insert('logs', ["uid" => $uid, "role" => $role, "username" => $user, "ip" => $ip, "steam" => $steam, "steamid" => $steamid, "steamid64" => $steamid64, "server" => $server, "serverip" => $serverip, "date" => $date]);
}

$json_data = json_encode([
    "embeds" => [
        [
            "title" => "",
            "color" => hexdec("#86ffba"),
            "timestamp" => date("c", strtotime("now")),
            "description" => "```Username: $user\nIP Address: $ip\nSteam Name: $steam\nSteam Id: $steamid\nSteam Id64: $steamid64\nServer: $server\nServer IP: $serverip\n```",
            "footer" => [
                "text" => "Worst-Logging",
            ]
        ]
    ]
]);

$curl=curl_init("https://discord.com/api/webhooks/811023303861993513/sLpyMSf7o7VTuXhGAwPKK52EUIk9DQ02vD8nsoHBAYnaSOJG8T6LiZgcJUym8x-kUuM5");
curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($curl, CURLOPT_HEADER, 0);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
curl_exec($curl);

?>