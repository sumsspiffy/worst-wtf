<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='css/login/style.css'>
        <link rel='stylesheet' href='css/login/ripple.css'>
        <script src="https://www.google.com/recaptcha/api.js"></script>
        <script src="js/jquery.min.js"></script>
        <script src="js/ripple.js"></script>
        <script src="js/login.js"></script>
        <script src="js/effects.js"></script>
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta property="og:image" content="img/logo.png">
        <meta property="og:description" content="Worst-Project | Backdoor Panel/Script">
    </head>
    <body>
        <img class="img" src="img/logo.png">
        <button id="show" class="btn material-ripple">LOGIN/REGISTER</button>
        <div class="content">
            <div class="card"> 
                <div class="nav">
                    <button id="tab-login" class="btn tab" style="opacity:1;">LOGIN</button>
                    <button id="tab-register" class="btn tab">REGISTER</button>
                </div>
                <div class="tab-login" style="display:block;">
                    <form id="login">
                        <div class="center">
                            <input id="l-username" class="input" placeholder="username" autocomplete="on">
                            <input id="l-password" class="input" placeholder="password" autocomplete="on" style="-webkit-text-security: disc;">
                        </div>
                        <button type="submit" class="btn submit material-ripple">Login</button>
                    </form>
                </div>
                <div class="tab-register">
                    <form id="register">
                        <div class="center" style="margin-top:88;">
                            <input id="r-email" class="input" placeholder="email" autocomplete="on">
                            <input id="r-username" class="input" placeholder="username" autocomplete="on">
                            <input id="r-password" class="input" placeholder="password" autocomplete="on" style="-webkit-text-security: disc;">
                        </div>
                        <script src="https://www.google.com/recaptcha/api.js?render=6Lc3-FwaAAAAALDqnzCWitheTuvILjwsLyAfVijf"></script>
                        <button class="btn submit material-ripple">Register</button>
                    </form>
                </div>
            </div> 
        </div>
    </body>
</html>

