<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
        <script src="./js/jquery.min.js"></script>
    </head>
    <body>
        
    </body>
</html>

<?php
session_start();
require_once("config.php");

if($_SESSION['AUTHENTICATED'] == false) { 
    header('Location: 404.html');
}

?>