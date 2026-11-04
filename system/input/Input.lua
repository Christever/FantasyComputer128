---@class Input
local Input = {}

--- Vérifie si une touche est actuellement maintenue
---@param key string
---@return boolean
function Input.isKeyDown(key)
    return love.keyboard.isDown(key)
end

return Input
