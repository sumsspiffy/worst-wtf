$(document).ready(function() { 
    $('#public').click(function() { 
        $('#public').fadeTo("fast", 1); $("#private").fadeTo("fast", 0.55);$("#all").fadeTo("fast", 0.55);
        $(".private").fadeOut(0); $(".all").fadeOut(0); $(".public").fadeIn(0);
    });
    $("#private").click(function() { 
        $("#private").fadeTo("fast", 1); $("#public").fadeTo("fast", 0.55); $("#all").fadeTo("fast", 0.55);
        $(".public").fadeOut(0); $(".all").fadeOut(0); $(".private").fadeIn(0);
    });
    $("#all").click(function() { 
        $("#private").fadeTo("fast", 0.55); $("#public").fadeTo("fast", 0.55); $("#all").fadeTo("fast", 1);
        $(".public").fadeOut(0); $(".private").fadeOut(0); $(".all").fadeIn(0);
    });
  })