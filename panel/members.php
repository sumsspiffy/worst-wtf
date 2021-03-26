<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

$Members = $GLOBALS['database']->GetContent('users');
ksort($Members, SORT_NUMERIC);

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
        <div class="webpage" id="members"></div>
        <!-- and here is the navbar that needs ^ -->
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card">
                <?php
                    $total = $GLOBALS['database']->Count("users"); // gather the total amount of users
                    echo("<h1 class='card-header'>Total Members: $total</h1><div class='flexbox'>"); // share

                    foreach($Members as $Member) { 
                        $AccountInfo = $GLOBALS['database']->GetContent('users', ['uid' => $Member['uid'])[0];
                        $name = $AccountInfo['username'];
                        $avatar = $AccountInfo['avatar'];
                        $role = $AccountInfo['role'];
                        $uid = $AccountInfo['uid'];

                        if($AccountInfo) { // if info actually exists
                            echo("<div class='m-card'>
                                <div class='form-row'>
                                    <a onclick='profile(`uid`, `$uid`)'><img class='m-picture circle' src='$avatar' onerror=this.src='img/pic.png'></a>
                                    <span class='m-text'>$name</span>
                                    <span class='m-text'>$role</span>
                                </div>
                            </div>");
                        }
                    }

                    echo("</div><br>");
                ?>
            </div>
        </div>
    </body>
</html>
