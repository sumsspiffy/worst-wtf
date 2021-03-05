<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

$uid = $_GET['uid'];

$AccountInfo = $GLOBALS['database']->GetContent('users', ['uid' => $uid])[0];
if(!$AccountInfo) { $Local::Redirect("Invalid uid"); } // redirect if uid isn't valid

?>

<html>
    <head>
        <title>Worst</title>
        <meta charset="utf-8">
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
                    $discord = $AccountInfo['discord'];
                    $avatar = $AccountInfo['avatar'];
                    $email = $AccountInfo['email'];
                    $date = $AccountInfo['date'];
                    $role = $AccountInfo['role'];
                    $uid = $AccountInfo['uid'];
                    $ip = $AccountInfo['ip'];

                    if($Local::IsAdmin()) {
                        $IPInfo = "<td class='profile-text'><strong>IP Address: <span>$ip</span></strong></td>";
                        $EmailInfo = "<td class='profile-text'><strong>Email: <span>$email</span></strong></td>";
                    }
                    
                    echo("
                    <img class='profile-pfp circle' src='$avatar' onerror=this.src='img/avatar.png'>
                    <h1 class='profile-header'>$username</h1>
                    <div class='profile-box'>
                        <table class='profile-items'>
                            <td class='profile-text'><strong>UID: <span>$uid</span></strong></td>
                            <td class='profile-text'><strong>Role: <span>$role</span></strong></td>
                            <td class='profile-text'><strong>Blacklisted: <span>$blacklist</span></strong></td>
                            <td class='profile-text'><strong>Creation: <span>$date</span></strong></td>
                            <td class='profile-text'><strong>Discord ID: <span>$discord</span></strong></td>
                            $EmailInfo
                            $IPInfo
                        </table>
                    </div><br>");
                ?>
            </div>
        </div>
    </body>
</html>
