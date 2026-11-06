function BOOT()
end

function FAN128()
    cls(0)

    print("TEST JOYSTICK", 10, 10, 4)

    local count = joystickCount()

    print("MANETTES : " .. count, 10, 40, 2)

    for i = 1, count do
        if joystickConnected(i) then
            print("MANETTE " .. i .. " : OK", 10, 60 + (i - 1) * 15, 3)
        end
    end

    if count == 0 then
        print("AUCUNE MANETTE", 10, 60, 2)
    end
end