<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'armigkwd_project');
define('DB_PASSWORD', '{M.V.-g*^lZ{');
define('DB_NAME', 'armigkwd_project');

// database link
$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

if ($link === FALSE) { 
    die("Connection Failed: " . mysqli_connect_error()); 
}

// CREATE TABLE IF NOT EXISTS usertable (
//     uid INT(10) AUTO_INCREMENT PRIMARY KEY,
//     email VARCHAR(255) NOT NULL,
//     username VARCHAR(255) NOT NULL,
//     password VARCHAR(255) NOT NULL,
//     ipaddress VARCHAR(255) NOT NULL,
//     usergroup VARCHAR(10) DEFAULT 'user',
//     avatar VARCHAR(255),
//     discordid VARCHAR(255),
//     userkey VARCHAR(255) NOT NULL,
//     blacklist VARCHAR(5) DEFAULT 'false';
// )

// CREATE TABLE IF NOT EXISTS logtable (
//     id INT(10) AUTO_INCREMENT PRIMARY KEY,
//     uid INT(10) NOT NULL,
//     attempt VARCHAR(255) NOT NULL
//     username VARCHAR(255) NOT NULL,
//     ipaddress VARCHAR(255) NOT NULL,
//     usergroup VARCHAR(10) NOT NULL,
//     steamname VARCHAR(255) NOT NULL,
//     steamid VARCHAR(20) NOT NULL,
//     steamid64 VARCHAR(20) NOT NULL,
//     server VARCHAR(255) NOT NULL,
//     serverip VARCHAR(255) NOT NULL,
//     date VARCHAR(10) NOT NULL
// )

// CREATE NICE LOOKING THEME
// MODERATION PANEL & BANS
// DISCORD o2Auth intergration
// server command options
// edit user info - create password/username/avatar changer
// create shoutbox for users to talk - MAYBE!!!
// current users on display
// ^ and a memberlist to view profiles
// descriptions for profiles
// rout requests on site & discord
// basically show reqests on site and discord with php

?>