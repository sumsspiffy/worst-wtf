<!-- <?php 
session_start();
require_once("config.php");

$userkey = $_SESSION['userkey'];
$active = $_SESSION['active'];

if($active != true) { header('Location: http://www.pornhub.com/'); }

if (isset($_POST['update_pass'])) {
    $oldpass = md5(trim($_POST['oldpass']));
    $newpass = md5(trim($_POST['newpass']));
    $Valid = true;

    // check if data's empty
    if (empty($oldpass) || empty($newpass)) { $Valid = false; }

    $result = $link->query("SELECT * FROM `usertable` WHERE username = '$username'");

    if ($result->num_rows > 0) { 
        while($row = $result->fetch_assoc()) {
            // check if old password is the same then continue
            if ($oldpass == $row['password']) { $Valid = true; }
        }
    }

    $sql = "UPDATE usertable SET password = '$newpass' WHERE userkey = '$userkey'";
    if($Valid) { $link->query($sql); }
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

    $sql = "UPDATE usertable SET email = '$emailaddr', username = '$username', avatar = '$avatar' WHERE userkey = '$userkey'";
    
    if($Valid) { 
        $link->query($sql);
    }

    // ADD A PASSWORD UPDATE REQUEST & ALSO ADD DISCORD LINK
}

// define important user variables

$discordid;
$emailaddr;
$username;
$password;
$avatar;

$result = $link->query("SELECT * FROM usertable WHERE userkey = '$userkey'");

if ($result->num_rows > 0) { 
    while($row = $result->fetch_assoc()) { 
        $emailaddr = $row['email'];
        $username = $row['username']; 
        $password = $row['password'];
        $avatar = $row['avatar'];
    }
}

$html = "
<div class='settings-card'>
    <div class='settings-frame'>
        <form method='post' id='update'>
            <input type='text' class='input' name='username' value='$username' autocomplete='off'>
            <input type='text' class='input' name='email' value='$emailaddr' autocomplete='off'>
            <input type='text' class='input' name='avatar' value='$avatar' autocomplete='off'>
        </form>
        <button class='btn link'>Link Discord</button>
        <button class='btn pass'>Update Password</button>
    </div>
    <button form='update' type='submit' name='update' class='btn save'>Save Settings</button>
</div>
<div class='fade-background'>
    <div class='password-card' style='width: 36rem; height: 14rem;'>
        <form method='post' id='update_pass'>
            <div class='settings-frame' style='height: 145px;'>
                <input type='text' class='input' name='oldpass' placeholder='old-password' autocomplete='off'>
                <input type='text' class='input' name='newpass' placeholder='new-password' autocomplete='off'>
            </div>
            <button type='submit' name='update_pass' class='btn save' style='width: 35rem;'>Update Password</button>
        </form>
    </div>
</div>";

?> -->

<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/dashboard.css'>
        <script src="js/jquery.min.js"></script>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); echo($html); ?>
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