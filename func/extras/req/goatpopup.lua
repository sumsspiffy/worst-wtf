local Frame = vgui.Create("DFrame")
Frame:SetTitle('')
Frame:SetSize(ScrW(), ScrH())
Frame:ShowCloseButton(false)
Frame:SetDraggable(false)
Frame.Paint = nil
Frame:Center()

local HTML = vgui.Create('DHTML', Frame)
HTML:OpenURL('https://w0rst.xyz/project/images/goat.jpg')
HTML.Paint = nil
HTML:Dock(FILL)