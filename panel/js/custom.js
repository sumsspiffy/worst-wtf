$(document).ready(function() { 
  $("#open").on("click", function() {
    $(".container").css({"visibility": "visible"})
    $(".container").fadeTo("slow", 1)
  })

  $("#login").on("click", function() {
    $('.register-tab').removeClass('active')
    $('.login-tab').addClass('active')
    $('.card').css({"height": "280px"})
  })

  $("#register").on("click", function() {
    $('.register-tab').addClass('active')
    $('.login-tab').removeClass('active')
    $('.card').css({"height": "350px"})
  })
})