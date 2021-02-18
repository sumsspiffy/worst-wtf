<?php 
require_once('config.php');

// update settings like I did with the login
// fix the centering issues and also submit 
// within the same page not using forms

// this should be the focus drawn
// thing that you work on for a little

// redirect users
if ($active != true || $local['blacklist'] == 'true') { // if not active / blacklisted
    header('Location: https://w0rst.xyz/panel/error.php'); 
}

if (isset($_POST['update_pass'])) {
    $oldpass = md5(trim($_POST['oldpass']));
    $newpass = md5(trim($_POST['newpass']));
    $Valid = true;
    $Error;

    // check if data's empty
    if (empty($oldpass) || empty($newpass)) { 
        $Error = "Empty values.";
        $Valid = false; 
    }

    $result = $link->query("SELECT * FROM usertable WHERE userkey = '$userkey'")->fetch_assoc();

    if ($oldpass == $row['password']) { $Valid = true; }
    else {
        $Error = "Incorrect password.";
        $Valid = false;
    }

    if ($Valid == true) { $link->query("UPDATE usertable SET password = '$newpass' WHERE userkey = '$userkey'"); }
    else { echo "<script>alert('$Error')</script>"; }
}

if (isset($_POST['update'])) { 
    $username = trim($_POST['username']);
    $avatar = $_POST['avatar'];
    $emailaddr = $_POST['email'];
    $Valid = true;

    // Data was empty
    if (empty($emailaddr) || empty($username) || empty($avatar)) { 
        $Valid = false; 
    }

    // Check if data is valid & not in database
    $result = $link->query("SELECT * FROM `usertable` WHERE username = '$username'");

    if ($result->num_rows > 0) { 
        // if users key isn't the same then it's another user
        while($row = $result->fetch_assoc()) {
            if ($userkey != $row['userkey']){ $Valid = false; }
        }
    }

    if($Valid == true) { 
        $link->query("UPDATE usertable SET email = '$emailaddr', username = '$username', avatar = '$avatar' WHERE userkey = '$userkey'");
    }
}

$username = $local['username'];
$email = $local['email'];
$avatar = $local['avatar'];

?>

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="js/jquery.min.js"></script>
        <script src="js/settings.js"></script>
        <script src='./js/ripple.js'></script>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class='settings-card'>
            <div class='settings-frame'>
                <form method='post' id='update'>
                    <?php 
                        echo("<input type='text' class='input' id='username' value='$username' autocomplete='off'>
                        <input type='text' class='input' id='email' value='$email' autocomplete='off'>
                        <!-- for some reason this refuses to work if its an id for whatever reason -->
                        <input type='text' class='input avatar' value='$avatar' autocomplete='off'>");
                    ?>
                </form>
                <button class='btn link material-ripple'>Link Discord</button>
                <button class='btn pass material-ripple'>Update Password</button>
            </div>
            <button form='update' type='submit' class='btn save material-ripple'>Save Settings</button>
        </div>
        <div class='fade-background'>
            <div class='password-card' style='width: 36rem; height: 14rem;'>
                <form method='post' id='updatepass'>
                    <div class='settings-frame' style='height: 145px;'>
                        <input type='text' class='input' id='oldpass' placeholder='old-password' autocomplete='off' style='-webkit-text-security: disc !important;'>
                        <input type='text' class='input' id='newpass' placeholder='new-password' autocomplete='off' style='-webkit-text-security: disc !important;'>
                    </div>
                    <button type='submit' class='btn save material-ripple' style='width: 35rem;'>Update Password</button>
                </form>
            </div>
        </div>
        <script>
            var pass = $('.pass'); var link = $('.link'); var background = $('.fade-background'); var card = $('.password-card');
            pass.click(function() { background.fadeIn(350); });
            link.click(function() { location.href = "discord.php?action=login"; });
            $(document).mouseup(function(e) { 
                if(!card.is(e.target) && card.has(e.target).length === 0 && background.css('display') != 'none') { background.fadeOut(350); }
            })
        </script>
    </body>
</html>