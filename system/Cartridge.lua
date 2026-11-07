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

--- Recherche les cartouches disponibles.
---@return table
function Cartridge:getAvailable()
    local cartridges = {}

    local directories = love.filesystem.getDirectoryItems("cartridges")

    for _, directory in ipairs(directories) do
        local path = "cartridges/" .. directory
        local info = love.filesystem.getInfo(path)

        if info and info.type == "directory" then
            local mainPath = path .. "/main.lua"
            local mainInfo = love.filesystem.getInfo(mainPath)

            if mainInfo and mainInfo.type == "file" then
                table.insert(cartridges, {
                    name = directory:upper(),
                    path = mainPath
                })
            end
        end
    end

    table.sort(cartridges, function(a, b)
        return a.name < b.name
    end)

    return cartridges
end

return Cartridge
