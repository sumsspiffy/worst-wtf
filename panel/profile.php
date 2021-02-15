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
$blacklist;
$uid = $_GET['uid'];

$result = $link->query("SELECT * FROM usertable WHERE uid = '$uid'");

if ($result->num_rows > 0) { 
    while($row = $result->fetch_assoc()) { 
        $uid = $row['uid'];
        $emailaddr = $row['email'];
        $blacklist = $row['blacklist'];
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

// select local user
$user = $link->query("SELECT usergroup FROM usertable WHERE userkey = '$userkey'")->fetch_assoc();

// size vars for $html
$card_height = "37rem";
$info_height = "12.5rem";
$button;
$ipinfo;

if(isset($_POST['update'])) { 

    // gotta assign a new variable name ;()
    $blacklist_change = $_POST['blacklist'];
    $usergroup_change = $_POST['usergroup'];
    $Valid = true;

    $sql = "UPDATE usertable SET usergroup = '$usergroup_change', blacklist = '$blacklist_change' WHERE uid = '$uid'";
    if (empty($blacklist_change)) { $sql = "UPDATE usertable SET usergroup = '$usergroup_change' WHERE uid = '$uid'"; }
    if (empty($usergroup_change)) { $sql = "UPDATE usertable SET blacklist = '$blacklist_change' WHERE uid = '$uid'"; }

    if($Valid) { 
        $link->query($sql);
    }
}

if($row = $user) { 
    if($row['usergroup'] == "admin") {
        $ipinfo = "<p class='info-text'><strong>Ip-Address: </strong><span>$ipaddress</span></p>";
        $button = "<button class='btn admin-edit'>Edit Information</button>";
        $emailinfo = "<p class='info-text'><strong>Email: </strong><span>$emailaddr</span></p>";
        $discordinfo = "<p class='info-text'><strong class='info-item'>Discord-Id: </strong><span class='info-value'>$discordid</span></p>";
        $card_height = "46.5rem";
        $info_height = "18.5rem";
        $position = "3.2%";
    }
}

$html = "
<div class='profile-card' style='margin-top:$position;height:$card_height;'>
    <img class='rounded-circle profile-pfp' src='$avatar'>
    <span class='profile-name'>$username</span>
    <div class='profile-info' style='height:$info_height;'>
        <h4 class='info-header'>User-Information</h4>
        $ipinfo
        $emailinfo
        $discordinfo
        <p class='info-text'><strong>Usergroup: </strong><span>$usergroup</span></p>
        <p class='info-text'><strong>Blacklisted: </strong><span>$blacklist</span></p>
        <p class='info-text'><strong>UID: </strong><span>$uid</span></p>
    </div>
    $button
</div>
<div class='fade-background'>
    <div class='password-card' style='width: 36rem; height: 14rem;'>
        <form method='post'>
            <div class='settings-frame' style='height: 145px;'>
                <input type='text' class='input' name='usergroup' placeholder='admin/user' autocomplete='off'>
                <input type='text' class='input' name='blacklist' placeholder='true/false' autocomplete='off'>
            </div>
            <button type='submit' name='update' class='btn save' style='width: 35rem;'>Update Information</button>
        </form>
    </div>
</div>";

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); echo($html); ?>
        <script>
            var background = $('.fade-background'); var card = $('.password-card');
            $('.admin-edit').click(function() { background.fadeIn(350); });
            $(document).mouseup(function(e) { 
                if(!card.is(e.target) && card.has(e.target).length === 0 && background.css('display') != 'none') { background.fadeOut(350); }
            })
        </script>
    </body>
</html>