<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'project');

// important includes
include("class/database.php");
include("class/classes.php");

// create the database link
$database = new Database(DB_SERVER, DB_NAME, DB_USERNAME, DB_PASSWORD);
$database->BDD->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
global $database;

// define required classes
// classes for user info
$Account = new Account;
$Script = new Script;
$Secure = new Secure;
$Local = new Local;
$Log = new Log;

session_start(); // start session

?>