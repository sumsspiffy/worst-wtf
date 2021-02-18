<?php 
require_once('config.php');

// redirect users
if ($active != true || $local['blacklist'] == 'true') { // if not active / blacklisted
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

$result = $link->query("SELECT * FROM usertable");
$rows = $result->num_rows;

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard/style.css'>
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
                        <img class='rounded-circle member-pfp' src='$avatar'>
                        <span class='member-name'>$username</span>
                        <form action='profile.php' method='get'><button type='submit' name='uid' value='$uid' class='btn profile'>Profile</button></form>
                    </div>");
                }
            ?>
        </div>
    </body>
</html>
