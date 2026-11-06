local bit = require("bit")
local Logger = require("system.Logger")
---@class CPU
local CPU = {}

local REGISTER_NAMES = {
    [0x00] = "A",
    [0x01] = "B",
    [0x02] = "C",
    [0x03] = "D",
    [0x04] = "E",
    [0x05] = "H",
    [0x06] = "L",
}

local Instructions = require("system.cpu.Instructions")

--- Crée une nouvelle instance du CPU
---@param memory any
---@return CPU
function CPU.new(memory)
    local self = setmetatable({}, { __index = CPU })
    self.memory = memory
    self:reset()
    return self
end

function CPU:reset()
    -- Registres 8 bits
    self.A                    = 0
    self.B                    = 0
    self.C                    = 0
    self.D                    = 0
    self.E                    = 0
    self.H                    = 0
    self.L                    = 0
    self.F                    = 0

    -- Registres 16 bits
    self.PC                   = 0
    self.SP                   = 0xFFFF
    self.IX                   = 0
    self.IY                   = 0

    -- Indicateurs
    self.flags                = {}
    self.flags.Z              = false
    self.flags.C              = false
    self.flags.S              = false
    self.flags.P              = false

    -- État du processeur
    self.running              = false
    self.cycles               = 0
    self.halted               = false
    self.paused               = false
    self.instructionsExecuted = 0
end

-- Démarrer le processeur
function CPU:start()
    self.running = true
    self.paused  = false
    self.halted  = false
end

-- Arrêter le processeur
function CPU:stop()
    self.running = false
    self.paused  = false
    self.halted  = false
end

-- Lire une instruction en mémoire
function CPU:fetch()
    local instruction = self.memory:read(self.PC)
    self.PC = (self.PC + 1) % 0x10000
    return instruction
end

-- Décoder une instruction
function CPU:decode(opcode)
    for name, code in pairs(Instructions) do
        if code == opcode then
            return name
        end
    end


    Logger.raise("Instruction inconnue : " .. tostring(opcode))
end

function CPU:updateParity(value)
    local count = 0

    for i = 1, 8 do
        if value % 2 == 1 then
            count = count + 1
        end

        value = math.floor(value / 2)
    end

    self.flags.P = (count % 2 == 0)
end

function CPU:updateParity16(value)
    local count = 0

    for i = 1, 16 do
        if value % 2 == 1 then
            count = count + 1
        end

        value = math.floor(value / 2)
    end

    self.flags.P = count % 2 == 0
end

-- Exécuter une instruction
function CPU:execute(instruction)
    if not self.running then
        return
    end
    local instructionCycles = {
        NOP       = 4,
        HALT      = 4,
        LDA       = 7,
        LDB       = 7,
        ADD       = 4,
        SUB       = 4,
        JMP       = 10,
        JZ        = 10,
        JNZ       = 10,
        JC        = 10,
        JNC       = 10,
        CALL      = 17,
        RET       = 10,
        PUSH      = 11,
        POP       = 10,
        INC       = 4,
        DEC       = 4,
        AND       = 4,
        OR        = 4,
        XOR       = 4,
        NOT       = 4,
        CMP       = 4,
        LDA_M     = 13,
        STA_M     = 13,
        LDB_M     = 13,
        STB_M     = 13,
        LDHL      = 10,
        LDDE      = 10,
        LDIX      = 14,
        LDIY      = 14,
        LDSP      = 10,
        LDPC      = 10,
        LDHL_M    = 16,
        LDDE_M    = 16,
        LDIX_M    = 20,
        LDIY_M    = 20,
        LDSP_M    = 20,
        STHL_M    = 16,
        STDE_M    = 16,
        STIX_M    = 20,
        STIY_M    = 20,
        STSP_M    = 20,
        LDA_B     = 4,
        LDB_A     = 4,
        LDA_C     = 4,
        LDA_D     = 4,
        LDA_E     = 4,
        LDA_H     = 4,
        LDA_L     = 4,
        LDB_C     = 4,
        LDB_D     = 4,
        LDB_E     = 4,
        LDB_H     = 4,
        LDB_L     = 4,
        LDC_A     = 4,
        LDC_B     = 4,
        LDD_A     = 4,
        LDD_B     = 4,
        LDE_A     = 4,
        LDE_B     = 4,
        LDH_A     = 4,
        LDH_B     = 4,
        LDL_A     = 4,
        LDL_B     = 4,
        LDHL_DE   = 6,
        LDDE_HL   = 6,
        LDHL_IX   = 6,
        LDIX_HL   = 6,
        LDHL_IY   = 6,
        LDIY_HL   = 6,
        LDDE_IX   = 6,
        LDIX_DE   = 6,
        LDDE_IY   = 6,
        LDIY_DE   = 6,
        LDA_HL    = 7,
        LDB_HL    = 7,
        LDC_HL    = 7,
        LDD_HL    = 7,
        LDE_HL    = 7,
        LDH_HL    = 7,
        LDL_HL    = 7,
        STA_HL    = 7,
        STB_HL    = 7,
        LDA_DE    = 7,
        LDB_DE    = 7,
        STA_DE    = 7,
        STB_DE    = 7,
        LDA_IX    = 7,
        LDB_IX    = 7,
        STA_IX    = 7,
        STB_IX    = 7,
        LDA_IY    = 7,
        LDB_IY    = 7,
        STA_IY    = 7,
        STB_IY    = 7,
        INC_HL    = 6,
        DEC_HL    = 6,
        INC_DE    = 6,
        DEC_DE    = 6,
        INC_IX    = 6,
        DEC_IX    = 6,
        INC_IY    = 6,
        DEC_IY    = 6,
        INC_SP    = 6,
        DEC_SP    = 6,
        ADD_HL_DE = 8,
        ADD_HL_IX = 8,
        ADD_HL_IY = 8,
        SUB_HL_DE = 8,
        SUB_HL_IX = 8,
        SUB_HL_IY = 8,
        AND_HL_DE = 8,
        OR_HL_DE  = 8,
        XOR_HL_DE = 8,
        NOT_HL    = 8,
        NOT_DE    = 8,
        SHL_HL    = 8,
        SHR_HL    = 8,
        SHL_DE    = 8,
        SHR_DE    = 8,
    }
    local cycles = instructionCycles[instruction]

    if not cycles then
        Logger.raise("Cycles inconnus pour l'instruction : " .. instruction)
    end

    self.cycles               = self.cycles + cycles
    self.instructionsExecuted = self.instructionsExecuted + 1

    if instruction == "NOP" then
        -- Ne rien faire
    elseif instruction == "HALT" then
        self.running = false
        self.paused = false
        self.halted = true
    elseif instruction == "LDA" then
        local value = self:fetch()
        self:setRegister("A", value)
    elseif instruction == "LDB" then
        local value = self:fetch()
        self:setRegister("B", value)
    elseif instruction == "ADD" then
        local result = self.A + self.B
        local result8 = result % 256

        self.flags.C = result > 255
        self.flags.Z = result8 == 0
        self.flags.S = result8 >= 128
        self:updateParity(result8)
        self:setRegister("A", result8)
    elseif instruction == "SUB" then
        local result = self.A - self.B
        self.flags.C = result < 0
        self.flags.Z = (result % 256) == 0
        self.flags.S = (result % 256) >= 128
        self:updateParity(result % 256)
        self:setRegister("A", result % 256)
    elseif instruction == "JMP" then
        local address = self:fetch()
        local high = self:fetch()
        address = address + (high * 256)
        self:setRegister16("PC", address)
    elseif instruction == "JZ" then
        local low = self:fetch()
        local high = self:fetch()

        if self.flags.Z then
            local address = low + (high * 256)
            self:setRegister16("PC", address)
        end
    elseif instruction == "JNZ" then
        local low = self:fetch()
        local high = self:fetch()

        if not self.flags.Z then
            local address = low + (high * 256)
            self:setRegister16("PC", address)
        end
    elseif instruction == "JC" then
        local low = self:fetch()
        local high = self:fetch()

        if self.flags.C then
            local address = low + (high * 256)
            self:setRegister16("PC", address)
        end
    elseif instruction == "JNC" then
        local low = self:fetch()
        local high = self:fetch()

        if not self.flags.C then
            local address = low + (high * 256)
            self:setRegister16("PC", address)
        end
    elseif instruction == "CALL" then
        local low = self:fetch()
        local high = self:fetch()

        local returnAddress = self.PC

        self:push16(returnAddress)

        local address = low + (high * 256)
        self:setRegister16("PC", address)
    elseif instruction == "RET" then
        local returnAddress = self:pop16()
        self:setRegister16("PC", returnAddress)
    elseif instruction == "PUSH" then
        local registerCode = self:fetch()

        local register = REGISTER_NAMES[registerCode]

        if not register then
            Logger.raise("Registre invalide pour PUSH")
        end

        local value = self:getRegister(register)

        self.SP = self.SP - 1
        self.memory:write(self.SP, value)
    elseif instruction == "POP" then
        local registerCode = self:fetch()
        local register = REGISTER_NAMES[registerCode]
        if not register then
            Logger.raise("Registre invalide pour POP")
        end

        local value = self.memory:read(self.SP)
        self.SP = self.SP + 1

        self:setRegister(register, value)
    elseif instruction == "INC" then
        local registerCode = self:fetch()

        local register = REGISTER_NAMES[registerCode]

        if not register then
            Logger.raise("Registre invalide pour INC")
        end

        local result = self:getRegister(register) + 1

        self.flags.Z = (result % 256) == 0
        self.flags.S = (result % 256) >= 128
        self:updateParity(result % 256)

        self:setRegister(register, result % 256)
    elseif instruction == "DEC" then
        local registerCode = self:fetch()

        local register = REGISTER_NAMES[registerCode]

        if not register then
            Logger.raise("Registre invalide pour DEC")
        end

        local result = self:getRegister(register) - 1

        self.flags.Z = (result % 256) == 0
        self.flags.S = (result % 256) >= 128
        self:updateParity(result % 256)

        self:setRegister(register, result % 256)
    elseif instruction == "AND" then
        local result = bit.band(self.A, self.B)

        self.flags.C = false
        self.flags.Z = result == 0
        self.flags.S = result >= 128
        self:updateParity(result)

        self:setRegister("A", result)
    elseif instruction == "OR" then
        local result = bit.bor(self.A, self.B)

        self.flags.C = false
        self.flags.Z = result == 0
        self.flags.S = result >= 128
        self:updateParity(result)

        self:setRegister("A", result)
    elseif instruction == "XOR" then
        local result = bit.bxor(self.A, self.B)

        self.flags.C = false
        self.flags.Z = result == 0
        self.flags.S = result >= 128
        self:updateParity(result)

        self:setRegister("A", result)
    elseif instruction == "NOT" then
        local result = bit.band(bit.bnot(self.A), 0xFF)

        self.flags.C = false
        self.flags.Z = result == 0
        self.flags.S = result >= 128
        self:updateParity(result)

        self:setRegister("A", result)
    elseif instruction == "CMP" then
        local result = self.A - self.B
        local result8 = result % 256

        self.flags.C = result < 0
        self.flags.Z = result8 == 0
        self.flags.S = result8 >= 128
        self:updateParity(result8)
    elseif instruction == "LDA_M" then
        local low = self:fetch()
        local high = self:fetch()

        local address = low + high * 256
        local value = self.memory:read(address)

        self:setRegister("A", value)
    elseif instruction == "STA_M" then
        local low = self:fetch()
        local high = self:fetch()

        local address = low + high * 256

        self.memory:write(address, self.A)
    elseif instruction == "LDB_M" then
        local low = self:fetch()
        local high = self:fetch()

        local address = low + high * 256
        local value = self.memory:read(address)

        self:setRegister("B", value)
    elseif instruction == "STB_M" then
        local low = self:fetch()
        local high = self:fetch()

        local address = low + high * 256

        self.memory:write(address, self.B)
    elseif instruction == "LDHL" then
        local low = self:fetch()
        local high = self:fetch()

        local value = low + high * 256

        self:setRegister16("HL", value)
    elseif instruction == "LDDE" then
        local low = self:fetch()
        local high = self:fetch()

        local value = low + high * 256

        self:setRegister16("DE", value)
    elseif instruction == "LDIX" then
        local low = self:fetch()
        local high = self:fetch()

        local value = low + high * 256

        self:setRegister16("IX", value)
    elseif instruction == "LDIY" then
        local low = self:fetch()
        local high = self:fetch()

        local value = high * 256 + low

        self:setRegister16("IY", value)
    elseif instruction == "LDSP" then
        local low = self:fetch()
        local high = self:fetch()

        local value = high * 256 + low

        self:setRegister16("SP", value)
    elseif instruction == "LDPC" then
        local low = self:fetch()
        local high = self:fetch()

        local value = high * 256 + low

        self:setRegister16("PC", value)
    elseif instruction == "LDHL_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.memory:read(address)
        local high = self.memory:read(address + 1)

        local value = high * 256 + low

        self:setRegister16("HL", value)
    elseif instruction == "LDDE_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.memory:read(address)
        local high = self.memory:read(address + 1)

        local value = high * 256 + low

        self:setRegister16("DE", value)
    elseif instruction == "LDIX_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.memory:read(address)
        local high = self.memory:read(address + 1)

        local value = high * 256 + low

        self:setRegister16("IX", value)
    elseif instruction == "LDIY_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.memory:read(address)
        local high = self.memory:read(address + 1)

        local value = high * 256 + low

        self:setRegister16("IY", value)
    elseif instruction == "LDSP_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.memory:read(address)
        local high = self.memory:read(address + 1)

        local value = high * 256 + low

        self:setRegister16("SP", value)
    elseif instruction == "STHL_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        self.memory:write(address, self.L)
        self.memory:write(address + 1, self.H)
    elseif instruction == "STDE_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        self.memory:write(address, self.E)
        self.memory:write(address + 1, self.D)
    elseif instruction == "STIX_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.IX % 256
        local high = math.floor(self.IX / 256)

        self.memory:write(address, low)
        self.memory:write(address + 1, high)
    elseif instruction == "STIY_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.IY % 256
        local high = math.floor(self.IY / 256)

        self.memory:write(address, low)
        self.memory:write(address + 1, high)
    elseif instruction == "STSP_M" then
        local lowAddress = self:fetch()
        local highAddress = self:fetch()

        local address = highAddress * 256 + lowAddress

        local low = self.SP % 256
        local high = math.floor(self.SP / 256)

        self.memory:write(address, low)
        self.memory:write(address + 1, high)
    elseif instruction == "LDA_B" then
        self.A = self.B
    elseif instruction == "LDB_A" then
        self.B = self.A
    elseif instruction == "LDA_C" then
        self.A = self.C
    elseif instruction == "LDA_D" then
        self.A = self.D
    elseif instruction == "LDA_E" then
        self.A = self.E
    elseif instruction == "LDA_H" then
        self.A = self.H
    elseif instruction == "LDA_L" then
        self.A = self.L
    elseif instruction == "LDB_C" then
        self.B = self.C
    elseif instruction == "LDB_D" then
        self.B = self.D
    elseif instruction == "LDB_E" then
        self.B = self.E
    elseif instruction == "LDB_H" then
        self.B = self.H
    elseif instruction == "LDB_L" then
        self.B = self.L
    elseif instruction == "LDC_A" then
        self.C = self.A
    elseif instruction == "LDC_B" then
        self.C = self.B
    elseif instruction == "LDD_A" then
        self.D = self.A
    elseif instruction == "LDD_B" then
        self.D = self.B
    elseif instruction == "LDE_A" then
        self.E = self.A
    elseif instruction == "LDE_B" then
        self.E = self.B
    elseif instruction == "LDH_A" then
        self.H = self.A
    elseif instruction == "LDH_B" then
        self.H = self.B
    elseif instruction == "LDL_A" then
        self.L = self.A
    elseif instruction == "LDL_B" then
        self.L = self.B
        -- Transferts entre registres 16 bits
    elseif instruction == "LDHL_DE" then
        self:setRegister16("HL", self:getRegister16("DE"))
    elseif instruction == "LDDE_HL" then
        self:setRegister16("DE", self:getRegister16("HL"))
    elseif instruction == "LDHL_IX" then
        self:setRegister16("HL", self.IX)
    elseif instruction == "LDIX_HL" then
        self.IX = self:getRegister16("HL")
    elseif instruction == "LDHL_IY" then
        self:setRegister16("HL", self.IY)
    elseif instruction == "LDIY_HL" then
        self.IY = self:getRegister16("HL")
    elseif instruction == "LDDE_IX" then
        self:setRegister16("DE", self.IX)
    elseif instruction == "LDIX_DE" then
        self.IX = self:getRegister16("DE")
    elseif instruction == "LDDE_IY" then
        self:setRegister16("DE", self.IY)
    elseif instruction == "LDIY_DE" then
        self.IY = self:getRegister16("DE")
        -- Chargement indirect via HL
    elseif instruction == "LDA_HL" then
        self.A = self.memory:read(self:getRegister16("HL"))
    elseif instruction == "LDB_HL" then
        self.B = self.memory:read(self:getRegister16("HL"))
    elseif instruction == "LDC_HL" then
        self.C = self.memory:read(self:getRegister16("HL"))
    elseif instruction == "LDD_HL" then
        self.D = self.memory:read(self:getRegister16("HL"))
    elseif instruction == "LDE_HL" then
        self.E = self.memory:read(self:getRegister16("HL"))
    elseif instruction == "LDH_HL" then
        self.H = self.memory:read(self:getRegister16("HL"))
    elseif instruction == "LDL_HL" then
        self.L = self.memory:read(self:getRegister16("HL"))

        -- Écriture indirecte via HL
    elseif instruction == "STA_HL" then
        self.memory:write(self:getRegister16("HL"), self.A)
    elseif instruction == "STB_HL" then
        self.memory:write(self:getRegister16("HL"), self.B)
        -- Accès mémoire indirect via DE
    elseif instruction == "LDA_DE" then
        self.A = self.memory:read(self:getRegister16("DE"))
    elseif instruction == "LDB_DE" then
        self.B = self.memory:read(self:getRegister16("DE"))
    elseif instruction == "STA_DE" then
        self.memory:write(self:getRegister16("DE"), self.A)
    elseif instruction == "STB_DE" then
        self.memory:write(self:getRegister16("DE"), self.B)

        -- Accès mémoire indirect via IX
    elseif instruction == "LDA_IX" then
        self.A = self.memory:read(self.IX)
    elseif instruction == "LDB_IX" then
        self.B = self.memory:read(self.IX)
    elseif instruction == "STA_IX" then
        self.memory:write(self.IX, self.A)
    elseif instruction == "STB_IX" then
        self.memory:write(self.IX, self.B)

        -- Accès mémoire indirect via IY
    elseif instruction == "LDA_IY" then
        self.A = self.memory:read(self.IY)
    elseif instruction == "LDB_IY" then
        self.B = self.memory:read(self.IY)
    elseif instruction == "STA_IY" then
        self.memory:write(self.IY, self.A)
    elseif instruction == "STB_IY" then
        self.memory:write(self.IY, self.B)
        -- Incrémentation / décrémentation 16 bits
    elseif instruction == "INC_HL" then
        self:setRegister16("HL", (self:getRegister16("HL") + 1) % 65536)
    elseif instruction == "DEC_HL" then
        self:setRegister16("HL", (self:getRegister16("HL") - 1) % 65536)
    elseif instruction == "INC_DE" then
        self:setRegister16("DE", (self:getRegister16("DE") + 1) % 65536)
    elseif instruction == "DEC_DE" then
        self:setRegister16("DE", (self:getRegister16("DE") - 1) % 65536)
    elseif instruction == "INC_IX" then
        self.IX = (self.IX + 1) % 65536
    elseif instruction == "DEC_IX" then
        self.IX = (self.IX - 1) % 65536
    elseif instruction == "INC_IY" then
        self.IY = (self.IY + 1) % 65536
    elseif instruction == "DEC_IY" then
        self.IY = (self.IY - 1) % 65536
    elseif instruction == "INC_SP" then
        self.SP = (self.SP + 1) % 65536
    elseif instruction == "DEC_SP" then
        self.SP = (self.SP - 1) % 65536
        -- Arithmétique 16 bits
    elseif instruction == "ADD_HL_DE"
        or instruction == "ADD_HL_IX"
        or instruction == "ADD_HL_IY" then
        local source

        if instruction == "ADD_HL_DE" then
            source = self:getRegister16("DE")
        elseif instruction == "ADD_HL_IX" then
            source = self.IX
        else
            source = self.IY
        end

        local result = self:getRegister16("HL") + source
        local result16 = result % 65536

        self.flags.C = result > 65535
        self.flags.Z = result16 == 0
        self.flags.S = result16 >= 32768
        self:updateParity16(result16)

        self:setRegister16("HL", result16)
    elseif instruction == "SUB_HL_DE"
        or instruction == "SUB_HL_IX"
        or instruction == "SUB_HL_IY" then
        local source

        if instruction == "SUB_HL_DE" then
            source = self:getRegister16("DE")
        elseif instruction == "SUB_HL_IX" then
            source = self.IX
        else
            source = self.IY
        end

        local result = self:getRegister16("HL") - source
        local result16 = result % 65536

        self.flags.C = result < 0
        self.flags.Z = result16 == 0
        self.flags.S = result16 >= 32768
        self:updateParity16(result16)

        self:setRegister16("HL", result16)
    elseif instruction == "AND_HL_DE"
        or instruction == "OR_HL_DE"
        or instruction == "XOR_HL_DE" then
        local hl = self:getRegister16("HL")
        local de = self:getRegister16("DE")

        -- Séparation des octets
        local hlHigh = math.floor(hl / 256)
        local hlLow = hl % 256

        local deHigh = math.floor(de / 256)
        local deLow = de % 256

        local resultHigh
        local resultLow

        if instruction == "AND_HL_DE" then
            resultHigh = bit.band(hlHigh, deHigh)
            resultLow = bit.band(hlLow, deLow)
        elseif instruction == "OR_HL_DE" then
            resultHigh = bit.bor(hlHigh, deHigh)
            resultLow = bit.bor(hlLow, deLow)
        else
            resultHigh = bit.bxor(hlHigh, deHigh)
            resultLow = bit.bxor(hlLow, deLow)
        end

        local result = resultHigh * 256 + resultLow

        self:setRegister16("HL", result)

        self.flags.C = false
        self.flags.Z = result == 0
        self.flags.S = result >= 32768

        self:updateParity16(result)
    elseif instruction == "NOT_HL" or instruction == "NOT_DE" then
        local registerName = instruction == "NOT_HL" and "HL" or "DE"
        local value = self:getRegister16(registerName)

        -- Inversion des 16 bits
        local high = math.floor(value / 256)
        local low = value % 256

        high = bit.band(bit.bnot(high), 0xFF)
        low = bit.band(bit.bnot(low), 0xFF)

        local result = high * 256 + low

        self:setRegister16(registerName, result)

        self.flags.C = false
        self.flags.Z = result == 0
        self.flags.S = result >= 32768

        self:updateParity16(result)
    elseif instruction == "SHL_HL"
        or instruction == "SHR_HL"
        or instruction == "SHL_DE"
        or instruction == "SHR_DE" then
        local registerName

        if instruction == "SHL_HL" or instruction == "SHR_HL" then
            registerName = "HL"
        else
            registerName = "DE"
        end

        local value = self:getRegister16(registerName)
        local result

        if instruction == "SHL_HL" or instruction == "SHL_DE" then
            -- Le bit 15 part dans Carry
            self.flags.C = value >= 32768
            result = (value * 2) % 65536
        else
            -- Le bit 0 part dans Carry
            self.flags.C = value % 2 == 1
            result = math.floor(value / 2)
        end

        self:setRegister16(registerName, result)

        self.flags.Z = result == 0
        self.flags.S = result >= 32768

        self:updateParity16(result)
    end
end

function CPU:step()
    if not self.running then
        return
    end

    local opcode = self:fetch()
    local instruction = self:decode(opcode)

    self:execute(instruction)
end

function CPU:run(maxInstructions)
    if self.halted then
        return
    end
    if not self.paused then
        self:start()
    else
        self.running = true
        self.paused = false
    end

    local instructionCount = 0

    while self.running do
        if maxInstructions and instructionCount >= maxInstructions then
            break
        end

        self:step()
        instructionCount = instructionCount + 1
    end
end

function CPU:dump()
    print("========== CPU ==========")

    print("Registers:")
    print("A:", self.A, "B:", self.B)
    print("C:", self.C, "D:", self.D)
    print("E:", self.E, "H:", self.H)
    print("L:", self.L, "F:", self.F)
    print("HL:", self.H * 256 + self.L)
    print("DE:", self.D * 256 + self.E)

    print(string.format("HL: 0x%04X", self.H * 256 + self.L))
    print(string.format("DE: 0x%04X", self.D * 256 + self.E))

    print(string.format("PC: 0x%04X", self.PC))
    print(string.format("SP: 0x%04X", self.SP))
    print(string.format("IX: 0x%04X", self.IX))
    print(string.format("IY: 0x%04X", self.IY))

    print("Flags:")
    print("Z:", self.flags.Z)
    print("S:", self.flags.S)
    print("C:", self.flags.C)
    print("P:", self.flags.P)

    print("State:")
    print("Running:", self.running)
    print("Paused:", self.paused)
    print("Halted:", self.halted)

    print("Instructions:", self.instructionsExecuted)
    print("Cycles:", self.cycles)

    print("=========================")
end

function CPU:pause()
    self.running = false
    self.paused  = true
end

--- Empile une valeur de 16 bits
---@param value integer
function CPU:push16(value)
    self.SP = self.SP - 1
    self.memory:write(self.SP, math.floor(value / 256))

    self.SP = self.SP - 1
    self.memory:write(self.SP, value % 256)
end

--- Dépile une valeur de 16 bits
---@return integer
function CPU:pop16()
    local low = self.memory:read(self.SP)
    self.SP = self.SP + 1

    local high = self.memory:read(self.SP)
    self.SP = self.SP + 1

    return low + (high * 256)
end

---comment
---@param name "A"|"B"|"C"|"D"|"E"|"H"|"L"|"F"
---@param value integer  @`>=0` and `<=255`
function CPU:setRegister(name, value)
    Logger.assert(value >= 0 and value <= 255,
        "Valeur de registre invalide")

    self[name] = value
end

---comment
---@param name "A"|"B"|"C"|"D"|"E"|"H"|"L"|"F"
---@return integer
function CPU:getRegister(name)
    return self[name]
end

---@param name "PC"|"SP"|"IX"|"IY"|"HL"|"DE"
---@param value integer  @`>=0` and `<=65535`
function CPU:setRegister16(name, value)
    Logger.assert(value >= 0 and value <= 65535,
        "Valeur de registre 16 bits invalide")

    if name == "HL" then
        self.H = math.floor(value / 256)
        self.L = value % 256
    elseif name == "DE" then
        self.D = math.floor(value / 256)
        self.E = value % 256
    else
        self[name] = value
    end
end

---comment
---@param name "PC"|"SP"|"IX"|"IY"|"HL"|"DE"
---@return integer
function CPU:getRegister16(name)
    if name == "HL" then
        return self.H * 256 + self.L
    elseif name == "DE" then
        return self.D * 256 + self.E
    else
        return self[name]
    end
end

return CPU
