<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

$all = $Log::Server("all");
$public = $Log::Server("public");
$private = $Log::Server("private");

$Servers = array($public, $private);

if($Local::IsAdmin()) {
    $Servers = array($public, $private, $all);
    $All = "<button onclick='show(2)' class='button material-ripple hover'>All Servers</button>";
}

$i = 0; // this will be used for displaying the server tab

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
        <style type="text/css">
            span { color: #ccccccbb; }
            .S1, .S2 { display:none; }
        </style>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card">
                <div class="button-container">
                    <button onclick="show(0)" class="button material-ripple hover">Public Servers</button>
                    <button onclick="show(1)" class="button material-ripple hover">Private Servers</button>
                    <?php echo($All); ?>
                </div>
                <?php
                    // Im using for each for the servers because idgaf about the order they are
                    // if this were a list or something it would be diffrent, but its whatever
                    // if you want to know how to order it properly check out members or logs

                    // for each server then for each row
                    foreach($Servers as $row => $value) {

                        // 0/public 1/private 2/all servers
                        echo("<div class='flexbox S$i'>"); // setting the class as i for hiding

                        foreach($value as $row) {
                            $pass = $row['password'];
                            $mode = $row['gamemode'];
                            $name = $row['server'];
                            $date = $row['date'];
                            $map = $row['map'];
                            $net = $row['net'];
                            $ip = $row['ip'];

                            // echo("$name\n");
                            echo("<div class='server-box'>
                                <a href='steam://connect/$ip'><img class='server-pfp circle' src='img/steam.png'></a>
                                <table class='server-items'>
                                    <td class='server-text'><strong>Server: <span>$name</span></strong></td>
                                    <td class='server-text'><strong>Server IP: <span>$ip</span></strong></td>
                                    <td class='server-text'><strong>Password: <span>$pass</span></strong></td>
                                    <td class='server-text'><strong>Gamemode: <span>$mode</span></strong></td>
                                    <td class='server-text'><strong>Net: <span>$net</span></strong></td>
                                    <td class='server-text'><strong>Map: <span>$map</span></strong></td>
                                    <td class='server-text'><strong>Date: <span>$date</span></strong></td>
                                </table>
                            </div>");
                        }

                        echo("</div>");

                        $i++;
                    }
                ?>
            <br></div>
        </div>
    </body>
</html>
<script>
    function show(tab) {
        if(tab == 0) { $('.S0').fadeIn(250).css("display", "flex"); $('.S1').fadeOut(0); $('.S2').fadeOut(0); }
        if(tab == 1) { $('.S0').fadeOut(0); $('.S1').fadeIn(250).css("display", "flex"); $('.S2').fadeOut(0); }
        if(tab == 2) { $('.S0').fadeOut(0); $('.S1').fadeOut(0); $('.S2').fadeIn(250).css("display", "flex"); }
    }
</script>