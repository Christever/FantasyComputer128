---@class InputAPI
local InputAPI = {}

local input = nil

--- Initialise l'API clavier.
---@param inputSystem Input
function InputAPI.init(inputSystem)
    input = inputSystem
end

--- Vérifie si une commande est maintenue.
---@param button string
---@return boolean
function InputAPI.btn(button)
    return input:isKeyDown(button)
end

--- Vérifie si une commande vient d'être pressée.
---@param button string
---@return boolean
function InputAPI.btnp(button)
    return input:wasKeyPressed(button)
end

return InputAPI