<?php
require_once($_SERVER["DOCUMENT_ROOT"]."/beta/config.php");

if(!$Local::IsActive()) {
    $Local::Redirect("Invalid Session");
}

if($Local::IsBlacklisted()) {
    $Local::Redirect("Blacklisted");
}

$LocalInfo = $Local::Info();

$username = $LocalInfo['username'];
$avatar = $LocalInfo['avatar'];
$uid = $LocalInfo['uid'];

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
    var toggled = false;
    function dropdown() {
        toggled = !toggled
        if(toggled) {
            $(".dropdown").fadeIn().css("display","block");
            $('.dropdown-holder').css({"padding-top":"11px"});
        } else {
            $(".dropdown").fadeIn().css("display","none");
            $('.dropdown-holder').css({"padding-top":"0px"});
        }
    }
</script>