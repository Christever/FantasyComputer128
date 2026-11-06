local sheet
local knight
local dragon
local x

function BOOT()
    sheet = spritesheet("assets/sprites/test.png", 16, 16)

    knight = sheet:getSprite(1)
    dragon = sheet:getSprite(2)

    x=80
end

function FAN128()
    cls(0)
    spr(knight, 40, 80)
    spr(dragon, 80, 80)

    spr(sheet, 120, 80, true, true, 1)
    spr(sheet, 160, 80, true, false, 2)
end