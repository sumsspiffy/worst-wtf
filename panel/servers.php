<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

$Public = $Log::Server("public");
$Private = $Log::Server("private");
ksort($Public, SORT_NUMERIC);
ksort($Private, SORT_NUMERIC);

$Servers = array($Public, $Private);

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
        <style type="text/css">
            span { color: #ccccccbb; }
            .S1 { display:none; }
        </style>
    </head>
    <body>
        <!-- this is for knowing what page is open -->
        <div class="webpage" id="servers"></div>
        <!-- and here is the navbar that needs ^ -->
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card">
                <div class="button-container">
                    <button onclick="show(0)" class="button transparent" id="S1" style="opacity:1;">Public Servers</button>
                    <button onclick="show(1)" class="button transparent" id="S2">Private Servers</button>
                </div>
                <?php
                    // Im using for each for the servers because idgaf about the order they are
                    // if this were a list or something it would be diffrent, but its whatever
                    // if you want to know how to order it properly check out members or logs

                    $loop = 0; // the loop for public/private servers

                    // for each server then for each row
                    foreach($Servers as $row) {

                        // 0 - public | 1 - private
                        $loop++; // add one to the loop
                        echo("<div class='flexbox S$i'>"); // setting the class as i for hiding

                        foreach($row as $row) {
                            $pass = $row['password'];
                            $mode = $row['gamemode'];
                            $name = $row['server'];
                            $type = $row['type'];
                            $date = $row['date'];
                            $map = $row['map'];
                            $net = $row['net'];
                            $id = $row['id'];
                            $ip = $row['ip'];

                            $token = $row['token']; // this is for getting the tpye of server as well the users info             
                            $username = $GLOBALS['database']->GetContent('users', ['token' => $token])[0]["username"];

                            // echo("$name\n");
                            echo("<div class='l-box'>
                                <table class='l-item'>
                                    <td class='l-text'><a onclick='profile(`username`, `$username`)' style='cursor:pointer;'><strong>By: <span>$username</span></strong></td></a>
                                    <td class='l-text'><strong>Type: <span>$type</span></strong></td>
                                    <td class='l-text'><strong>Server: <span>$name</span></strong></td>
                                    <td class='l-text'><strong>Server IP: <span>$ip</span></strong></td>
                                    <td class='l-text'><strong>Password: <span>$pass</span></strong></td>
                                    <td class='l-text'><strong>Gamemode: <span>$mode</span></strong></td>
                                    <td class='l-text'><strong>Net: <span>$net</span></strong></td>
                                    <td class='l-text'><strong>Map: <span>$map</span></strong></td>
                                    <td class='l-text'><strong>Date: <span>$date</span></strong></td>
                                    <td><div class='button-container' style='display:block;padding:0;margin:0;'>
                                        <button class='button material-ripple hover' id='C$id' onclick='link(`steam://connect/$ip`)' style='margin-bottom:5px;'>Connect</button>
                                        <button class='button material-ripple hover' id='R$id' style='margin-top:5px;'>Remove</button>
                                        <script>
                                            // send request and wait for response ;0
                                                $('#R$id').click(function() { 
                                                    if(confirm('Are you sure you want to remove $name?')) {
                                                        $.post('req/simple.php?request=server&token=$token', { type: 'remove', id: '$id' }, function(response) {
                                                            // this is a basic if clicked then refresh...
                                                            if(!response) { if(!alert('Removed')) {  window.location.reload(); } } else { alert(response) }
                                                        }); 
                                                    }
                                                });
                                        </script>
                                    </div></td> 
                                </table>
                            </div>");

                            unset($By); // by needs to be reset every loop
                        }

                        echo("</div>");
                    }
                ?>
            <br></div>
        </div>
    </body>
</html>
<script>
    function show(tab) {
        if(tab == 0) { $('.S0').fadeIn(250).css({"display":"flex"}); $('.S1').fadeOut(0); $('.S2').fadeOut(0); $('#S0').fadeTo(50, 1); $('#S1').fadeTo(50, 0.55); }
        if(tab == 1) { $('.S0').fadeOut(0); $('.S1').fadeIn(250).css({"display":"flex"}); $('.S2').fadeOut(0); $('#S0').fadeTo(50, 0.55); $('#S1').fadeTo(50, 1); }
    }
</script>