local Logger = require("system.Logger")
---@class Memory
local Memory = {}

-- Tailles physiques des mémoires
Memory.ROM_SIZE = 32 * 1024
Memory.RAM_SIZE = 128 * 1024
Memory.VRAM_SIZE = 64 * 1024

-- Espace d'adressage du CPU
Memory.ADDRESS_SPACE = 64 * 1024

-- Début des régions mémoire
Memory.ROM_START = 0x0000
Memory.RAM_START = 0x4000
Memory.VRAM_START = 0x8000
Memory.BANK_START = 0xC000

-- Fin des régions mémoire
Memory.ROM_END = 0x3FFF
Memory.RAM_END = 0x7FFF
Memory.VRAM_END = 0xBFFF
Memory.BANK_END = 0xFFFF

-- Taille d'une banque
Memory.BANK_SIZE = 16 * 1024

-- Nombre de banques physiques
Memory.ROM_BANKS = Memory.ROM_SIZE / Memory.BANK_SIZE
Memory.RAM_BANKS = Memory.RAM_SIZE / Memory.BANK_SIZE
Memory.VRAM_BANKS = Memory.VRAM_SIZE / Memory.BANK_SIZE

-- Création d'une zone mémoire
local function createMemory(size, value)
    local memory = {}

    for i = 1, size do
        memory[i] = value
    end

    return memory
end

-- Détermine la région correspondant à une adresse CPU
---@param address integer
---@return "ROM"|"RAM"|"VRAM"|"BANK"
function Memory.getRegion(address)
    Logger.assert(address >= 0 and address < Memory.ADDRESS_SPACE,
        "Adresse CPU invalide")

    if address <= Memory.ROM_END then
        return "ROM"
    elseif address <= Memory.RAM_END then
        return "RAM"
    elseif address <= Memory.VRAM_END then
        return "VRAM"
    else
        return "BANK"
    end
end

-- Calcule le décalage dans une banque
---@param address integer
---@return integer
function Memory.getOffset(address)
    Logger.assert(address >= 0 and address < Memory.ADDRESS_SPACE,
        "Adresse CPU invalide")

    return address % Memory.BANK_SIZE
end

-- Calcule une adresse physique
---@param address integer
---@param bank integer
---@return integer
function Memory.getPhysicalAddress(address, bank)
    local offset = Memory.getOffset(address)

    return bank * Memory.BANK_SIZE + offset
end

function Memory.new()
    local self = setmetatable({}, { __index = Memory })

    -- Mémoires physiques
    self.rom = createMemory(Memory.ROM_SIZE, 0)
    self.ram = createMemory(Memory.RAM_SIZE, 0)
    self.vram = createMemory(Memory.VRAM_SIZE, 0)

    -- Sélecteurs de banques
    self.romBank = 0
    self.ramBank = 0
    self.vramBank = 0

    self:reset()

    return self
end

-- Lecture directe de la RAM
---@param address integer
---@return integer
function Memory:readRAM(address)
    Logger.assert(address >= 0 and address < Memory.RAM_SIZE,
        "Adresse RAM invalide")

    return self.ram[address + 1]
end

-- Écriture directe dans la RAM
---@param address integer
---@param value integer
function Memory:writeRAM(address, value)
    Logger.assert(address >= 0 and address < Memory.RAM_SIZE,
        "Adresse RAM invalide")

    Logger.assert(value >= 0 and value <= 255,
        "Valeur invalide")

    self.ram[address + 1] = value
end

-- Lecture directe de la ROM
---@param address integer
---@return integer
function Memory:readROM(address)
    Logger.assert(address >= 0 and address < Memory.ROM_SIZE,
        "Adresse ROM invalide")

    return self.rom[address + 1]
end

-- Écriture dans la ROM interdite
function Memory:writeROM(address, value)
    Logger.raise("Impossible d'ecrire dans la ROM")
end

-- Lecture directe de la VRAM
---@param address integer
---@return integer
function Memory:readVRAM(address)
    Logger.assert(address >= 0 and address < Memory.VRAM_SIZE,
        "Adresse VRAM invalide")

    return self.vram[address + 1]
end

-- Écriture directe dans la VRAM
---@param address integer
---@param value integer
function Memory:writeVRAM(address, value)
    Logger.assert(address >= 0 and address < Memory.VRAM_SIZE,
        "Adresse VRAM invalide")

    Logger.assert(value >= 0 and value <= 255,
        "Valeur invalide")

    self.vram[address + 1] = value
end

-- Lecture via l'espace d'adressage du CPU
---@param address integer
---@return integer
function Memory:read(address)
    local region = Memory.getRegion(address)
    local offset = Memory.getOffset(address)

    if region == "ROM" then
        local physicalAddress =
            self.romBank * Memory.BANK_SIZE + offset

        return self.rom[physicalAddress + 1]
    elseif region == "RAM" then
        return self.ram[offset + 1]
    elseif region == "VRAM" then
        local physicalAddress =
            self.vramBank * Memory.BANK_SIZE + offset

        return self.vram[physicalAddress + 1]
    elseif region == "BANK" then
        local physicalAddress =
            (self.ramBank + 1) * Memory.BANK_SIZE + offset

        return self.ram[physicalAddress + 1]
    else
        Logger.raise("Région mémoire inconnue")
    end
    return 0
end

-- Écriture via l'espace d'adressage du CPU
---@param address integer
---@param value integer
function Memory:write(address, value)
    Logger.assert(value >= 0 and value <= 255,
        "Valeur invalide")

    local region = Memory.getRegion(address)
    local offset = Memory.getOffset(address)

    if region == "ROM" then
        Logger.raise("Impossible d'ecrire dans la ROM")
    elseif region == "RAM" then
        self.ram[offset + 1] = value
    elseif region == "VRAM" then
        local physicalAddress =
            self.vramBank * Memory.BANK_SIZE + offset

        self.vram[physicalAddress + 1] = value
    elseif region == "BANK" then
        local physicalAddress =
            (self.ramBank + 1) * Memory.BANK_SIZE + offset

        self.ram[physicalAddress + 1] = value
    end
end

-- Sélection de la banque RAM
---@param bank integer
function Memory:setRAMBank(bank)
    Logger.assert(bank >= 0 and bank < Memory.RAM_BANKS - 1,
        "Banque RAM invalide")

    self.ramBank = bank
end

-- Sélection de la banque VRAM
---@param bank integer
function Memory:setVRAMBank(bank)
    Logger.assert(bank >= 0 and bank < Memory.VRAM_BANKS,
        "Banque VRAM invalide")

    self.vramBank = bank
end

-- Sélection de la banque ROM
---@param bank integer
function Memory:setROMBank(bank)
    Logger.assert(bank >= 0 and bank < Memory.ROM_BANKS,
        "Banque ROM invalide")

    self.romBank = bank
end

-- État des banques mémoire
function Memory:getBankStatus()
    return {
        rom = self.romBank,
        ram = self.ramBank,
        vram = self.vramBank
    }
end

-- Réinitialisation des sélecteurs de banques
function Memory:reset()
    self.romBank = 0
    self.ramBank = 0
    self.vramBank = 0
end

--- Efface le contenu de la RAM et de la VRAM.
function Memory:clear()
    -- Effacer la RAM
    for i = 1, #self.ram do
        self.ram[i] = 0
    end

    -- Effacer la VRAM
    for i = 1, #self.vram do
        self.vram[i] = 0
    end

    -- Réinitialiser les banques
    self:reset()
end

return Memory
