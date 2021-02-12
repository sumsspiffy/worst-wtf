$(document).ready(function() { 
  $("#open").on("click", function() {
    $(".container").css({"visibility": "visible"})
    $(".container").fadeTo("slow", 1)
  })
})