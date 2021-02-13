<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
    </head>
    <body>
        <h1>404</h1>
        <h2>Site Currently Under Construction.</h2>
        <p>for more information join our discord!<br><a href="./discord.php?action=login">Click Me!</a></p>
    </body>
</html>

<?php
session_start();
require_once("config.php");

// don't think about coming here un announced :flushed:
if($_SESSION['AUTHENTICATED'] == false) { 
    header('Location: http://www.pornhub.com/'); 
}

?>