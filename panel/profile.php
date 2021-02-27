<?php 
require_once('config.php');

$uid = $_GET['uid'];
$usertable = $link->query("SELECT * FROM usertable WHERE uid = '$uid'");

// if the user doesn't exist dont gather their info just redirect
if($usertable->num_rows > 0) { $usertable = $usertable->fetch_assoc(); }
else { header('Location: https://w0rst.xyz/panel/error?error=Invalid user'); }

$user = array(
    'uid' => $usertable['uid'],
    'email' => $usertable['email'],
    'username' => $usertable['username'],
    'password' => $usertable['password'],
    'usergroup' => $usertable['usergroup'],
    'blacklist' => $usertable['blacklist'],
    'ipaddress' => $usertable['ipaddress'],
    'discordid' => $usertable['discordid'],
    'avatar' => $usertable['avatar']
);

// user vars
$discord = $user['discordid'];
$ipaddress = $user['ipaddress'];
$usergroup = $user['usergroup'];
$blacklist = $user['blacklist'];
$username = $user['username'];
$avatar = $user['avatar'];
$email = $user['email'];

// size vars 
$card_height = "37rem";
$info_height = "12.5rem";

$group = $local['usergroup'];
if($group == "admin") { 
    $ipinfo = "<p class='profile-text'><strong>Ip-Address: </strong><span>$ipaddress</span></p>";
    $button = "<button class='btn admin-edit material-ripple'>Edit Information</button>";
    $emailinfo = "<p class='profile-text'><strong>Email: </strong><span>$email</span></p>";
    $discordinfo = "<p class='profile-text'><strong class='info-item'>Discord-Id: </strong><span class='info-value'>$discord</span></p>";
    $card_height = "46.5rem";
    $info_height = "18.5rem";
    $position = "1.2%";
}

$html = "
<div class='profile-card' style='margin-top:$position;height:$card_height;'>
    <img class='rounded-circle profile-pfp' src='$avatar'>
    <span class='profile-name'>$username</span>
    <div class='profile-info' style='height:$info_height;'>
        <h4 class='profile-header'>User-Information</h4>
        $ipinfo
        $emailinfo
        $discordinfo
        <p class='profile-text'><strong>Usergroup: </strong><span>$usergroup</span></p>
        <p class='profile-text'><strong>Blacklisted: </strong><span>$blacklist</span></p>
        <p class='profile-text'><strong>UID: </strong><span>$uid</span></p>
    </div>
    $button
</div>
<div class='fade-background1'>
    <div class='password-card' style='width: 36rem; height: 14rem;'>
        <form method='post' id='update'>
            <div class='settings-frame' style='height: 145px;'>
                <input type='text' class='input usergroup' value='$usergroup' autocomplete='off'>
                <input type='text' class='input' id='blacklist' value='$blacklist' autocomplete='off'>
                <input type='text' class='input' id='uid' value='$uid' style='display:none;'>
            </div>
            <button type='submit' class='btn save material-ripple' style='width: 35rem;'>Update Information</button>
        </form>
    </div>
</div>";

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="js/jquery.min.js"></script>
        <script src='core/update.js'></script>
        <script src='js/ripple.js'></script>
    </head>
    <body>
        <?php 
            include_once('inc/navbar.php'); 
            echo($html); // show html
        ?>
        <script>
            var background = $('.fade-background1'); var card = $('.password-card');
            $('.admin-edit').click(function() { background.fadeIn(350); });
            $(document).mouseup(function(e) { 
                if(!card.is(e.target) && card.has(e.target).length === 0 && background.css('display') != 'none') { background.fadeOut(350); }
            })
        </script>
    </body>
</html>