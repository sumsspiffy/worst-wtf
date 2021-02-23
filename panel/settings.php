<?php 
require_once('config.php');

$username = $local['username'];
$email = $local['email'];
$avatar = $local['avatar'];

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="js/jquery.min.js"></script>
        <script src="js/settings.js"></script>
        <script src='./js/ripple.js'></script>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class='settings-card'>
            <div class='settings-frame'>
                <form id='update' autocomplete='on'>
                    <?php 
                        echo("<input type='text' class='input' id='username' value='$username'>
                        <input type='text' class='input' id='email' value='$email'>
                        <input type='text' class='input avatar' value='$avatar'>");
                    ?>
                </form>
                <button class='btn link material-ripple'>ReLink Discord</button>
                <button class='btn pass material-ripple'>Update Password</button>
            </div>
            <button form='update' type='submit' class='btn save material-ripple'>Save Settings</button>
        </div>
        <div class='fade-background'>
            <div class='password-card' style='width: 36rem; height: 14rem;'>
                <form id='updatepass' autocomplete='off'>
                    <div class='settings-frame' style='height: 145px;'>
                        <input type='text' class='input' id='oldpass' placeholder='old-password' style='-webkit-text-security: disc !important;'>
                        <input type='text' class='input' id='newpass' placeholder='new-password' style='-webkit-text-security: disc !important;'>
                    </div>
                    <button type='submit' class='btn save material-ripple' style='width: 35rem;'>Update Password</button>
                </form>
            </div>
        </div>
        <script>
            var pass = $('.pass'); var link = $('.link'); var background = $('.fade-background'); var card = $('.password-card');
            pass.click(function() { background.fadeIn(350); });
            link.click(function() { location.href = "discord.php?action=login"; });
            $(document).mouseup(function(e) { 
                if(!card.is(e.target) && card.has(e.target).length === 0 && background.css('display') != 'none') { background.fadeOut(350); }
            })
        </script>
    </body>
</html>