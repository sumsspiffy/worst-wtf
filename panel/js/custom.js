$(document).ready(function() { 
  $("#open").on("click", function() {
    $(".container").css({"visibility": "visible"})
    $(".container").fadeTo("slow", 1)
  })

  $("#login").on("click", function() {
    $('.register-tab').removeClass('active')
    $('.login-tab').addClass('active')
  })

  $("#register").on("click", function() {
    $('.register-tab').addClass('active')
    $('.login-tab').removeClass('active')
  })
})