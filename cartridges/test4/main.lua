local Config = require("cartridges.demo128.config")


local SCREEN_WIDTH  = Config.SCREEN_WIDTH
local SCREEN_HEIGHT = Config.SCREEN_HEIGHT
local CENTER_X      = SCREEN_WIDTH / 2
local CENTER_Y      = SCREEN_HEIGHT / 2

function BOOT()

end

function FAN128(dt)
    f_cls(0)
    f_print("Cartouche 4", 115, 100, 2)

    f_print("PRESS B TO RETURN", 90, 180, 3)

    if f_btnp("B") then
        f_load_cartridge("cartridges/main.lua")
        return
    end
end
