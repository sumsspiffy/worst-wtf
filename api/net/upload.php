<?php
$ini = parse_ini_file('../config.ini');
$link = mysqli_connect($ini['db_host'], $ini['db_user'], $ini['db_password']);
$database = mysqli_select_db($link, $ini['db_name']);
$tables = $ini['mybb_usertable'];

$str = $_POST["net"];
$username = $_POST['username'];
$group_checked;

$sql = "SELECT * FROM ". $tables ." WHERE username = '". mysqli_real_escape_string($link, $username) ."'" ;
$results = $link->query($sql);

if ($results->num_rows > 0) {
    while($row = $results->fetch_assoc()) {
        $group = $row['usergroup'].$row['additionalgroups'];

        switch($group) {
            case 2: $group_checked=0; break; // registered
            case 3: $group_checked=1; break; // super-moderator
            case 4: $group_checked=1; break; // administrator
            case 6: $group_checked=1; break; // moderator
        }
    }
}

$net_path = fopen($_SERVER['DOCUMENT_ROOT'].'/bin/nets', "a");
if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") {
    if($group_checked == 1) { fwrite($net_path, "$str "); }
    elseif($group_checked == 0) { echo 0; }
}
else {
    echo fuckoff;
}

fclose($net_path);
?>
