function BOOT()
end

function FAN128()
    cls(0)

    print("TEST GAMEPAD", 10, 10, 4)

    if btn("LEFT") then
        print("LEFT : MAINTENUE", 10, 40, 2)
    end

    if btnp("A") then
        print("A : PRESSEE", 10, 60, 3)
    end

    if btnr("A") then
        print("A : RELACHEE", 10, 80, 5)
    end
end