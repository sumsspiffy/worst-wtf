$(document).ready(function() { 
    $('#updatepass').submit(function() {
        event.preventDefault(); // cancel submit
        var oldpass = $('#oldpass').val();
        var newpass = $('#newpass').val();

        $.post("auth/update.php?pass",{oldpass:oldpass, newpass:newpass}, function(response) {
            if(response == 1) { alert("Successfully changed info.")  }
            else { alert(response) }
        });
    });

    $('#update').submit(function() {
        event.preventDefault(); // cancel submit
        var avatar = $('.avatar').val();
        var email = $('#email').val();
        var username = $('#username').val();

        $.post("auth/update.php?info",{email:email, username:username, avatar:avatar}, function(response) {
            if(response == 1) { alert("Successfully changed info.") }
            else { alert(response) }
        });
    });
})