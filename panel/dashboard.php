<?php 

$active = $_SESSION['active'];

include_once('inc/navbar.php');
include_once('inc/sidebar.php');
echo("<img style='user-select:none; position:absolute; left:0; right:0; top:0; bottom:0; margin-top:auto; margin-bottom:auto; margin-right:auto; margin-left:auto;' src='img/logo.png'>");

if($active != true) { header('Location: http://www.pornhub.com/'); }

?>

<html>
    <title>Worst</title>
    <link rel='stylesheet' href='./css/dashboard.css'>
    <body></body>
</html>