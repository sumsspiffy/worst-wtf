<?php

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

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
    </head>
    <body>
        <!-- this is for knowing what page is open -->
        <div class="webpage" id="home"></div>
        <!-- and here is the navbar that needs ^ -->
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <img class='background-image' src='img/logo.png'>
        </div>
    </body>
</html>