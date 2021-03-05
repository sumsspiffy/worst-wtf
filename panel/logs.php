<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

if(!$Local::IsAdmin()) {
    $Local::Redirect("Incorrect role");
}

$LogInfo = $Log::Script();

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
            <div class="card">
                <?php
                    foreach($LogInfo as $row) {
                        $username = $row['username'];
                        $steamid = $row['steamid'];
                        $steamid64 = $row['steamid64'];
                        $serverip = $row['serverip'];
                        $server = $row['server'];
                        $steam = $row['steam'];
                        $date = $row['date'];
                        $uid = $row['uid'];
                        $ip = $row['ip'];

                        $AccountInfo = $Account::Info($username);
                        $avatar = $AccountInfo['avatar'];

                        echo("<div class='log-box'>
                        <a href='profile?uid=$uid'><img class='log-pfp circle' src='$avatar' onerror=this.src='img/avatar.png'></a>
                            <table class='log-items'>
                                <td class='log-text'><strong>UID: </strong><span>$uid</span></td>
                                <td class='log-text'><strong>Username: </strong><span>$username</span></td>
                                <td class='log-text'><strong>IP Address: </strong><span>$ip</span></td>
                                <td class='log-text'><strong>Steam: </strong><span>$steam</span></td>
                                <td class='log-text'><strong>Steam ID: </strong><span>$steamid</span></td>
                                <td class='log-text'><strong>Steam ID64: </strong><span>$steamid64</span></td>
                                <td class='log-text'><strong>Server: </strong><span>$server</span></td>
                                <td class='log-text'><strong>Server IP: </strong><span>$serverip</span></td>
                                <td class='log-text'><strong>Date: </strong><span>$date</span></td>
                            </table>
                        </div>");
                    }
                ?>
            <br></div>
        </div>
    </body>
</html>
