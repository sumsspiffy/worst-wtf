<?php $error = $_GET['error']; ?>

<html>
    <head>
        <style>
            html { font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen,Ubuntu,Cantarell,Fira Sans,Droid Sans,Helvetica Neue,sans-serif; }
            body { background: url("img/shrug.png") center bottom no-repeat; background-size: cover;  color:black;}
            a { font-weight:500; font-size:1.5rem; text-decoration:none; line-height:1.5; color:black; }
            h1 { font-weight:600; font-size:5rem; text-decoration:none; line-height:1.5; text-transform:uppercase; }
            .content { padding-top: 5rem; display: block; width: 80%; top:0;left:0;right:0;bottom:0; float: none; margin: auto; text-align: center; }
            .center { font-size:40px; color:black; }
        </style>
    </head>
    <body>
        <div class="content">
            <div class="center">
                <?php if($error) { echo("<h1>$error</h1>"); } ?>  
                <a id="hover" href="https://w0rst.xyz/panel/">Home</a>
            </div>
        </div>
    </body>
</html>