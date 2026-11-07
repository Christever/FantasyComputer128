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
    if not input then
        return false
    end

    if input:isKeyDown(button) then
        return true
    end

    for i = 1, input:getJoystickCount() do
        if input:wasJoystickButtonPressed(i, button) then
            return true
        end
    end

    return false
end

--- Vérifie si une commande vient d'être pressée.
---@param button string
---@return boolean
function InputAPI.btnp(button)
    if not input then
        return false
    end

    if input:wasKeyPressed(button) then
        return true
    end

    for i = 1, input:getJoystickCount() do
        if input:wasJoystickButtonPressed(i, button) then
            return true
        end
    end

    return false
end

--- Vérifie si une commande vient d'être relâchée.
---@param button string
---@return boolean
function InputAPI.btnr(button)
    if not input then
        return false
    end

    if input:wasKeyReleased(button) then
        return true
    end

    for i = 1, input:getJoystickCount() do
        if input:wasJoystickButtonReleased(i, button) then
            return true
        end
    end

    return false
end

--- Retourne la valeur d'un axe analogique.
---@param joystickIndex integer
---@param axis string
---@return number
function InputAPI.axis(joystickIndex, axis)
    if not input then
        return 0
    end

    return input:getJoystickAxis(joystickIndex, axis)
end

--- Retourne une direction numérique à partir d'un axe analogique.
---@param joystickIndex integer
---@param axis string
---@return integer
function InputAPI.direction(joystickIndex, axis)
    if not input then
        return 0
    end

    return input:getJoystickDirection(joystickIndex, axis)
end

--- Retourne le nombre de manettes connectées.
---@return integer
function InputAPI.joystickCount()
    if not input then
        return 0
    end

    return input:getJoystickCount()
end

--- Vérifie si une manette est connectée à un index donné.
---@param joystickIndex integer
---@return boolean
function InputAPI.joystickConnected(joystickIndex)
    if not input then
        return false
    end

    return input:hasJoystick(joystickIndex)
end

return InputAPI
