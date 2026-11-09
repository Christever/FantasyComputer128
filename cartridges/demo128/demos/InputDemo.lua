local InputDemo = {}

function InputDemo.draw()

    f_cls(0)

    -- Titre
    f_print("INPUT DEMO", 120, 8, 7)
    f_line(10, 22, 310, 22, 5)

    -- Colonne gauche : Digital Input
    f_print("DIGITAL INPUT", 20, 34, 4)

    -- Croix directionnelle
    local up    = f_btn("UP")
    local down  = f_btn("DOWN")
    local left  = f_btn("LEFT")
    local right = f_btn("RIGHT")

    f_print("UP", 72, 52, up and 11 or 5)
    f_print("LEFT", 27, 68, left and 11 or 5)
    f_print("DOWN", 72, 68, down and 11 or 5)
    f_print("RIGHT", 117, 68, right and 11 or 5)

    -- Boutons
    local a = f_btn("A")

    f_print("A", 35, 96, a and 11 or 5)
    f_print("B", 85, 96, 5)
    f_print("START", 25, 116, f_btn("START") and 11 or 5)
    f_print("SELECT", 85, 116, f_btn("SELECT") and 11 or 5)

    -- Séparateur vertical
    f_line(165, 30, 165, 165, 5)

    -- Colonne droite : Input Events
    f_print("INPUT EVENTS", 180, 34, 4)

    f_print("PRESSED  : --", 180, 55, 5)
    f_print("HELD     : --", 180, 70, 5)
    f_print("RELEASED : --", 180, 85, 5)

    -- Analog Input
    f_line(10, 145, 310, 145, 5)
    f_print("ANALOG INPUT", 20, 153, 4)

    f_print("AXIS X : 0.00", 180, 153, 5)
    f_print("AXIS Y : 0.00", 180, 165, 5)

    -- Pied de page
    f_line(10, 180, 310, 180, 5)
    f_print("FANTASY COMPUTER 128", 88, 190, 7)

end

return InputDemo
