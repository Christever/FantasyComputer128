local InputDemo = {}

function InputDemo.draw()
    f_cls(0)

    f_print("INPUT DEMO", 120, 8, 7)
    f_line(10, 22, 310, 22, 5)

    -- Digital input
    f_print("DIGITAL INPUT", 16, 34, 4)
    -- Directions
    local up    = f_btn("UP")
    local down  = f_btn("DOWN")
    local left  = f_btn("LEFT")
    local right = f_btn("RIGHT")

    -- Affichage des directions
    f_print("UP", 65, 52, up and 5 or 11)
    f_print("LEFT", 25, 68, left and 5 or 11)
    f_print("DOWN", 65, 68, down and 5 or 11)
    f_print("RIGHT", 105, 68, right and 5 or 11)

    -- Boutons
    local a      = f_btn("A")

    -- Boutons système
    local start  = f_btn("START")
    local select = f_btn("SELECT")

    f_print("START", 20, 104, start and 5 or 11)
    f_print("SELECT", 100, 104, select and 5 or 11)
    f_print("BUTTON B : BACK", 100, 92, 11)

    f_print("BUTTON A", 20, 92, a and 5 or 11)


    -- Input events
    f_print("INPUT EVENTS", 176, 34, 4)

    -- Analog input
    f_print("ANALOG INPUT", 16, 110, 4)

    f_line(10, 180, 310, 180, 5)
    f_print("FANTASY COMPUTER 128", 88, 190, 7)
end

return InputDemo
