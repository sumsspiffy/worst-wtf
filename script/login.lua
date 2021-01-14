local wtf = {}
wtf.UserInfo={}; wtf.SteamId=LocalPlayer():SteamID(); wtf.IgnName=LocalPlayer():Name()
table.insert(wtf.UserInfo, wtf.SteamId); table.insert(wtf.UserInfo, wtf.IgnName)

function wtf.Authenticate(user, pass)
    http.Post("https://w0rst.xyz/api/simple.php", { 
    username=user, password=pass, 
    steam_id=wtf.UserInfo[1], 
    steam_name=wtf.UserInfo[2] }, function(b)
        local simple_response = string.Split(b, " ")
        if(simple_response[1] == "Fc83458Cfc60dFB8410e3aDf") then --/ user has been authed
            file.Write("w0rst/login.txt", util.Base64Encode(user)..":"..util.Base64Encode(pass))
            http.Post("https://w0rst.xyz/api/load.php", {Ecb32De6EDdfB3Dd49e5A93c="Ce4c88f3E9969F4fcFD93400"}, function(b) RunString(b) end)
        elseif(simple_response[1] == "C8Bf45Ac64e1afa38a45142a") then --/ user has been banned, blacklisted or check failed       
            if(file.Exists("w0rst/login.txt", "DATA")) then file.Delete("w0rst/login.txt") end 
            function crash() return crash() end crash() --/ Recursion crash method
        end
    end)
end

surface.CreateFont("Font", {
    font = "Open Sans", 
    extended = false,  
    size = 20, 
    weight = 1000, 
    blursize = 0, 
    scanlines = 0,
    antialias = true, 
    underline = false,  
    italic = false, 
    strikeout = false, 
    symbol = false, 
    rotary = false, 
    shadow = true, 
    additive = false, 
    outline = false
})

surface.CreateFont("Font2", {
    font = "Open Sans", 
    extended = false,  
    size = 15, 
    weight = 1000, 
    blursize = 0, 
    scanlines = 0,
    antialias = true, 
    underline = false,  
    italic = false, 
    strikeout = false, 
    symbol = false, 
    rotary = false, 
    shadow = true, 
    additive = false, 
    outline = false
})

local frame = vgui.Create("DFrame")
frame:ShowCloseButton(false)
frame:Center()
frame:SetSize(300, 150) 
frame:SetTitle("") 
frame:SetVisible(true) 
frame:MakePopup()
frame.Paint = function(self,w,h)
    local rainbow = HSVToColor((CurTime() * 99) % 360, 1, 1)
    draw.RoundedBox(0,0,0,w,h,Color(30, 30, 30, 255))
    surface.SetDrawColor(rainbow.r,rainbow.g,rainbow.b,255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    draw.SimpleText("W0RST | Login", "Font", 90, 5, Color(rainbow.r, rainbow.g,rainbow.b, 170))
    draw.SimpleText("Username", "Font2", 15, 43, Color(75,75,80))
    draw.SimpleText("Password", "Font2", 15, 75, Color(75,75,80))
end

local user_entry = vgui.Create("DTextEntry", frame)
user_entry:SetPos(85, 43)
user_entry:AllowInput()
user_entry:SetSize(190, 20)
user_entry:SetValue("")
user_entry.Paint = function(self, w, h)
    surface.SetDrawColor(40, 40, 40, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
    self:DrawTextEntryText(Color(255, 255, 255), Color(20, 20, 150), Color(100, 100, 100))
end

local pass_entry = vgui.Create("DTextEntry", frame)
pass_entry:SetPos(85, 73)
pass_entry:AllowInput()
pass_entry:SetTextColor(Color(255,255,255))
pass_entry:SetSize(190, 20)
pass_entry:SetValue("")
pass_entry.Paint = function(self, w, h)
    surface.SetDrawColor(40, 40, 40, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
    self:DrawTextEntryText(Color(35, 30, 30, 255), Color(20, 20, 150), Color(100, 100, 100))
end

close_button=vgui.Create("DButton", frame)
close_button:SetText("X")
close_button:SetSize(30,30)
close_button:SetPos(270,0)
close_button.Paint = function(s,w,h)
    surface.SetDrawColor(Color(0,0,0,0))
    surface.DrawOutlinedRect(0,0,w,h)
end
close_button.DoClick = function() 
    frame:Close() 
end

local login_button = vgui.Create("DButton", frame)
login_button:SetText("Login")
login_button:SetPos(190, 115)
login_button:SetFont("Trebuchet18")
login_button:SetSize(100, 25)
login_button.DoClick = function()
    user = user_entry:GetValue()
    pass = pass_entry:GetValue()
    wtf.Authenticate(user, pass)
    frame:Close()
end
login_button.Paint = function(self, w,h)
    draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
    surface.SetDrawColor(40, 40, 40, 255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    self:SetTextColor(Color(255,255,255))
end

local forum_button = vgui.Create("DButton", frame)
forum_button:SetText("Forum")
forum_button:SetPos(80, 115)
forum_button:SetFont("Trebuchet18")
forum_button:SetSize(100, 25)
forum_button.DoClick = function()
    gui.OpenURL("https://w0rst.xyz/")
end
forum_button.Paint = function(self, w,h)
    draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
    surface.SetDrawColor(40, 40, 40, 255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    self:SetTextColor(Color(255,255,255))
end

if(not file.Exists("w0rst", "DATA")) then file.CreateDir("w0rst")
elseif(file.Exists("w0rst/login.txt", "DATA")) then
    local l = string.Split(file.Read("w0rst/login.txt"), ":")
    wtf.Authenticate(util.Base64Decode(l[1]), util.Base64Decode(l[2])); 
    frame:Close()
end
