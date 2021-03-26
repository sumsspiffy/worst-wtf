<html>
    <head>
        <title>Worst</title>
        <script src="js/custom.js"></script>
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <style>
            html { font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen,Ubuntu,Cantarell,Fira Sans,Droid Sans,Helvetica Neue,sans-serif; }
            body { background: url("panel/img/shrug.png") center bottom no-repeat; background-size: cover;  color:black;}
            a { font-weight:500; font-size:1.5rem; text-decoration:none; line-height:1.5; color:#444; width:auto; }
            h1 { font-weight:600; font-size:5rem; text-decoration:none; line-height:1.5; text-transform:uppercase; color:#444; }
            .content { padding-top: 7rem; display: block; width: 60%; top:0;left:0;right:0;bottom:0; float: none; margin: auto; text-align: center; }
            .center { font-size:40px; width:20%; margin:auto; }
            .hover { transition: 250ms ease; }
            .hover:hover { -webkit-transform: scale(1.5); }
        </style>
    </head>
    <body>
        <div class="content">
            <?php echo("<h1>".$_GET['reason']."</h1>"); ?>         
            <div class="center">
                <a onclick="link('https://w0rst.xyz/')"><h2 class="hover">Home</h2></a>
            </div>
        </div>
    </body>
</html>