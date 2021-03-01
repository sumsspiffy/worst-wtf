<?php 
require_once("../config.php");

if (isset($_GET['pass'])) {
    $oldpass = md5(trim($_POST['oldpass']));
    $newpass = md5(trim($_POST['newpass']));
    $Valid = true;
    $Error;

    // check if data's empty
    if (empty($oldpass) || empty($newpass)) { 
        $Error = "Empty values.";
        $Valid = false; 
    }

    if ($oldpass != $local['password']) { 
        $Error = "Incorrect password.";
        $Valid = false;
    }

    if ($Valid == true) { 
        $link->query("UPDATE usertable SET password = '$newpass' WHERE userkey = '$userkey'"); 
        echo 1;
    }
    else { echo $Error; }
}

if (isset($_GET['info'])) { 
    $username = trim($_POST['username']);
    $avatar = $_POST['avatar'];
    $emailaddr = $_POST['email'];
    $Valid = true;
    $Error;

    // Data was empty
    if (empty($emailaddr) || empty($username) || empty($avatar)) { 
        $Error = "Empty values.";
        $Valid = false; 
    }

    // Check if data is valid & not in database
    $result = $link->query("SELECT * FROM usertable WHERE username = '$username'");

    if ($result->num_rows > 0) { 
        // if users key isn't the same then it's another user
        while($row = $result->fetch_assoc()) {
            if ($userkey != $row['userkey']){ 
                $Error = "Usernames taken.";
                $Valid = false; 
            }
        }
    }

    if($Valid == true) { 
        $link->query("UPDATE usertable SET email = '$emailaddr', username = '$username', avatar = '$avatar' WHERE userkey = '$userkey'");
        echo 1;
    }
    else { echo $Error; }
}

if(isset($_GET['user'])) { 
    // gotta assign a new variable name ;()    
    $blacklist = $_POST['blacklist'];
    $usergroup = $_POST['usergroup'];
    $uid = $_POST['uid'];
    $Valid = true;
    $Error;
    
    $sql = "UPDATE usertable SET usergroup = '$usergroup', blacklist = '$blacklist' WHERE uid = '$uid'";
    if (empty($blacklist) || empty($usergroup)) { 
        $Error = "Empty values.";
        $Valid = false; 
    }

    if (in_array($local['usergroup'], $staff)) { 
        $Error = "Incorrect usergroup.";
        $Valid = false;
    }

    if($Valid) { 
        $link->query($sql);
        echo 1;
    }
    else { echo $Error; }
}

?>