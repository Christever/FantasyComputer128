local CPU = require("system.cpu.CPU")
local CPUTest = {}


---comment
---@param cpu CPU
function CPUTest.run(cpu)
    print("=== TEST CPU ===")
print("Test SHR_DE :")

cpu:reset()

-- LDDE 0x8003
-- SHR_DE
-- HALT

local program = {
    0xA1, 0x03, 0x80,
    0xFD,
    0x01
}

for i, opcode in ipairs(program) do
    cpu.memory:write(0x4000 + i - 1, opcode)
end

cpu.PC = 0x4000
cpu:run(3)
cpu:dump()
end

return CPUTest
