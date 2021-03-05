<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/panel/core/config.php");

$total = $GLOBALS['database']->Count("users");

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
                    echo("<h1 class='card-title'>Total Members: $total</h1><div class='flexbox'>");
                    for($x = 0; $x < $total; $x++) {
                        $AccountInfo = $GLOBALS['database']->GetContent('users', ['uid' => $x+1])[0];
                        $name = $AccountInfo['username'];
                        $avatar = $AccountInfo['avatar'];
                        $role = $AccountInfo['role'];
                        $uid = $AccountInfo['uid'];

                        echo("<div class='member-card'>
                            <div class='form-row'>
                                <a href='profile?uid=$uid'><img class='member-pfp circle' src='$avatar' onerror=this.src='img/avatar.png'></a>
                                <span class='member-text'>$name</span>
                                <span class='member-text'>$role</span>
                            </div>
                        </div>");
                    }
                    echo("</div><br>");
                ?>
            </div>
        </div>
    </body>
</html>
