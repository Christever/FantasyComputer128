---@class Cartridge
---@field program Program
---@field currentPath string|nil

local Cartridge = {}
Cartridge.__index = Cartridge

---@param program Program
function Cartridge.new(program)
    local self = setmetatable({}, Cartridge)

    self.program = program
    self.currentPath = nil

    return self
end

---@param path string
---@return boolean
function Cartridge:load(path)
    -- Décharger la cartouche actuelle
    if self.currentPath then
        self:unload()
    end

    -- Charger la nouvelle cartouche
    local success = self.program:load(path)

    if not success then
        return false
    end

    self.currentPath = path

    return true
end

---@return string|nil
function Cartridge:getCurrentPath()
    return self.currentPath
end

--- Décharge la cartouche actuelle.
function Cartridge:unload()
    self.program:stop()
    self.currentPath = nil
end

--- Recharge la cartouche actuelle.
---@return boolean
function Cartridge:reload()
    if not self.currentPath then
        return false
    end

    local path = self.currentPath

    return self:load(path)
end

return Cartridge
