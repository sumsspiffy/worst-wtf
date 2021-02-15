<?php
// https://stackoverflow.com/questions/20674797/save-post-data-to-page-indefinitely
// create database around user logs
// include all basic script info types
// CONNECTIONS | username,sourceaddr,ignname,steamid,steamid64,server,serverip
// FOR ADDING TO THE LOG TABLE INSERT DATA LIKE LOGIN.PHP
// ADD time & date as well $date = date("Y:m:d H:i:s")

session_start();
require_once("config.php");

$userkey = $_SESSION['userkey'];
$active = $_SESSION['active'];

// go to usertable and look for the user connection to the site
$user = $link->query("SELECT * FROM usertable WHERE userkey = '$userkey'")->fetch_assoc();

if($active != true) { header('Location: http://www.pornhub.com/'); }
if ($user['usergroup'] != 'admin') { header('Location: http://www.pornhub.com/'); }

$log = $link->query("SELECT * FROM logtable");
$log_rows = $log->num_rows;

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="middle-card" style="width:50%;height:75%;left: 0;right: 0;top: 0;bottom: 0;margin-top: 8.5%;margin-bottom:auto;margin-right: auto;margin-left: auto;">
            <?php
                foreach (range(1, $log_rows) as $id) {
                    // select from logtable where the id = range aka $log->num_rows
                    $result = $link->query("SELECT * FROM logtable WHERE id = '$id'")->fetch_assoc();
                    $log_username = $result['username'];
                    $log_ipaddress = $result['ipaddress'];
                    $log_steamid = $result['steamid'];
                    $log_steamid64 = $result['steamid64'];
                    $log_server = $result['server'];
                    $log_serverip = $result['serverip'];
                    $log_steamname = $result['steamname'];
                    $log_attempt = $result['attempt'];
                    $log_date = $result['date'];
                    $log_uid = $result['uid'];
                    
                    echo("<div class='log-select'>
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