function createRipple(event) {
  const button = event.currentTarget;

  const circle = document.createElement("span");
  const diameter = Math.max(button.clientWidth, button.clientHeight);
  const radius = diameter / 2;

  circle.style.width = circle.style.height = `${diameter}px`;
  circle.style.left = `${event.clientX - button.offsetLeft - radius}px`;
  circle.style.top = `${event.clientY - button.offsetTop - radius}px`;
  circle.classList.add("circle");

  const ripple = button.getElementsByClassName("circle")[0];

  if (ripple) {
    ripple.remove();
  }

  button.appendChild(circle);
}

$(document).ready(function() { 
  const card = $(".card");
  const content = $(".content");
  const buttons = $(".ripple");

  for (const button of buttons) {
    button.addEventListener("click", createRipple);
  }

  $(document).mouseup(function(e) { 
    if(!card.is(e.target) && card.has(e.target).length === 0 && content.css('display') != 'none') { 
      content.fadeOut(450);
    }
  })

  $('#show').click(function() {
    content.fadeIn(450);
  })

  // 410px

  $('#login').click(function() {
    // update active tabs
    $('.login-tab').fadeIn(0);
    $('.register-tab').fadeOut(0);

    // update sizes
    $('.frame').height("175px");
    $('.card').height("350px");
  })

  $('#register').click(function() {
    // update active tabs 
    $('.login-tab').fadeOut(0);
    $('.register-tab').fadeIn(0);

    // update sizes
    $('.frame').height("235px");
    $('.card').height("410px");
  })
})