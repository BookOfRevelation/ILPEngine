IMG = setmetatable({}, {__index = function(self, key)
    local res = love.graphics.newImage("img/" .. key)
    rawset(self, key, res)
    return res
end})

