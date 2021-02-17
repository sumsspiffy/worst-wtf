<?php
require_once("config.php");

$group = $local['usergroup'];
if($group == "admin") { 
    $Connections = "<a href='connections.php' class='nav'>Connections</a>";
}

$username = $local['username'];
$avatar = $local['avatar'];
$uid = $local['uid'];

echo("<div class='navbar-header'>
    <script src='./js/jquery.min.js'></script>
    <script src='./js/dashboard.js'></script>
    <a href='dashboard.php'><img class='banner' src='img/banner.png'></a>
    <button id='dropdown' class='btn transparent effect-click'>
        <img id='avatar' class='rounded-circle header-pfp' src='$avatar'>
        <span id='name'>$username</span>
    </button>
    <div class='dropdown-settings'>
        <form action='profile.php' method='get'><button type='submit' name='uid' value='$uid' class='btn dropdown effect-click'>Profile</button></form>
        <form action='settings.php' method='post'><button type='submit' class='btn dropdown effect-click'>Settings</button></form>
        <form action='login.php' method='post'><button type='submit' name='logout' class='btn dropdown effect-click'>Logout</button></form> 
    </div>
</div>
<div class='bottom-navbar'>
    <a href='info.php' class='nav'>Info</a>
    <a href='members.php' class='nav'>Members</a>
    $Connections
</div>
");

?>