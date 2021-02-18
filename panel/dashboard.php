<?php 
require_once('config.php');

// redirect users
if ($active != true || $local['blacklist'] == 'true') { // if not active / blacklisted
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

?>

<html>
    <title>Worst</title>
    <link rel='stylesheet' href='./css/dashboard/style.css'>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <img style='user-select:none; position:absolute; left:0; right:0; top:0; bottom:0; margin-top:auto; margin-bottom:auto; margin-right:auto; margin-left:auto;' src='img/logo.png'>
    </body>
</html>