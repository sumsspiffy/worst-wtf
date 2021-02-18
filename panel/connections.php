<?php
// https://stackoverflow.com/questions/20674797/save-post-data-to-page-indefinitely
// create database around user logs
// include all basic script info types
// CONNECTIONS | username,sourceaddr,ignname,steamid,steamid64,server,serverip
// FOR ADDING TO THE LOG TABLE INSERT DATA LIKE LOGIN.PHP
// ADD time & date as well $date = date("Y:m:d H:i:s")

require_once('config.php');

// redirect users
if ($active != true || $local['blacklist'] == 'true') { // if not active / blacklisted
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

// check if they are admins
$group = $local['usergroup'];
if($group != "admin") { 
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

$log = $link->query("SELECT * FROM logtable");
$rows = $log->num_rows;

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard/style.css'>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="middle-card" style="width:50%;height:75%;left: 0;right: 0;top: 0;bottom: 0;margin-top: 8.5%;margin-bottom:auto;margin-right: auto;margin-left: auto;">
            <?php
                foreach (range(1, $rows) as $id) {
                    // select from logtable where the id = range aka $log->num_rows
                    $info = $link->query("SELECT * FROM logtable WHERE id = '$id'")->fetch_assoc();

                    // define log variables
                    $log_username = $info['username'];
                    $log_ipaddress = $info['ipaddress'];
                    $log_steamid = $info['steamid'];
                    $log_steamid64 = $info['steamid64'];
                    $log_server = $info['server'];
                    $log_serverip = $info['serverip'];
                    $log_steamname = $info['steamname'];
                    $log_attempt = $info['attempt'];
                    $log_date = $info['date'];
                    $log_uid = $info['uid'];

                    // define users avatar
                    $user = $link->query("SELECT * FROM usertable WHERE username = '$log_username'")->fetch_assoc();
                    $log_avatar = $user['avatar']; // since the avatar isn't stored in the log database ¯\_(ツ)_/¯
                    if(empty($log_avatar)) { $log_avatar = "./img/avatar.png"; } // if the user has no avatar

                    echo("<div class='log-select'>
                        <a href='profile.php?uid=$log_uid'><img class='rounded-circle log-pfp' src='$log_avatar'></a>
                        <h1 class='log-header'>$log_attempt</h1>
                        <table class='log-items'>
                            <tr>
                                <td class='log-text'><strong>UID: </strong><span>$log_uid</span></td>
                                <td class='log-text'><strong>Username: </strong><span>$log_username</span></td>
                                <td class='log-text'><strong>Ip-Address: </strong><span>$log_ipaddress</span></td>
                                <td class='log-text'><strong>Steam-Name: </strong><span>$log_steamname</span></td>
                                <td class='log-text'><strong>Steam-Id: </strong><span>$log_steamid</span></td>
                                <td class='log-text'><strong>Steam-Id64: </strong><span>$log_steamid64</span></td>
                                <td class='log-text'><strong>Server-Name: </strong><span>$log_server</span></td>
                                <td class='log-text'><strong>Server-Ip: </strong><span>$log_serverip</span></td>
                                <td class='log-text'><strong>Date: </strong><span>$log_date</span></td>
                            </tr>
                        </table>
                    </div>");
                }
            ?>
        </div>
    </body>
</html>