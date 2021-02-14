<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='css/login.css'>
        <script src="js/jquery.min.js"></script>
        <script src="js/login.js"></script>
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta property="og:image" content="img/logo.png">
        <meta property="og:description" content="Worst-Project | Backdoor Panel/Script">
    </head>
    <body>
        <img class="img" src="img/logo.png">
        <button id="show" class="btn ripple">LOGIN/REGISTER</button>
        <div class="content">
            <div class="card"> 
                <div class="nav">
                    <button id="login" class="btn tab">LOGIN</button>
                    <button id="register" class="btn tab">REGISTER</button>
                </div>
                <div class="login-tab">
                    <form method="post">
                        <div class="frame">
                            <input type="text" id="username" class="input user" name="username" placeholder="username" autocomplete="on">
                            <input type="text" id="password" class="input pass" name="password" placeholder="password" autocomplete="off">
                        </div>
                        <button type="submit" name="login" class="btn login">Login</button>
                    </form>
                </div>
                <div class="register-tab">
                    <form method="post">
                        <div class="frame">
                            <input type="text" id="email" class="input email" name="email" placeholder="email" autocomplete="on">
                            <input type="text" id="username" class="input user" name="username" placeholder="username" autocomplete="on">
                            <input type="text" id="password" class="input pass" name="password" placeholder="password" autocomplete="off">
                        </div>
                        <div id="g-recaptcha" class="recaptcha" data-sitekey="6LcGMlYaAAAAAMS0U3qaBpNZM10D1C8mSXq_4yPq"></div>
                        <script>var onloadCallback = function() {grecaptcha.render("g-recaptcha", {'sitekey' :'6LcGMlYaAAAAAMS0U3qaBpNZM10D1C8mSXq_4yPq','theme':'dark'})};</script>
                        <script src="https://www.google.com/recaptcha/api.js?onload=onloadCallback&render=explicit"async defer></script>
                        <button type="submit" name="register" class="btn register">Sign Up</button>
                    </form>
                </div>
            </div> 
        </div>
    </body>
</html>

<?php
session_start();
require_once("config.php");

$ipaddr = $_SERVER['REMOTE_ADDR'];

if (isset($_POST['register'])) { 
    $username = trim($_POST['username']);
    $password = md5(trim($_POST['password']));
    $emailaddr = $_POST['email'];
    $Alert; // needed for alerts 
    $Valid = true;

    // ReCaptcha verification
    $response = $_POST["g-recaptcha-response"];
    $url = 'https://www.google.com/recaptcha/api/siteverify';
	$data = array('secret' => '6LcGMlYaAAAAAF1CRRQuUQ-5wHDdJzigH7nfjgWb', 'response' => $_POST["g-recaptcha-response"]);
	$options = array('http' => array ( 'method' => 'POST', 'content' => http_build_query($data)));

    $context  = stream_context_create($options);
	$verify = file_get_contents($url, false, $context);
	$captcha_success=json_decode($verify);

    if ($captcha_success->success==false) {
        $Alert = '<div class="notification">Failed ReCaptcha.</div>';
        $Valid = false;
    }

    // User's currently logged in 
    if ($_SESSION['active'] == true) { 
        $Alert = '<div class="notification">Failed logout.</div>';
        $Valid = false; 
    }

    // Data was empty
    if (empty($emailaddr) || empty($username) || empty($password)) { 
        $Alert = '<div class="notification">Empty values.</div>';
        $Valid = false; 
    }

    // Check if data is valid & not in database
    $sql = "SELECT * FROM `usertable` WHERE username = '$username'";
    $result = $link->query($sql);

    // Usernames taken
    if ($result->num_rows > 0) { 
        $Alert = '<div class="notification">Usernames taken.</div>';
        $Valid = false; 
    }

    // Email valid check
    if (filter_var($email, FILTER_VALIDATE_EMAIL)) { 
        $Alert = '<div class="notification">Invalid email.</div>';
        $Valid  = false; 
    } // only letters no white-spaces

    // create user private session key
    $num = mt_rand(100000, 999999);
    $userkey = md5($num);

    $sql = "INSERT INTO `usertable` (username, password, email, ipaddress, userkey) 
    VALUES ('$username', '$password', '$emailaddr', '$ipaddr', '$userkey')";

    // Sql query
    if ($Valid) { 
        $Alert = '<div class="notification">Registered successfully.</div>';
        // mail user that the registration worked.
        $subject = "Registration Completed.";
        $text = "$username, thank you for registering.\n\nUsername: $username\nEmail address: $emailaddr";
        $header = "From: Worst webmaster@w0rst.xyz";

        // now send defined values ^
        mail($emailaddr, $subject, $text, $header);

        // finaly query data
        $link->query($sql);
    }

    if($Alert != NULL) { echo $Alert; }
}

if (isset($_POST['login'])) { 
    $username = trim($_POST['username']);
    $password = md5(trim($_POST['password']));
    $Alert;

    $sql = "SELECT * FROM usertable WHERE username = '$username' AND password = '$password'";
    $link->query("UPDATE usertable SET  ipaddress = '$ipaddr"); // log ip on login ;0

    $result = $link->query($sql);

    if ($result->num_rows > 0) { 
        // grab users key and redirect them over to the dashboard
        while($row = $result->fetch_assoc()) { $_SESSION['userkey'] = $row['userkey']; }
        $_SESSION['active'] = true; // set the session as active

        // redirect users
        $Alert = '<div class="notification">Logged in redirecting.</div>';
        echo '<meta http-equiv="refresh" content="3;dashboard.php"/>';
    }
    else { $Alert = '<div class="notification">Invalid credentials.</div>'; }

    if($Alert != NULL) { echo $Alert; }
}

if (isset($_POST['logout'])) {
    $Alert = '<div class="notification">Logged out successfully.</div>';
    $_SESSION['active'] = false; // de-activate session!
    unset($_SESSION['userkey']);
    echo $Alert; // echo alert
}

?>