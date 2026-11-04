---@class Input
---@field pressedKeys table<string, boolean>
---@field releasedKeys table<string, boolean>
---@field joysticks table
---@field KEYS table<string, string>
local Input = {}
Input.__index = Input
-------------------------  LOCALES -----------------

local function keypressed(self, key)
    self.pressedKeys[key] = true
end


local function keyreleased(self, key)
    self.releasedKeys[key] = true
end

----------------------------------------------------

--- Crée une nouvelle instance Input
---@return Input
function Input.new()
    local self = setmetatable({}, Input)

    self.pressedKeys = {}
    self.releasedKeys = {}
    self.joysticks = {}

    self.KEYS = {
        LEFT   = "left",
        RIGHT  = "right",
        UP     = "up",
        DOWN   = "down",
        A      = "x",
        B      = "c",
        START  = "return",
        SELECT = "space",
        EXIT   = "escape"
    }

    love.keypressed = function(key)
        keypressed(self, key)
    end

    love.keyreleased = function(key)
        keyreleased(self, key)
    end
    return self
end

--- Initialise les manettes connectées
function Input:init()
    self.joysticks = love.joystick.getJoysticks()

    print("Manettes détectées :", #self.joysticks)
end

--- Convertit une commande logique en touche physique
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@return string
function Input:getKey(key)
    local physicalKey = self.KEYS[key]

    assert(physicalKey, "Commande clavier inconnue : " .. tostring(key))

    return physicalKey
end

--- Vérifie si une touche est actuellement maintenue
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@return boolean
function Input:isKeyDown(key)
    return love.keyboard.isDown(self:getKey(key))
end

--- Vérifie si une touche vient d'être pressée
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@return boolean
function Input:wasKeyPressed(key)
    return self.pressedKeys[self:getKey(key)] == true
end

--- Vérifie si une touche vient d'être relâchée
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@return boolean
function Input:wasKeyReleased(key)
    return self.releasedKeys[self:getKey(key)] == true
end

--- Réinitialise les événements clavier
function Input:update()
    self.pressedKeys = {}
    self.releasedKeys = {}
end

--- Modifie la touche physique associée à une commande
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@param physicalKey string
function Input:setKey(key, physicalKey)
    assert(self.KEYS[key], "Commande clavier inconnue : " .. tostring(key))
    assert(type(physicalKey) == "string", "Touche physique invalide")

    self.KEYS[key] = physicalKey
end

return Input
