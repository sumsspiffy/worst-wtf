<?php 
require_once("../config.php");

$ipaddr = $_SERVER['REMOTE_ADDR'];
$username = trim($_POST['username']);
$password = md5(trim($_POST['password']));
$emailaddr = $_POST['email'];
$Valid = true;
$Error;

// Build POST request:
$recaptcha_url = 'https://www.google.com/recaptcha/api/siteverify';
$recaptcha_secret = '6Lc3-FwaAAAAAGTJV3fJ_mzE5kU_1H8mj7sVqh6a';
$recaptcha_response = $_POST['token'];

// Make and decode POST request:
$recaptcha = file_get_contents($recaptcha_url . '?secret=' . $recaptcha_secret . '&response=' . $recaptcha_response);
$recaptcha = json_decode($recaptcha);

// if the success return was 0 it failed or score is lower than 5
if ($recaptcha->success == 0 || $recaptcha->score < 0.5) {
    $Error = "Failed ReCaptcha.";
    $Valid = false;
} 

// User's currently logged in 
if ($_SESSION['active'] == true) { 
    $Error = "Failed logout.";
    $Valid = false; 
}

if (empty($emailaddr) || empty($username) || empty($password)) { 
    $Error = "Empty values.";
    $Valid = false; 
}

$rows = $link->query("SELECT * FROM usertable WHERE username = '$username'")->num_rows;

// username exists
if($rows > 0) { 
    $Error = "Usernames taken.";
    $Valid = false; 
}

// emails invalid
if (filter_var($email, FILTER_VALIDATE_EMAIL)) { 
    $Error = "Emails invalid.";
    $Valid = false; 
}

// generate random key & encrypt
$userkey = md5(mt_rand(100000, 999999));

if ($Valid == true) {
    echo 1; // the response for login
    $subject = "Registration Completed.";
    $text = "$username, thank you for registering.\n\nUsername: $username\nEmail address: $emailaddr";
    $header = "From: Worst webmaster@w0rst.xyz";

    // mail user
    mail($emailaddr, $subject, $text, $header);

    $link->query("INSERT INTO usertable (username, password, email, ipaddress, userkey) VALUES ('$username', '".mysqli_real_escape_string ($link , $password)."', '$emailaddr', '$ipaddr', '$userkey')");

    $_SESSION['userkey'] = $userkey;
    $_SESSION['active'] = true;
}

else { echo $Error; }

?>