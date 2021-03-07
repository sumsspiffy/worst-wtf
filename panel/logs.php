<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

if(!$Local::IsAdmin()) {
    $Local::Redirect("incorrect role");
}

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
            <div class="card">
                <?php
                    $total = $GLOBALS['database']->Count("logs");  // total amount of logs

                    for($x = 0; $x < $total; $x++) {
                        $LogInfo = $GLOBALS['database']->GetContent('logs', ['id' => $x+1])[0];
                        
                        $username = $LogInfo['username'];
                        $steamid = $LogInfo['steamid'];
                        $steamid64 = $LogInfo['steamid64'];
                        $serverip = $LogInfo['serverip'];
                        $server = $LogInfo['server'];
                        $steam = $LogInfo['steam'];
                        $date = $LogInfo['date'];
                        $uid = $LogInfo['uid'];
                        $ip = $LogInfo['ip'];

                        $AccountInfo = $Account::Info($username);
                        $avatar = $AccountInfo['avatar'];

                        if($LogInfo) { // if info actually exists
                            echo("<div class='log-box'>
                                <table class='log-items'>
                                    <td class='log-text'><strong>UID: <span>$uid</span></strong></td>
                                    <td class='log-text'><strong>Username: <span>$username</span></strong></td>
                                    <td class='log-text'><strong>IP Address: <span>$ip</span></strong></td>
                                    <td class='log-text'><strong>Steam: <span>$steam</span></strong></td>
                                    <td class='log-text'><strong>Steam ID: <span>$steamid</span></strong></td>
                                    <td class='log-text'><strong>Steam ID64: <span>$steamid64</span></strong></td>
                                    <td class='log-text'><strong>Server: <span>$server</span></strong></td>
                                    <td class='log-text'><strong>Server IP: <span>$serverip</span></strong></td>
                                    <td class='log-text'><strong>Date: <span>$date</span></strong></td>
                                    <td><a href='profile?uid=$uid'><img class='log-pfp circle' src='$avatar' onerror=this.src='img/pic.png'></a></td>
                                </table>
                            </div>");
                        }   
                    }
                ?>
            <br></div>
        </div>
    </body>
</html>
