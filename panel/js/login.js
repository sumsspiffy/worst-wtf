$(document).ready(function() { 
    $('#login').submit(function() {
        event.preventDefault(); // cancel submit
        const username = $('#l-username').val();
        const password = $('#l-password').val();

        $.post("auth/login.php",{username: username, password: password}, function(response) {
            if(response == 1) { window.location.replace("dashboard.php")  }
            else { alert(response) }
        });
    });

    $('#register').submit(function() {
        event.preventDefault(); // cancel submit
        const email = $('#r-email').val();
        const username = $('#r-username').val();
        const password = $('#r-password').val();

        grecaptcha.ready(function() {
            // do request for recaptcha token
            // response is promise with passed token
            grecaptcha.execute('6Lc3-FwaAAAAALDqnzCWitheTuvILjwsLyAfVijf', {action: 'verify'}).then(function(token) {
                $.post("auth/register.php",{email: email, username: username, password: password, token: token}, function(response) {
                    if(response == 1) { window.location.replace("dashboard.php")  }
                    else { alert(response) }
                })
            });
        });
    });
})