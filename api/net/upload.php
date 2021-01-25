<?php
$ini = parse_ini_file('../config.ini');
$link = mysqli_connect($ini['db_host'], $ini['db_user'], $ini['db_password']);
$database = mysqli_select_db($link, $ini['db_name']);
$tables = $ini['mybb_usertable'];

$username = $_POST['username'];
$password = $_POST['password'];
$str = $_POST["net"];
$auth_checked;
$group_checked;

$sql = "SELECT * FROM ". $tables ." WHERE username = '". mysqli_real_escape_string($link, $username) ."'" ;
$results = $link->query($sql);

if ($results->num_rows > 0) {
    while($row = $results->fetch_assoc()) {
        $stored_pass = md5(md5($row['salt']).$password);
        $group = $row['usergroup'].$row['additionalgroups'];

        if($stored_pass == $row['password']) { // check password
            $auth_checked = true;
        } else { $auth_checked = false; }

        switch($group) {
            case 2: $group_checked=1; break; // registered
            case 3: $group_checked=1; break; // super-moderator
            case 4: $group_checked=1; break; // administrator
            case 6: $group_checked=1; break; // moderator
        }
    }
} else { $group_checked=2; } // username-incorrect

$net_path = fopen($_SERVER['DOCUMENT_ROOT'].'/bin/nets', "a");
if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") {
    if($auth_checked && $group_checked == 1) { fwrite($net_path, "$str "); }
    else { echo 0; }
}
else {
    echo fuckoff;
}

fclose($net_path);
?>
