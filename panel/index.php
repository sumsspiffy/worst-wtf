<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='./css/style.css'>
        <script src="./js/jquery.min.js"></script>
        <script src="js/custom.js"></script>
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta property="og:image" content="https://w0rst.xyz/panel/img/logo.png">
        <meta property="og:description" content="Worst-Project | Backdoor Panel/Script">
    </head>
    <body>
        <div class="content">
            <img class="image" src="./img/logo.png">
            <button id="open" class="button ripple">LOGIN/REGISTER</button>
            <div class="container">
                <div class="card"> 
                    <div class="nav">
                        <button id="login" class="nav-button transparent ripple">Login</button>
                        <button id="register" class="nav-button transparent ripple">Register</button>
                    </div>
                    <div class="login-tab active">
                        <form method="post">
                            <input type="text" id="username" class="user-input" name="username" placeholder="username">
                            <input type="text" id="password" class="pass-input" name="password" placeholder="password">
                            <button type="submit" name="login" class="post-button ripple">Login</button>
                        </form>
                    </div>
                    <div class="register-tab">
                        <form method="post">
                            <input type="text" id="email" class="email-input" name="email" placeholder="email">
                            <input type="text" id="username" class="user-input" name="username" placeholder="username">
                            <input type="text" id="password" class="pass-input" name="password" placeholder="password">
                            <button type="submit" name="register" class="post-button ripple">Sign Up</button>
                        </form>
                    </div>
                </div> 
            </div>
        </div>
    </body>
</html>

<?php
$ipaddr = $_SERVER['REMOTE_ADDR'];
$username = $_POST['username'];
$password = $_POST['password'];
$emailaddr = $_POST['email'];

require_once("config.php");
session_start();

if ($link === FALSE) { 
    die("Connection Failed: " . mysqli_connect_error()); 
}

if (isset($_POST['register'])) { 
    $username = trim($username);
    $password = md5(trim($password));

    // Check submition to see if it's valid
    // if($username == null || $password == null || $emailaddr == null) { $Valid=false; }

    $sql = "INSERT INTO `usertable` (username, password, email, ip) 
    VALUES ('$username', '$password', '$emailaddr', '$ipaddr')";

    // query with sql^
    $link->query($sql);
}

if (isset($_POST['login'])) { 
    $username = trim($username);
    $password = md5(trim($password));

    $sql = "SELECT * FROM `usertable` WHERE username = '$username' AND password = '$password'";
    $result = $link->query($sql);

    if ($result->num_rows > 0) { 
        header('Location: dashboard.php');
    }
}

?>