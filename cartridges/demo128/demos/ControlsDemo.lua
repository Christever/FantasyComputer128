local ControlsDemo = {}

function ControlsDemo.draw()
    f_cls(0)

    f_print("CONTROLS DEMO", 108, 8, 7)
    f_line(10, 22, 310, 22, 5)

    -- Clavier
    f_print("KEYBOARD", 16, 34, 4)
    f_print("RETURN  : SELECT", 16, 50, 7)
    f_print("SPACE   : START", 16, 62, 7)
    f_print("X       : BUTTON A", 16, 74, 7)
    f_print("C       : BUTTON B", 16, 86, 7)

    -- Gamepad
    f_print("GAMEPAD SUPPORT", 16, 100, 4)
    f_print("A      : BUTTON A", 16, 116, 7)
    f_print("B      : BUTTON B", 16, 128, 7)
    f_print("START  : START", 16, 140, 7)
    f_print("SELECT : SELECT", 16, 152, 7)

    f_line(165, 30, 165, 170, 15)

    -- Navigation
    f_print("NAVIGATION", 176, 34, 4)
    f_print("UP / DOWN : MENU", 176, 50, 7)
    f_print("START     : OK", 176, 62, 7)
    f_print("B         : BACK", 176, 74, 7)

    f_print("GAMEPAD", 176, 100, 4)

    if f_joystickCount() > 0 then
        f_print("GAMEPAD DETECTED", 176, 116, 5)
    else
        f_print("NO GAMEPAD DETECTED", 176, 116, 2)
    end
    f_print("CONNECTED : " .. f_joystickCount(), 176, 132, 7)
    if f_joystickCount() > 0 then
        f_print(f_joystickName(1), 176, 144, 7)
    end

    f_line(10, 180, 310, 180, 5)
    f_print("FANTASY COMPUTER 128", 88, 190, 7)
end

return ControlsDemo
