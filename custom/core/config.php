<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'armigkwd_project');
define('DB_PASSWORD', '{M.V.-g*^lZ{');
define('DB_NAME', 'armigkwd_project');

// important includes
include("class/database.php");
include("class/user.php");
include("class/log.php");

// create the database link
$database = new Database(DB_SERVER, DB_NAME, DB_USERNAME, DB_PASSWORD);
$database->BDD->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
global $database;

// define required classes
// classes for user info
$Account = new Account;
$Secure = new Secure;
$Local = new Local;

// classes for log info
$Server = new Server;
$Script = new Script;

session_start(); // start session

?>