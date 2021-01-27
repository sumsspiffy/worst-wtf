<?php
$ini = parse_ini_file('config.ini');
$link = mysqli_connect($ini['db_host'], $ini['db_user'], $ini['db_password']);
$database = mysqli_select_db($link, $ini['db_name']);
$tables = $ini['mybb_usertable'];

$time = date('H:i:sa');
$username = $_POST['username'];
$password = $_POST['password'];
$steam_id = $_POST['steam_id'];
$steam_name = $_POST['steam_name'];
$server_name = $_POST['server_name'];
$server_ip = $_POST['server_ip'];
$ip_address = $_SERVER[REMOTE_ADDR];

$group_checked;
$auth_checked;
$check;

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
            case 7: $group_checked=0; break; // banned member
        }
    }
} else { $group_checked=2; } // username-incorrect

$webhook="https://discord.com/api/webhooks/792498983997276191/PQ4t15hYAeRJbqSkpOYLgyfjXnvP_6d-CYIBjcrsFxuCSfjESXXrYAAzuYnM-fQs0QNi";
$timestamp=date("c", strtotime("now"));

$curl=curl_init($webhook);
curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($curl, CURLOPT_HEADER, 0);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

$Failed = "a4dF91aE25c2BFD11F879e42";

$lua_relay = fopen($_SERVER['DOCUMENT_ROOT'].'/bin/logs/lua_relay', "a");
if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") {
    if ($auth_checked && $group_checked == 1) {
        fwrite($lua_relay, "RELAY: $username:$ip_address - $steam_name:$steam_id - $server_name:$server_name - $time\n");
        $check = "User's Authed";
    }

    elseif($auth_checked && $group_checked == 0) {
        fwrite($lua_relay, "BANNED USER: $username:$steam_id:$ip_address - $server_name:$server_ip - $time\n");
        $check = "User's Banned";
        echo $Failed;
    }

    else {
        fwrite($lua_relay, "UKNOWN USER: $username:$steam_id:$ip_address - $server_name:$server_ip - $time\n");
        $check = "User's Invalid";
        echo $Failed;
    }

    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "W0RST-PROJECT",
                "color" => hexdec("#86ffba"),
                "timestamp" => $timestamp,
                "description" => "```Check Detected $check\nUsername:$username | Ip-Address:$ip_address\nSteam-Name:$steam_name | Steam-Id:$steam_id\nServer-Name:$server_name | Server-Ip:$server_ip```",
                "footer" => [
                    "text" => "Lua-Relay",
                ]
            ]
        ]
    ]);

    curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
    curl_exec($curl);
}
else {
    echo fuckoff;
}

$fclose($lua_relay);
?>
