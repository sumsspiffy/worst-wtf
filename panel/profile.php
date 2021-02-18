<?php 
require_once('config.php');

// redirect users
if ($active != true || $local['blacklist'] == 'true') { // if not active / blacklisted
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

$uid = $_GET['uid'];
$usertable = $link->query("SELECT * FROM usertable WHERE uid = '$uid'")->fetch_assoc();

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

if(isset($_POST['update'])) { 
    // gotta assign a new variable name ;()
    $blacklist = $_POST['blacklist'];
    $usergroup = $_POST['usergroup'];
    $Valid = true;

    $sql = "UPDATE usertable SET usergroup = '$usergroup', blacklist = '$blacklist' WHERE uid = '$uid'";
    if (empty($blacklist)) { $sql = "UPDATE usertable SET usergroup = '$usergroup' WHERE uid = '$uid'"; }
    if (empty($usergroup)) { $sql = "UPDATE usertable SET blacklist = '$blacklist' WHERE uid = '$uid'"; }

    if($Valid) { 
        $link->query($sql);
    }
}

// user vars
$discord = $user['discordid'];
$ipaddress = $user['ipaddress'];
$email = $user['email'];
$usergroup = $user['usergroup'];
$blacklist = $user['blacklist'];
$username = $user['username'];
$avatar = $user['avatar'];

// size vars 
$card_height = "37rem";
$info_height = "12.5rem";

$group = $local['usergroup'];
if($group == "admin") { 
    $ipinfo = "<p class='profile-text'><strong>Ip-Address: </strong><span>$ipaddress</span></p>";
    $button = "<button class='btn admin-edit'>Edit Information</button>";
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
        <link rel='stylesheet' href='./css/dashboard/style.css'>
    </head>
    <body>
        <?php 
            include_once('inc/navbar.php'); 
            echo($html); // show html
        ?>
        <script>
            var background = $('.fade-background'); var card = $('.password-card');
            $('.admin-edit').click(function() { background.fadeIn(350); });
            $(document).mouseup(function(e) { 
                if(!card.is(e.target) && card.has(e.target).length === 0 && background.css('display') != 'none') { background.fadeOut(350); }
            })
        </script>
    </body>
</html>