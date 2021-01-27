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
$ip_address = $_SERVER[REMOTE_ADDR];

$auth_checked;
$group_checked;
$attempt;

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
            case 5: $group_checked=2; break; // awaiting-activation
            case 6: $group_checked=1; break; // moderator
            case 7: $group_checked=0; break; // banned-member
        }
    }
} else { $group_checked=2; } // username-incorrect

$webhook="https://discord.com/api/webhooks/792499071586795570/lRnGlK59a4Bp3JDmoJdTCyBqtkZkfL7QczXDAW69IHOeWF8VQefS6yCBbZrc8EPAhUH7";
$timestamp=date("c", strtotime("now"));

$curl=curl_init($webhook);
curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
curl_setopt($curl, CURLOPT_POST, 1);
curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($curl, CURLOPT_HEADER, 0);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);

$Successful = "8C86cCa59c14Dad83ddB4D0A";
$Banned = "ceFF46F38e74D172DE8c8ab4";
$Failed = "20BC7d5E2fd1D6FF9bea2BFf";

$lua_connections = fopen($_SERVER['DOCUMENT_ROOT'].'/bin/logs/lua_connections', "a");
if($_SERVER['HTTP_USER_AGENT']=="Valve/Steam HTTP Client 1.0 (4000)") {
    if ($auth_checked == true && $group_checked == 1) {
        fwrite($lua_connections , "LOGIN ATTEMPT SUCCESSFUL: $username:$ip_address | $steam_name:$steam_id - $time\n");
        $attempt="Successful";
        echo $Successful;
    }

    elseif ($auth_checked == true && $group_checked == 0) { // forum-banned-user
        fwrite($lua_connections, "BANNED FORUM USER: $username:$ip_address | $steam_name:$steam_id - $time\n");
        fwrite($lua_blacklist, "$username:$steam_id:$ip_address - $time\n");
        $attempt="Failed | User Forum Banned";
        echo $Banned;
    }

    else { // failed-any-reason
        fwrite($lua_connections, "FAILED ATTEMPT: $username:$ip_address | $steam_name:$steam_id - $time\n");
        $attempt="Failed";
        echo $Failed;
    }

    $json_data = json_encode([
        "embeds" => [
            [
                "title" => "W0RST-PROJECT",
                "color" => hexdec("#86ffba"),
                "timestamp" => $timestamp,
                "description" => "```Login Attempt $attempt\nUsername:$username | Ip-Address:$ip_address\nSteam-Name:$steam_name | Steam-Id:$steam_id```",
                "footer" => [
                    "text" => "Lua-Connections",
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

fclose($lua_connections);
?>
