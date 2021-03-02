$(document).ready(function() { 
  function showTab(tab) {
    if (tab == 1) { 
      $("#tab-login").fadeTo("fast", 1); $("#tab-register").fadeTo("fast", 0.55);
      $(".tab-register").fadeOut(0); $(".tab-login").fadeIn(0);
      $('.card').height("21rem");
      $('.center').height("10rem");
    }
    else if (tab == 2) { 
      $('#tab-register').fadeTo("fast", 1); $("#tab-login").fadeTo("fast", 0.55);
      $('.tab-login').fadeOut(0); $('.tab-register').fadeIn(0);
      $('.card').height("26rem");
      $('.center').height("15rem");
    }
  }

  $(document).mouseup(function(e) { 
    if(!$(".card").is(e.target) && $(".card").has(e.target).length === 0 && $(".card").css('display') != 'none') { $(".content").fadeOut(450); }
  })

  $('#show').click(function() { $(".content").fadeIn(450); });
  $('#tab-login').click(function() { showTab(1); });
  $("#tab-register").click(function() { showTab(2); });
})