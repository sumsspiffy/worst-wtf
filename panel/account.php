<?php 

require_once($_SERVER['DOCUMENT_ROOT']."/core/config.php");

// our local info table
$LocalInfo = $Local::Info();

// we have it in a array like this because
// it helps with lowering how many times
// we have to echo a row instead each indiv
// we would do them all together!

$vals = array( // our actual table for values
    "UID" => $LocalInfo['uid'],
    "Role" => $LocalInfo['role'],
    "Username" => $LocalInfo['username'],
    "Token" => $LocalInfo['token'],
    "Email" => $LocalInfo['email'],
    "Discord" => $LocalInfo['discord'],
    "IP Address" => $LocalInfo['ip'],
    "Creation Date" => $LocalInfo['date']
);

?>

<html>
    <head>
        <title>Worst</title>
        <meta charset="utf-8">
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="js/jquery.min.js"></script>
        <link rel='stylesheet' href='css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="js/ripple.js"></script>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card">
                <h1 class="card-header">Account Information</h1>
                <?php
                foreach($vals as $key => $val) {
                    echo("<div class='form-row'>
                        <label class='label'>$key</label>
                        <input disabled class='input disabled' placeholder='$val'></input>
                    </div>"); 
                }
                ?>
                <div class="button-container">
                    <button onclick="link('req/discord.php?action=login')" class="button material-ripple hover">Relink Discord</button>
                    <button onclick="edit()" class="button material-ripple hover">Change Password</button>
                </div>
            </div>
        </div>
        <div class="hidden2">
            <div class="c-card">
                <h1 class="card-header">Update Information</h1>
                <form id="update" autocomplete="on">
                    <div class="form-row">
                        <label class="label">Current Password</label>
                        <input id="old-password" class="input" type="password">
                        <label class="label">New Password</label>
                        <input id="new-password" class="input" type="password">
                        <div class="button-container" style="padding-bottom:0;">
                            <button class="button material-ripple hover" style="width:85%;">Change Password</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
    <script>
        function edit() { $('.hidden2').fadeIn(); }
        $(document).mouseup(function(e) { if(!$('.c-card').is(e.target) && $('.c-card').has(e.target).length === 0 && $('.hidden2').css('display') != 'none') { $('.hidden2').fadeOut(450); }})

        $('#update').submit(function() {
            event.preventDefault(); // cancel submit
            const oldpass = $('#old-password').val();
            const newpass = $('#new-password').val();

            $.post("req/simple.php?request=update",{oldpass: oldpass, newpass: newpass}, function(response) {
                if(!response) { alert("Changed password."); }
                else { alert(response); }
            });
        });
    </script>
</html>