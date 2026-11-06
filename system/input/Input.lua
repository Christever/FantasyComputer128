local Logger = require("system.Logger")
---@class Input
---@field onKeyPressed fun(key: string)|nil
local Input = {}
Input.__index = Input
-------------------------  LOCALES -----------------

local function keypressed(self, key)
    self.pressedKeys[key] = true
end


local function keyreleased(self, key)
    self.releasedKeys[key] = true
end

local function joystickadded(self, joystick)
    local id = joystick:getID()

    for _, current in ipairs(self.joysticks) do
        if current:getID() == id then
            print("Manette déjà connectée :", joystick:getName())
            return
        end
    end

    table.insert(self.joysticks, joystick)
    print("Manette connectée :", joystick:getName())
end

local function joystickremoved(self, joystick)
    for i, current in ipairs(self.joysticks) do
        if current:getID() == joystick:getID() then
            table.remove(self.joysticks, i)
            break
        end
    end

    print("Manette déconnectée")
end

local function joystickpressed(self, joystick, button)
    local id = joystick:getID()

    if not self.pressedJoystickButtons[id] then
        self.pressedJoystickButtons[id] = {}
    end

    self.pressedJoystickButtons[id][button] = true
end

local function joystickreleased(self, joystick, button)
    local id = joystick:getID()

    if not self.releasedJoystickButtons[id] then
        self.releasedJoystickButtons[id] = {}
    end

    self.releasedJoystickButtons[id][button] = true
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

    self.GAMEPAD_BUTTONS = {
        LEFT   = "dpleft",
        RIGHT  = "dpright",
        UP     = "dpup",
        DOWN   = "dpdown",
        A      = "a",
        B      = "b",
        START  = "start",
        SELECT = "back"
    }
    self.pressedJoystickButtons = {}
    self.releasedJoystickButtons = {}

    self.deadZone = 0.20

    love.keypressed = function(key)
        self.pressedKeys[key] = true

        if self.onKeyPressed then
            self.onKeyPressed(key)
        end
    end

    love.keyreleased = function(key)
        keyreleased(self, key)
    end

    love.joystickadded = function(joystick)
        joystickadded(self, joystick)
    end

    love.joystickremoved = function(joystick)
        joystickremoved(self, joystick)
    end

    love.gamepadpressed = function(joystick, button)
        joystickpressed(self, joystick, button)
    end
    love.gamepadreleased = function(joystick, button)
        joystickreleased(self, joystick, button)
    end

    return self
end

--- Initialise les manettes connectées
function Input:init()
    self.joysticks = love.joystick.getJoysticks()
    self.pressedJoystickButtons = {}
    self.releasedJoystickButtons = {}

    print("Manettes détectées :", #self.joysticks)
end

--- Réinitialise l'état des entrées.
function Input:reset()
    self.pressedKeys = {}
    self.releasedKeys = {}

    self.pressedJoystickButtons = {}
    self.releasedJoystickButtons = {}
end

--- Convertit une commande logique en touche physique
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@return string
function Input:getKey(key)
    local physicalKey = self.KEYS[key]

    Logger.assert(physicalKey, "Commande clavier inconnue : " .. tostring(key))

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

    self.pressedJoystickButtons = {}
    self.releasedJoystickButtons = {}
end

--- Modifie la touche physique associée à une commande
---@param key "LEFT"|"RIGHT"|"UP"|"DOWN"|"A"|"B"|"START"|"SELECT"|"EXIT"
---@param physicalKey string
function Input:setKey(key, physicalKey)
    Logger.assert(self.KEYS[key], "Commande clavier inconnue : " .. tostring(key))
    Logger.assert(type(physicalKey) == "string", "Touche physique invalide")

    self.KEYS[key] = physicalKey
end

------------------------ JOYSTICK ---------------------------------

--- Retourne le nombre de manettes connectées
---@return integer
function Input:getJoystickCount()
    return #self.joysticks
end

--- Vérifie si une manette est connectée à un index donné
---@param index integer
---@return boolean
function Input:hasJoystick(index)
    return self.joysticks[index] ~= nil
end

--- Retourne une manette connectée
---@param index integer
---@return any|nil
function Input:getJoystick(index)
    return self.joysticks[index]
end

--- Vérifie si un bouton de manette est maintenu
---@param joystickIndex integer
---@param button string
---@return boolean
function Input:isJoystickButtonDown(joystickIndex, button)
    local joystick = self:getJoystick(joystickIndex)
    if not joystick then
        return false
    end
    return joystick:isGamepadDown(button)
end

--- Vérifie si un bouton de manette vient d'être pressé
---@param joystickIndex integer
---@param button string
---@return boolean
function Input:wasJoystickButtonPressed(joystickIndex, button)
    local joystick = self:getJoystick(joystickIndex)

    if not joystick then
        return false
    end

    local id = joystick:getID()

    return self.pressedJoystickButtons[id] ~= nil
        and self.pressedJoystickButtons[id][button] == true
end

--- Vérifie si un bouton de manette vient d'être relâché
---@param joystickIndex integer
---@param button string
---@return boolean
function Input:wasJoystickButtonReleased(joystickIndex, button)
    local joystick = self:getJoystick(joystickIndex)

    if not joystick then
        return false
    end

    local id = joystick:getID()

    return self.releasedJoystickButtons[id] ~= nil
        and self.releasedJoystickButtons[id][button] == true
end

--- Retourne la valeur d'un axe analogique
---@param joystickIndex integer
---@param axis string
---@return number
function Input:getJoystickAxis(joystickIndex, axis)
    local joystick = self:getJoystick(joystickIndex)

    if not joystick then
        return 0
    end

    local value = joystick:getGamepadAxis(axis)

    if math.abs(value) < self.deadZone then
        return 0
    end

    return value
end

--- Retourne une direction numérique à partir d'un axe analogique
---@param joystickIndex integer
---@param axis string
---@return integer
function Input:getJoystickDirection(joystickIndex, axis)
    local value = self:getJoystickAxis(joystickIndex, axis)

    if value < -self.deadZone then
        return -1
    elseif value > self.deadZone then
        return 1
    end

    return 0
end

--- Modifie la zone morte des sticks analogiques
---@param value number
function Input:setDeadZone(value)
    Logger.assert(value >= 0 and value < 1, "Zone morte invalide")
    self.deadZone = value
end

return Input
