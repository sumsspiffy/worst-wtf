<?php 
session_start();
require_once("config.php");

$userkey = $_SESSION['userkey'];
$active = $_SESSION['active'];

if($active != true) { header('Location: http://www.pornhub.com/'); }

$result = $link->query("SELECT * FROM usertable");
$rows = $result->num_rows;

// ADD BAN SYSTEM NEXT
// THIS IS A FUCKING MUST!!!
?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
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

                    // just so it doesn't give shitty avatars
                    if(empty($avatar)) { $avatar = "./img/avatar.png"; }
                    
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
