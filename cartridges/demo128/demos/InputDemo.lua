local InputDemo = {}
local lastEvent = "NONE"

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

    f_print("UP", 72, 52, up and 5 or 11)
    f_print("LEFT", 27, 68, left and 5 or 11)
    f_print("DOWN", 72, 68, down and 5 or 11)
    f_print("RIGHT", 117, 68, right and 5 or 11)

    -- Boutons
    local a = f_btn("A")

    if f_btnp("A") then
        lastEvent = "PRESSED"
    elseif f_btnr("A") then
        lastEvent = "RELEASED"
    end

    f_print("A", 35, 96, a and 5 or 11)
    f_print("B", 85, 96, 5)
    f_print("START", 25, 116, f_btn("START") and 5 or 11)
    f_print("SELECT", 85, 116, f_btn("SELECT") and 5 or 11)

    -- Séparateur vertical
    f_line(165, 30, 165, 120, 5)

    -- Colonne droite : Input Events
    f_print("PRESSED  : " .. (lastEvent == "PRESSED" and "YES" or "--"), 180, 55, 11)
    f_print("HELD     : " .. (a and "YES" or "--"), 180, 70, a and 5 or 11)
    f_print("RELEASED : " .. (lastEvent == "RELEASED" and "YES" or "--"), 180, 85, 11)

    -- Analog Input
    f_line(10, 130, 310, 130, 5)
    f_print("ANALOG INPUT", 20, 138, 4)

    local axisX = 0
    local axisY = 0
    local directionX = 0
    local directionY = 0
    local joystickName = "NONE"
    local connected = false

    if f_joystickCount() > 0 then
        axisX = f_axis(1, "leftx")
        axisY = f_axis(1, "lefty")

        directionX = f_direction(1, "leftx")
        directionY = f_direction(1, "lefty")

        joystickName = f_joystickName(1)
        connected = f_joystickConnected(1)
    end

    local dirX = directionX == -1 and "LEFT"
        or directionX == 1 and "RIGHT"
        or "CENTER"

    local dirY = directionY == -1 and "UP"
        or directionY == 1 and "DOWN"
        or "CENTER"

    f_print("X : " .. string.format("%.2f", axisX), 20, 153, 5)
    f_print("Y : " .. string.format("%.2f", axisY), 20, 165, 5)

    f_print("DIR X : " .. dirX, 105, 153, 5)
    f_print("DIR Y : " .. dirY, 105, 165, 5)

    f_print("DEVICE : " .. joystickName, 20, 175, 5)
    f_print("CONNECTED : " .. (connected and "YES" or "NO"), 150, 138, 5)

    -- Pied de page
    f_line(10, 185, 310, 185, 5)
    f_print("FANTASY COMPUTER 128", 88, 190, 7)
end

return InputDemo
