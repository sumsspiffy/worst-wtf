<?php 
require_once("../config.php");

$ipaddr = $_SERVER['REMOTE_ADDR'];
$username = trim($_POST['username']);
$password = md5(trim($_POST['password']));
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

$res = $link->query("SELECT * FROM usertable WHERE username = '$username' AND password = '$password'");
$rows = $res->num_rows;

if ($rows == 0) { 
    $Error = "Invalid credentials"; 
    $Valid = false;
}

if ($Valid == true) {
    // set the userskey as the key set from registration
    $_SESSION['userkey'] = $res->fetch_assoc()['userkey'];
    $_SESSION['active'] = true; 
    echo 1;
}
else { 
    echo $Error;
}

?>