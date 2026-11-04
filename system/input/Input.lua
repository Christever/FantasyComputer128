---@class Input
local Input        = {}

Input.pressedKeys  = {}
Input.releasedKeys = {}


Input.KEYS = {
    LEFT   = "left",
    RIGHT  = "right",
    UP     = "up",
    DOWN   = "down",
    A      = "a",
    B      = "b",
    START  = "return",
    SELECT = "escape"
}


--- Vérifie si une touche est actuellement maintenue
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"
---@return boolean
function Input.isKeyDown(key)
    return love.keyboard.isDown(Input.getKey(key))
end

--- Vérifie si une touche vient d'être pressée
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"
---@return boolean
function Input.wasKeyPressed(key)
    return Input.pressedKeys[Input.getKey(key)] == true
end

--- Enregistre l'appui d'une touche
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"
function Input.keypressed(key)
    Input.pressedKeys[key] = true
end

--- Enregistre le relâchement d'une touche
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"
function Input.keyreleased(key)
    Input.releasedKeys[key] = true
end

--- Vérifie si une touche vient d'être relâchée
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"
---@return boolean
function Input.wasKeyReleased(key)
    return Input.releasedKeys[Input.getKey(key)] == true
end

--- Convertit une commande logique en touche physique
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"
---@return string
function Input.getKey(key)
    return Input.KEYS[key] or key
end

--- Réinitialise les appuis clavier
function Input.update()
    Input.pressedKeys = {}
    Input.releasedKeys = {}
end

return Input
