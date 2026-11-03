local MemoryTest = {}

function MemoryTest.run(memory, Memory)
    print("=== TEST MEMOIRE ===")

    print("Espace CPU :", Memory.ADDRESS_SPACE / 1024, "Ko")

    print("Test RAM :")
    memory:write(0x4000, 65)
    print(memory:read(0x4000))

    print("Test VRAM :")
    memory:write(0x8000, 255)
    print(memory:read(0x8000))

    print("Test banque RAM :")
    memory:setRAMBank(1)
    memory:write(0xC000, 42)
    print(memory:read(0xC000))

    print("Test banque VRAM :")
    memory:setVRAMBank(1)
    memory:write(0x8000, 200)
    print(memory:read(0x8000))

    print("Test reset :")
    memory:reset()

    local banks = memory:getBankStatus()

    print("ROM :" .. banks.rom)
    print("RAM :" .. banks.ram)
    print("VRAM :" .. banks.vram)



    print("====================")
end

return MemoryTest
