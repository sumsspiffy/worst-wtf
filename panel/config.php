<?php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'armigkwd_project');
define('DB_PASSWORD', '{M.V.-g*^lZ{');
define('DB_NAME', 'armigkwd_project');

// database link
$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// CREATE TABLE IF NOT EXISTS usertable (
//     uid INT(10) AUTO_INCREMENT PRIMARY KEY,
//     email VARCHAR(255) NOT NULL,
//     username VARCHAR(255) NOT NULL,
//     password VARCHAR(255) NOT NULL,
//     ipaddress VARCHAR(255) NOT NULL,
//     usergroup INT(10) NOT NULL,
//     discordid VARCHAR(255),
//     avatar VARCHAR(255),
//     description VARCHAR(255),
//     userkey VARCHAR(255) NOT NULL
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

?>