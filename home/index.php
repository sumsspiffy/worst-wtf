<html>
    <head>
        <title>Worst</title>
        <link rel="stylesheet" media="screen" href="home/css/style.css">
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta property="og:description" content="web panel/script">
    </head>
    <body>
        <?php
            $files = glob('project/sounds/*');
            $file = array_rand($files);
            
            $song = "https://w0rst.xyz/$files[$file]";
            
            echo("<embed src='$song' volume='25' hidden='true' autostart='true' loop='true'>");
        ?>
        <div id="center">
            <img class="image" src="favicon.ico">
	        <div class="holder">
	            <a onclick="link('https://w0rst.xyz/panel')"><h1 class="text">Panel</h1></a>
	            <a onclick="link('https://discord.gg/6Sy3AktdvC')"><h1 class="text">Discord</h1></a>
    	        <a onclick="link('https://www.paypal.com/donate/?business=KAMC9YZ5CAHJA&currency_code=USD')"><h1 class="text">Donate</h1></a>
    	        <a onclick="link('https://w0rst.xyz/host')"><h1 class="text">Host</h1></a>
            </div>
        </div>
        <div id="particles-js"></div>
        <script src="home/js/particles.js"></script>
        <script src="home/js/app.js"></script>
    </body>
</html>
<script>
// dumbed down link system for the home page
// unlike the panel account redirects arent needed
function link(url) { setTimeout( function() { location.href = url; }, 150); }
</script>