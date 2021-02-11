 local chienchaud = ClientsideModel("models/food/hotdog.mdl")
        chienchaud:SetNoDraw(true)
        chienchaud:SetModelScale(100)
        timer.Create("charglogo", 0.01, 0, function()
          chienchaud:SetAngles(Angle(0, CurTime()*90 % 360 ,0) )
        end)
        local data = {}
        local function genchienchaud(id)
          local pos = LocalPlayer():GetPos()
          data[id] = { Vector(math.random(pos.x-9000,pos.x+9000),math.random(pos.y-9000,pos.y+9000),pos.z + math.random(5000,2000) ), math.random(70, 170) }
        end
        for i=1, 80 do
          genchienchaud(i)
        end
        hook.Add("PostDrawOpaqueRenderables","\xFFitsrainingchienchauds\xFF",function()
          local z = LocalPlayer():GetPos().z
          for i=1, #data do
            chienchaud:SetPos(data[i][1])
            chienchaud:SetupBones()
            chienchaud:DrawModel()
            data[i][1].z = data[i][1].z - data[i][2] / 50
            if data[i][1].z <= z then
              genchienchaud(i)
            end
          end
        end)

 local chienchaud2 = ClientsideModel("models/food/burger.mdl")
        chienchaud2:SetNoDraw(true)
        chienchaud2:SetModelScale(100)
        timer.Create("charglogo2", 0.01, 0, function()
          chienchaud2:SetAngles(Angle(0, CurTime()*90 % 360 ,0) )
        end)
        local data2 = {}
        local function genchienchaud2(id)
          local pos = LocalPlayer():GetPos()
          data2[id] = { Vector(math.random(pos.x-9000,pos.x+9000),math.random(pos.y-9000,pos.y+9000),pos.z + math.random(5000,2000) ), math.random(70, 170) }
        end
        for i=1, 80 do
          genchienchaud2(i)
        end
        hook.Add("PostDrawOpaqueRenderables","\xFFitsrainingchienchauds2\xFF",function()
          local z = LocalPlayer():GetPos().z
          for i=1, #data2 do
            chienchaud2:SetPos(data2[i][1])
            chienchaud2:SetupBones()
            chienchaud2:DrawModel()
            data2[i][1].z = data2[i][1].z - data2[i][2] / 50
            if data2[i][1].z <= z then
              genchienchaud2(i)
            end
          end
        end)