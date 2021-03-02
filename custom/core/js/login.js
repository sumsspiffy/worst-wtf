$(document).ready(function() { 
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
                $.post("core/auth/simple.php?request=login",{username: username, password: password, token: token}, function(response) {
                    if(!response) { window.location.replace("dashboard")  }
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
                $.post("core/auth/simple.php?request=register",{email: email, username: username, password: password, token: token}, function(response) {
                    if(!response) { window.location.replace("dashboard")  }
                    else { alert(response) }
                });
            });
        });
    });
})