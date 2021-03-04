$(document).ready(function() { 
    $('#update').submit(function() {
        event.preventDefault(); // cancel submit
        const oldpass = $('#old-password').val();
        const newpass = $('#new-password').val();

        $.post("core/auth/simple.php?request=update",{oldpass: oldpass, newpass: newpass}, function(response) {
            if(!response) { alert("Changed password."); }
            else { alert(response); }
        });
    });
})