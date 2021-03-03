<?php 

require_once('config.php');

$LocalInfo = $Local::Info();

$usergroup = $LocalInfo['usergroup'];
$username = $LocalInfo['username'];
$discord = $LocalInfo['discordid'];
$userkey = $LocalInfo['userkey'];
$email = $LocalInfo['mail'];
$date = $LocalInfo['date'];
$uid = $LocalInfo['uid'];

?>

<html>
    <head>
        <title>Worst</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
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
                        <label class="label">Key</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$userkey'></input>") ?>
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
                        <label class="label">Group</label>
                        <?php echo("<input disabled class='input disabled' placeholder='$usergroup'></input>") ?>
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
                    <button type="button" class="button material-ripple hover">Relink Discord</button>
                    <button type="button" class="button material-ripple hover">Edit Username/Password</button>
                </div>
            </div>
        </div>
    </body>
</html>