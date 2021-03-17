<html>
    <head>
        <title>Worst</title>
        <link rel="stylesheet" media="screen" href="home/css/style.css">
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
    </head>
    <body>
        <?php
            $files = glob('project/sounds/*');
            $file = array_rand($files);
            
            $song = file_get_contents($files[$file]);
            
            echo("<embed id='music' src='$song' loop='true' hidden='true' autostart='true'>");
        ?>
        <div id="center">
            <img class="image" src="favicon.ico">
	        <div class="holder">
	            <a href="/panel"><h1 class="text">Panel</h1></a>
	            <a href="https://discord.gg/6Sy3AktdvC"><h1 class="text">Discord</h1></a>
    	        <a href="https://www.paypal.com/donate/?business=KAMC9YZ5CAHJA&currency_code=USD"><h1 class="text">Donate</h1></a>
    	        <a href="/file"><h1 class="text">Host</h1></a>
            </div>
        </div>
        <div id="particles-js"></div>
        <script src="home/js/particles.js"></script>
        <script src="home/js/app.js"></script>
    </body>
</html>