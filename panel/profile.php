<?php 
session_start();
require_once("config.php");

$userkey = $_SESSION['userkey'];
$active = $_SESSION['active'];

if($active != true) { header('Location: http://www.pornhub.com/'); }

// define important user variables
$discordid;
$emailaddr;
$username;
$usergroup;
$avatar;
$uid = $_GET['uid'];

$result = $link->query("SELECT * FROM usertable WHERE uid = '$uid'");

if ($result->num_rows > 0) { 
    while($row = $result->fetch_assoc()) { 
        $uid = $row['uid'];
        $emailaddr = $row['email'];
        $username = $row['username']; 
        $usergroup = $row['usergroup'];
        $discordid = $row['discordid'];
        $ipaddress = $row['ipaddress'];
        $avatar = $row['avatar'];
        if(empty($discordid)) { $discordid = "NULL"; }
        if(empty($avatar)) { $avatar = "./img/avatar.png"; }
    }
} else { 
    header("Location: error.html");
}

$Admin = false;
$usercheck = $link->query("SELECT * FROM usertable WHERE userkey = '$userkey'");
if ($userkey->num_rows > 0) { 
    while($row = $usercheck->fetch_assoc()) { 
        if($row['usergroup'] = "admin") { $Admin = true; } 
    } 
}

$html = "
<div class='profile-card'>
    <img class='rounded-circle profile-pfp' src='$avatar'>
    <span class='profile-name'>$username</span></button>
    <div class='profile-info'>
        <h4 class='info-header'>User-Information</h4>
        <p class='info-text'><strong>Email: </strong><span>$emailaddr</span></p>
        <p class='info-text'><strong class='info-item'>Discord-Id: </strong><span class='info-value'>$discordid</span></p>
        <p class='info-text'><strong>Usergroup: </strong><span>$usergroup</span></p>
        <p class='info-text'><strong>UID: </strong><span>$uid</span></p>
    </div>
</div>";


// if($Admin) { echo("<p class='info-text'><strong>Ip-Address: </strong><span>$ipaddress</span></p>"); }

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); echo($html); ?>
    </body>
</html>