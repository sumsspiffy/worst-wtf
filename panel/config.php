<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'armigkwd_project');
define('DB_PASSWORD', '{M.V.-g*^lZ{');
define('DB_NAME', 'armigkwd_project');

// database link using these ^ definitions
$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// check if links actually active
if ($link === FALSE) { die("Connection Failed: " . mysqli_connect_error()); }

// define active user and user variables

session_start(); // start the current session for access to values

// assign session variables with our own for access...

$userkey = $_SESSION['userkey']; // users special key
$active = $_SESSION['active']; // session activity

// this gets the local user with there key assinged from registration using sessions
$local = $link->query("SELECT * FROM usertable WHERE userkey = '$userkey'")->fetch_assoc();

// this method is actually smart af
// create the link and assign it as local
// the local basically gets erased after 
// and assinged all of its own values 

$local = array(
    'uid' => $local['uid'],
    'email' => $local['email'],
    'username' => $local['username'],
    'password' => $local['password'],
    'usergroup' => $local['usergroup'],
    'blacklist' => $local['blacklist'],
    'ipaddress' => $local['ipaddress'],
    'discordid' => $local['discordid'],
    'avatar' => $local['avatar']
);

// incase of database corruption keep the creation methods to recreate the databases
// CREATE TABLE IF NOT EXISTS usertable (uid INT(10) AUTO_INCREMENT PRIMARY KEY, email VARCHAR(30) NOT NULL, username VARCHAR(30) NOT NULL, password VARCHAR(255) NOT NULL, ipaddress VARCHAR(20) NOT NULL, usergroup VARCHAR(10) DEFAULT 'user', avatar VARCHAR(255), discordid VARCHAR(30), userkey VARCHAR(60) NOT NULL, blacklist VARCHAR(5) DEFAULT 'false')
// CREATE TABLE IF NOT EXISTS logtable (id INT(10) AUTO_INCREMENT PRIMARY KEY, uid INT(10) NOT NULL, attempt VARCHAR(40) NOT NULL, username VARCHAR(30) NOT NULL, ipaddress VARCHAR(20) NOT NULL, usergroup VARCHAR(10) NOT NULL, steamname VARCHAR(20) NOT NULL, steamid VARCHAR(20) NOT NULL, steamid64 VARCHAR(20) NOT NULL, server VARCHAR(255) NOT NULL, serverip VARCHAR(255) NOT NULL, date VARCHAR(10) NOT NULL)

// rework login system so you can save passwords with google
// this can be done by using sperate files for logging in users
// more ease of access in other files using the config file
// cleanup code and simplify for ease of access.
// create new features on the panel and hopefully monkey brains (tomc) decides to put in some time & make our menu menustate
// AGAIN CLEANUP CODE make code more synchronous & cleanup some database shit
// link all database searches inside the config file only running when required...

?>