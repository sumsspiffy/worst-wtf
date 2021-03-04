<?php
require_once("../core/config.php");

if(!$Local::IsActive()) {
    $Local::Redirect("Invalid Session");
}

if(!$Local::IsVerified()) {
    $Local::Redirect("Waiting for email activation");
}

if($Local::IsBlacklisted()) {
    $Local::Redirect("Blacklisted");
}

$LocalInfo = $Local::Info();
$username = $LocalInfo['username'];
$avatar = $LocalInfo['avatar'];
$uid = $LocalInfo['uid'];

if(empty($LocalInfo['discord'])) {
    header("Location: https://w0rst.xyz/beta/core/auth/discord.php?action=login");
}

?>

<div class="navbar">
    <a href="dashboard"><img class="banner" src="img/banner.png"></a>
    <div class="dropdown-holder">
        <div class="button-drop material-ripple" onclick="dropdown()">
            <?php echo("<img class='circle pfp' src='$avatar' onerror=this.src='img/avatar.png'>"); ?>
            <?php echo("<span class='name'>$username</span>"); ?>
        </div>
        <div class="dropdown">
            <a class="dropdown-item" href="account">Account</a>
            <a class="dropdown-item">Script</a>
            <a class="dropdown-item" href="core/auth/simple?request=logout">Logout</a>
        </div>
    </div>
</div>
<script>
    function dropdown() { $(".dropdown").fadeToggle(250); }
</script>