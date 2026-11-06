function BOOT()
end

function FAN128()
    cls(0)

    print("TEST ANALOG STICK", 10, 10, 4)

    local x = axis(1, "leftx")
    local y = axis(1, "lefty")

    print("LEFT X : " .. string.format("%.2f", x), 10, 40, 2)
    print("LEFT Y : " .. string.format("%.2f", y), 10, 55, 2)

    print("DIRECTION X : " .. direction(1, "leftx"), 10, 85, 3)
    print("DIRECTION Y : " .. direction(1, "lefty"), 10, 100, 3)
end