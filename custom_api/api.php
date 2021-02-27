<?php 
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'armigkwd_project');
define('DB_PASSWORD', '{M.V.-g*^lZ{');
define('DB_NAME', 'armigkwd_project');

// database link
$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// this will be for sharing information from the database
// what we will do with this is create a lua table with
// these values and echo that html for the ingame script

$res = $link->query("SELECT * FROM usertable WHERE uid = 1")->fetch_assoc();

$usergroup = $res['usergroup'];
$username = $res['username'];
$userkey = $res['userkey'];
$avatar = $res['avatar'];

$lua = "userkey=$userkey\nusergroup=$usergroup\navatar=$avatar\n";

echo $lua;

?>