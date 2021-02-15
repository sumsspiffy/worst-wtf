<?php
session_start();
require_once("config.php");

$userkey = $_SESSION['userkey'];
$active = $_SESSION['active'];

// don't think about coming here un announced :flushed:
$result = $link->query("SELECT * FROM usertable WHERE userkey = '$userkey'");

$discordid;
$username;
$avatar;

if ($result->num_rows > 0) { 
    while($row = $result->fetch_assoc()) { 
        $discordid = $row['discordid'];
        $username = $row['username'];
        $avatar = $row['avatar'];
        $uid = $row['uid'];

        if(empty($avatar)) { $avatar = "./img/avatar.png"; }
    }
}

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
</div>");

?>