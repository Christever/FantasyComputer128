local Logger = require("system.Logger")
---@class MemoryAPI
local MemoryAPI = {}

local memory

--- Initialise l'API mémoire.
---@param memoryInstance Memory
function MemoryAPI.init(memoryInstance)
    memory = memoryInstance
end

--- Lit un octet à une adresse CPU.
---@param address integer
---@return integer
function MemoryAPI.peek(address)
    Logger.assert(memory, "API mémoire non initialisée")

    return memory:read(address)
end

--- Écrit un octet à une adresse CPU.
---@param address integer
---@param value integer
function MemoryAPI.poke(address, value)
    Logger.assert(memory, "API mémoire non initialisée")

    memory:write(address, value)
end

return MemoryAPI