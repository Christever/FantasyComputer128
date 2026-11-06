function FAN128()

    cls(0)

    local value = peek(0x4000)

    if value == 0 then
        poke(0x4000, 123)
        value = peek(0x4000)
    end

    print("RAM PERSISTENCE TEST", 10, 20, 1)
    print("RAM VALUE : " .. value, 10, 60, 7)

end
