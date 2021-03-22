<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

// handler
$type = $_GET['type'];

// the four ways of getting the user - uid, username, token, discord
if($type == "uid") { $uid = $_GET['uid']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['uid' => $uid])[0]; }
if($type == "username") { $username = $_GET['username']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['username' => $username])[0]; }
if($type == "discord") { $discord= $_GET['discord']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['discord' => $discord])[0]; }
if($type == "token") { $token = $_GET['token']; $AccountInfo = $GLOBALS['database']->GetContent('users', ['token' => $token])[0]; }

// if no type, or the request was invalid
if(!$type || !$AccountInfo) { $Local::Redirect("404 Error"); }

?>

<html>
    <head>
        <title>Worst</title>
        <meta charset="utf-8">
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="js/jquery.min.js"></script>
        <link rel='stylesheet' href='css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="js/ripple.js"></script>
        <style>span {color: #ccccccbb;}</style>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card"><br>
                <?php
                    $blacklist =$AccountInfo['blacklist'];
                    $username = $AccountInfo['username'];
                    $verified = $AccountInfo['verified'];
                    $discord = $AccountInfo['discord'];
                    $avatar = $AccountInfo['avatar'];
                    $token = $AccountInfo['token'];
                    $email = $AccountInfo['email'];
                    $date = $AccountInfo['date'];
                    $role = $AccountInfo['role'];
                    $uid = $AccountInfo['uid'];
                    $ip = $AccountInfo['ip'];
                    
                    if($Local::IsAdmin()) {
                        $AdminInfo = "<td class='profile-text'><strong>Email: <span>$email</span></strong></td>
                        <td class='profile-text'><strong>IP Address: <span>$ip</span></strong></td>
                        <td class='profile-text'><strong>Token: <span>$token</span></strong></td>";
                        $AdminButton = "<div class='button-container' style='padding-top:20px;padding-bottom:10px;'><button class='button material-ripple hover'>Blacklist</button></div>";
                    }

                    echo("<img class='profile-pfp circle' src='$avatar' onerror=this.src='img/pic.png'>
                    <h1 class='profile-header'>$username</h1>
                    <div class='profile-box'>
                        <table class='profile-items'>
                            <td class='profile-text'><strong>UID: <span>$uid</span></strong></td>
                            <td class='profile-text'><strong>Role: <span>$role</span></strong></td>
                            <td class='profile-text'><strong>Verified: <span>$verified</span></strong></td>
                            <td class='profile-text'><strong>Blacklisted: <span>$blacklist</span></strong></td>
                            <td class='profile-text'><strong>Creation: <span>$date</span></strong></td>
                            <td class='profile-text'><strong>Discord: <span>$discord</span></strong></td>
                            $AdminInfo
                        </table>
                    </div>$AdminButton<br>");
                ?>
            </div>
        </div>
    </body>
</html>
<script>
    <?php echo("$('.button').click(function() { $.post('auth/simple.php?request=blacklist', { username: '$username' }); location.reload(); });"); ?>
</script>
