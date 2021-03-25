<html>
    <head>
        <title>Worst</title>
        <link rel='stylesheet' href='css/login/style.css'>
        <link rel='stylesheet' href='css/ripple.css'>
        <script src="https://www.google.com/recaptcha/api.js"></script>
        <script src="js/jquery.min.js"></script>
        <script src="js/ripple.js"></script>
        <script src="js/snowstorm.js"></script>
        <meta name="theme-color" content="#86ffba">
        <meta property="og:title" content="w0rst.xyz">
        <meta property="og:image" content="img/logo.png">
        <meta property="og:description" content="Worst-Project | Backdoor Panel/Script">
    </head>
    <body>
        <script src="https://www.google.com/recaptcha/api.js?render=6Lc3-FwaAAAAALDqnzCWitheTuvILjwsLyAfVijf"></script>
        <div class="top-content">
            <img class="logo" src="img/logo.png">
            <button id="popup" class="button rounded hover material-ripple">LOGIN/REGISTER</button>
        </div>
        <div class="bottom-content">
            <div class="container">
                <h1 class="header">What is this?</h1>
                <p class="text">Worst is a web based panel/script. This project started officially January 17th 2021, we have been actively updating the site & script since the very beginning learning everything along the way. Our staff teams very minimal currently and we may start recruiting staff soon, so pay attention to that ;0</p>
                <h1 class="header">Project Rules!</h1>
                <p class="text">Crack attempts will result in a blacklist, working against worst in any way for ex. snitching, scamming, anti-cheats, threat's of any kind, harassment. Remember worst is a free public script don't abuse/break these very basic rules, admins also reserve the right to blacklist at anytime for any reason without informing the user.</p>
                <h1 class="header">Data Collection.</h1>
                <p class="text">Worst like many other sites stores information about users. We collect very basic info includding ips, connections, and servers backdoored. We don't leak users private info such as ips and emails, unlike many sites we really could care less about users data.</p>
            </div>
        </div>
        <div class="hidden">
            <div class="card"> 
                <div class="button-container">
                    <button id="tab-login" class="button transparent" style="opacity:1;">LOGIN</button>
                    <button id="tab-register" class="button transparent">REGISTER</button>
                </div>
                <form id="login" autocomplete="on">
                    <div class="form-row">
                        <label class="label">Username</label>
                        <input id="l-username" class="input" placeholder="username" type="username">
                        <label class="label">Password</label>
                        <input id="l-password" class="input" placeholder="password" type="password" style="-webkit-text-security: disc;">
                    </div>
                    <div class="button-container" style="padding-bottom:0;">
                        <button id="l-submit" class="button material-ripple hover">Login</button>
                    </div>
                </form>
                <form id="register" autocomplete="on" style="display:none;">
                    <div class="form-row">
                        <label class="label">Email</label>
                        <input id="r-email" class="input" placeholder="email">
                        <label class="label">Username</label>
                        <input id="r-username" class="input" placeholder="username" type="username"> 
                        <label class="label">Password</label>
                        <input id="r-password" class="input" placeholder="password" type="password" style="-webkit-text-security: disc;">
                    </div>
                    <div class="button-container" style="padding-bottom:0;">
                        <button class="button material-ripple hover">Register</button>
                    </div>
                </form>
            </div> 
        </div>
    </body>
    <script>
        const login = $('#login');
        const register = $('#register');
        const login_tab = $('#tab-login');
        const register_tab = $('#tab-register');
        const popup = $('#popup');
        const hidden = $('.hidden');
        const card = $('.card');

        popup.click(function() { hidden.fadeIn(450); $('body').css("overflow-y", "hidden"); });

        login_tab.click(function() {
            register_tab.fadeTo(50, 0.55);
            login_tab.fadeTo(50, 1);
            register.fadeOut(0); login.fadeIn(0);
        })

        register_tab.click(function() {
            login_tab.fadeTo(50, 0.55);
            register_tab.fadeTo(50, 1);
            register.fadeIn(0); login.fadeOut(0);
        })

        $(document).mouseup(function(e) { 
            if(!card.is(e.target) && card.has(e.target).length === 0 && hidden.css('display') != 'none') { hidden.fadeOut(450); $('body').css("overflow-y", "auto"); }
        })

        $('#login').submit(function() {
            event.preventDefault(); // cancel submit
            const username = $('#l-username').val();
            const password = $('#l-password').val();

            // this is only ran on click
            // so not like uper fucky        
            grecaptcha.ready(function() {
                // do request for recaptcha token
                // response is promise with passed token
                grecaptcha.execute('6Lc3-FwaAAAAALDqnzCWitheTuvILjwsLyAfVijf', {action: 'verify'}).then(function(token) {
                    $.post("req/simple.php?request=login",{username: username, password: password, captcha: token}, function(response) {
                        if(!response) { if(!alert("Login successful.")) { setTimeout( function() { location.href = `dashboard`; }, 150); } }
                        else { alert(response) }
                    });
                });
            });
        });

        $('#register').submit(function() {
            event.preventDefault(); // cancel submit
            const email = $('#r-email').val();
            const username = $('#r-username').val();
            const password = $('#r-password').val();

            // this is only ran on click
            // so not like uper fucky
            grecaptcha.ready(function() {
                // do request for recaptcha token
                // response is promise with passed token
                grecaptcha.execute('6Lc3-FwaAAAAALDqnzCWitheTuvILjwsLyAfVijf', {action: 'verify'}).then(function(token) {
                    $.post("req/simple.php?request=register",{email: email, username: username, password: password, captcha: token}, function(response) {
                        if(!response) { alert("Registration successful, check email for verification.") }
                        else { alert(response) }
                    });
                });
            });
        });
    </script>
</html>

