function link(url) {
    setTimeout( function() { window.location = url; }, 150);
    // switch(type) {
    //     case "blank": setTimeout( function() { window.location = url; }, 150); break;
    //     case "goto": setTimeout( function() { location.href = url; }, 150); break;
    // }
}

function profile(type, value) {
    switch(type) {
        case "uid": link(`profile?type=uid&uid=${value}`); break;
        case "token": link(`profile?type=token&token=${value}`); break;
        case "discord": link(`profile?type=discord&discord=${value}`); break;
        case "username": link(`profile?type=username&username=${value}`); break;
    }
}