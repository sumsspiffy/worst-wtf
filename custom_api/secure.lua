local wtf={}

--[[
    quick little explanation on how this actually works
    we fetch the share url with a user identifier for handling
    then with that info we split it into readable forms for lua
    then we can do whatever we want with that info later
]]

local function GatherData()
    local storage = {}
    http.Post("https://w0rst.xyz/", { user=user }, function(b)
        for line in string.gmatch(b, '[^\n]+') do 
            local value = string.Split(line, "=")
            storage[value[1]] = value[2]
        end
    end, function(m) print(m) end)
    return storage
end

// local Info = GatherData()

--/ lua security
local secure = {}
local functions = {}

function secure.Random(len)
    local result = {}

    for i = 1, len do
        result[i] = string.char(math.random(32, 126))
    end

    return table.concat(result)
end

function secure.Function(func)
    function functions[secure.Random(24)]() func() end
end

secure.Function(function()
    print('this is an extreme waste of my time...')
end)