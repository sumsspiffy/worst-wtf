function link(url) {
    setTimeout( function() { location.href = url; }, 150);
}

function profile(type, value) {
    switch(type) {
        case "uid": setTimeout( function() { location.href = `profile?type=uid&uid=${value}`; }, 150); break;
        case "token": setTimeout( function() { location.href = `profile?type=token&token=${value}`; }, 150); break;
        case "discord": setTimeout( function() { location.href = `profile?type=discord&discord=${value}`; }, 150); break;
        case "username": setTimeout( function() { location.href = `profile?type=username&username=${value}`; }, 150); break;
    }
}