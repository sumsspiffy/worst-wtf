local Frame = vgui.Create("DFrame")
Frame:SetTitle('')
Frame:SetSize(500, 110)
Frame:SetPos(ScrW()/2, ScrH()/2)
Frame:ShowCloseButton(false)
Frame:SetDraggable(false)
Frame.Paint = nil
Frame:Center()

local HTML = vgui.Create('DHTML', Frame)
HTML:OpenURL('https://w0rst.xyz/project/images/wlogo.png')
HTML.Paint = nil
HTML:Dock(FILL)