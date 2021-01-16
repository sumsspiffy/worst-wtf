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

local upgrad = Material("gui/gradient_up")
local downgrad = Material("gui/gradient_down")

local Frame = vgui.Create("DFrame")
Frame:ShowCloseButton(false)
Frame:Center()
Frame:SetSize(300, 150)
Frame:SetTitle("")
Frame:SetVisible(true)
Frame:MakePopup()
Frame.Paint = function(self,w,h)
    surface.SetDrawColor(28, 28, 28)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(26, 26, 26)
    surface.SetMaterial(upgrad)
    surface.SetDrawColor(8, 8, 8)
    surface.SetMaterial(downgrad)
    local rainbow = HSVToColor((CurTime() * 99) % 360, 1, 1)
    surface.SetDrawColor(rainbow.r,rainbow.g,rainbow.b)
    surface.DrawOutlinedRect(0, 0, w, h)
    draw.SimpleText("W0RST Login-System", "Default", 10, 10, Color(230, 230, 230))
end

local EntryPanel = vgui.Create("DFrame", Frame)
EntryPanel:ShowCloseButton(false)
EntryPanel:SetDraggable(false)
EntryPanel:SetTitle(" ")
EntryPanel:SetSize(280, 93)
EntryPanel:SetPos(10, 25)
EntryPanel.Paint = function(self,w,h)
    surface.SetDrawColor(Color(27, 27, 27, 130))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(24, 24, 24, 220)
    surface.DrawOutlinedRect(0, 0, w, h)
end

local UserEntry = vgui.Create("DTextEntry", EntryPanel)
UserEntry:SetPos(25, 28)
UserEntry:AllowInput()
UserEntry:SetSize(230, 20)
UserEntry:SetValue("")
UserEntry.Paint = function(self, w, h)
    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(20,20,20,150))
    surface.DrawOutlinedRect(0,0,w,h)
    self:DrawTextEntryText(Color(255, 255, 255), Color(20, 20, 150), Color(100, 100, 100))
end

local PassEntry = vgui.Create("DTextEntry", EntryPanel)
PassEntry:SetPos(25, 58)
PassEntry:AllowInput()
PassEntry:SetTextColor(Color(255,255,255))
PassEntry:SetSize(230, 20)
PassEntry:SetValue("")
PassEntry.Paint = function(self, w, h)
    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(20,20,20,150))
    surface.DrawOutlinedRect(0,0,w,h)
    self:DrawTextEntryText(Color(35, 30, 30, 255), Color(20, 20, 150), Color(255, 255, 255, 10))
end

CloseButton=vgui.Create("DButton", Frame)
CloseButton:SetText("X")
CloseButton:SetSize(30,30)
CloseButton:SetPos(270,0)
CloseButton.DoClick = function() Frame:Close() end
CloseButton.Paint = function(self,w,h)
    self:SetTextColor(Color(75,75,75, 105))
    surface.SetDrawColor(Color(0,0,0,0))
    surface.DrawOutlinedRect(0,0,w,h)
end

local LoginButton = vgui.Create("DButton", Frame)
LoginButton:SetText("Login")
LoginButton:SetPos(190, 123)
LoginButton:SetFont("Trebuchet18")
LoginButton:SetSize(100, 20)
LoginButton.DoClick = function()
    user = UserEntry:GetValue()
    pass = PassEntry:GetValue()
    wtf.Authenticate(user, pass)
    Frame:Close()
end
LoginButton.Paint = function(self, w,h)
    draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(30, 30, 30, 255))
    surface.SetDrawColor(32, 32, 32, 255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    self:SetTextColor(Color(255,255,255))
end

local ForumButton = vgui.Create("DButton", Frame)
ForumButton:SetText("Forum")
ForumButton:SetPos(80, 123)
ForumButton:SetFont("Trebuchet18")
ForumButton:SetSize(100, 20)
ForumButton.DoClick = function()
    gui.OpenURL("https://w0rst.xyz/")
end
ForumButton.Paint = function(self, w,h)
    draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(30, 30, 30, 255))
    surface.SetDrawColor(32, 32, 32, 255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    self:SetTextColor(Color(255,255,255))
end

if(not file.Exists("w0rst", "DATA")) then file.CreateDir("w0rst")
elseif(file.Exists("w0rst/login.txt", "DATA")) then
    local l = string.Split(file.Read("w0rst/login.txt"), ":")
    wtf.Authenticate(util.Base64Decode(l[1]), util.Base64Decode(l[2]));
    Frame:Close()
end
