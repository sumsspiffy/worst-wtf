<?php
require_once("config.php");

$group = $local['usergroup'];
if($group == "admin") { 
    $Connections = "<a href='connections.php' class='nav'>Connections</a>";
}

// ip update ;0
// since it's on the nav page
// it will run every time a user 
// logs onto the site..................

$userid = $local['uid'];
$ipaddr = $_SERVER['REMOTE_ADDR'];
if ($ipaddr != $local['ipaddress']) { 
    $link->query("UPDATE usertable SET ipaddress = '$ipaddr' WHERE uid = '$userid'");
}

$username = $local['username'];
$avatar = $local['avatar'];
$uid = $local['uid'];

echo("<div class='navbar-header'>
    <link rel='stylesheet' href='css/ripple.css'>
    <script src='./js/jquery.min.js'></script>
    <script src='./js/dashboard.js'></script>
    <script src='./js/ripple.js'></script>
    <a href='dashboard.php'><img class='banner' src='img/banner.png'></a>
    <button id='dropdown' class='btn transparent'>
        <img id='avatar' class='rounded-circle header-pfp' src='$avatar'>
        <span id='name'>$username</span>
    </button>
    <div class='dropdown-settings'>
        <a href='profile.php?uid=$uid'><button class='btn dropdown material-ripple' style='margin-top:2.5%;'>Profile</button></a>
        <a href='settings.php'><button class='btn dropdown material-ripple' style='margin-top:2.5%;'>Settings</button></a>
        <a href='auth/logout.php'><button name='logout' class='btn dropdown material-ripple' style='margin-top:2.5%;'>Logout</button></a>
    </div>
</div>
<div class='bottom-navbar'>
    <a href='info.php' class='nav'>Info</a>
    <a href='members.php' class='nav'>Members</a>
    $Connections
</div>
");

?>