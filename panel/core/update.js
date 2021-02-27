$(document).ready(function() { 
   $('#update').submit(function() {
      event.preventDefault(); // cancel submit
      var usergroup = $('.usergroup').val();
      var blacklist = $('#blacklist').val();
      var uid = $('#uid').val();

      $.post("auth/update.php?user",{uid:uid, usergroup:usergroup, blacklist:blacklist}, function(response) {
         if(response == 1) { alert("Successfully changed info.")  }
         else { alert(response) }
      });
   });
})