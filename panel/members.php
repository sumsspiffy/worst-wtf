<?php 
require_once('config.php');

$result = $link->query("SELECT * FROM usertable");
$rows = $result->num_rows;

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src='js/ripple.js'></script>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="middle-card">
            <?php
                echo("<span class='member-count'>Total Members: $rows</span>"); // total members
                foreach (range(1, $rows) as $id) { // loop though for each user
                    // takes the rows & checks for that user in the range of every user
                    $result = $link->query("SELECT * FROM usertable WHERE uid = '$id'")->fetch_assoc();
                    
                    // assign values
                    $uid = $result['uid'];
                    $avatar = $result['avatar'];
                    $username = $result['username'];

                    echo("<div class='member-select'>
                        <a href='profile?uid=$uid'><img class='rounded-circle member-pfp' src='$avatar' onerror=this.src='img/avatar.png'></a>
                        <span class='member-name'>$username</span>
                    </div>");
                }
            ?>
        </div>
    </body>
</html>
