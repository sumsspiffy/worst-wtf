<?php 

require_once('core/config.php');

if(!$Local::IsAdmin()) {
    $Local::Redirect("Incorrect role");
}


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
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card">
                <?php
                    
                ?>
            </div>
        </div>
    </body>
</html>
