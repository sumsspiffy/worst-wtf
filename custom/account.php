<?php 

require_once('core/config.php');

$LocalInfo = $Local::Info();
$username = $LocalInfo['username'];
$discord = $LocalInfo['discord'];
$token = $LocalInfo['token'];
$email = $LocalInfo['email'];
$role = $LocalInfo['role'];
$date = $LocalInfo['date'];
$uid = $LocalInfo['uid'];

?>

<html>
    <head>
        <title>Worst</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="js/jquery.min.js"></script>
        <script src="core/js/update.js"></script>
        <link rel='stylesheet' href='css/dashboard/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="js/ripple.js"></script>
    </head>
    <body>
        <?php include_once('inc/navbar.php'); ?>
        <div class="page-content">
            <div class="card">
                <h1 class="card-title">Account Information</h1>
                <form id="account">
                    <div class="form-row">
                        <label class="label">UID</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$uid'></input>") ?>
                    </div>
                    <div class="form-row">
                        <label class="label">Token</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$token'></input>") ?>
                    </div>
                    <div class="form-row">
                        <label class="label">Username</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$username'></input>") ?>
                    </div>
                    <div class="form-row">
                        <label class="label">Email</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$email'></input>") ?>
                    </div>
                    <div class="form-row">
                        <label class="label">Role</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$role'></input>") ?>
                    </div>
                    <div class="form-row">
                        <label class="label">Discord ID</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$discord'></input>") ?>
                    </div>
                    <div class="form-row">
                        <label class="label">Creation Date</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$date'></input>") ?>
                    </div>
                </form>
                <div class="button-container">
                    <button id="link" class="button material-ripple hover">Relink Discord</button>
                    <button id="edit" class="button material-ripple hover">Change Password</button>
                </div>
            </div>
        </div>
        <div class="hidden">
            <div class="edit-card">
                <h1 class="card-title">Update Information</h1>
                <form id="update" autocomplete="on">
                    <div class="form-row">
                        <label class="label">Current Password</label>
                        <input id="old-password" class="input" placeholder="password" type="password">
                        <label class="label">New Password</label>
                        <input id="new-password" class="input" placeholder="password" type="password">
                        <div class="button-container" style="padding-bottom:0;">
                            <button id="link" class="button material-ripple hover" style="width:85%;">Change Password</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
    <script>
        const edit = $('#edit');
        const link = $('#link');
        const hidden = $('.hidden');
        const card = $('.edit-card');

        link.click(function() { 
            location.href = "core/auth/discord.php?action=login";
        })

        edit.click(function() {
            hidden.fadeIn();
        })

        $(document).mouseup(function(e) { 
            if(!card.is(e.target) && card.has(e.target).length === 0 && hidden.css('display') != 'none') { hidden.fadeOut(450); }
        })
    </script>
</html>