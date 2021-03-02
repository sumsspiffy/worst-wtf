<html>
    <head>
        <title></title>
        <style>
            body { background-image: url(./img/shrug.png); background-size: 100%; color: #444; margin:0;font: normal 14px/20px Arial, Helvetica, sans-serif; height:100%; }
            h1 { text-transform: uppercase; margin:0; font-size:40px; line-height:150px; font-weight:bold; }
            h2 { margin-top:20px;font-size: 30px; }
            div { height:auto; min-height:100%; text-align: center; width:800px; margin-left: -400px; position:absolute; top: 30%; left:50%;  }
        </style>
    </head>
    <body>
        <div>
            <?php 
                if($_GET['error']) {
                    $Error = $_GET['error'];
                    echo("<h1>$Error</h1>"); 
                }
            ?>
            <h2>Not found</h2>
            <p>The server could not find the page.</p>
            <p>Or the user does not have access to that page.</p>
        </div>
    </body>
</html>