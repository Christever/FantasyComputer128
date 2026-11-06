local Config  = require("cartridges.config")
local Screens = {}

function Screens.drawTitleScreen(logoAnimation, elapsed)
    local centerX = Config.SCREEN_WIDTH / 2
    local centerY = Config.SCREEN_HEIGHT / 2

    f_cls(0)

    -- Cadre extérieur
    f_rect(4, 4, Config.SCREEN_WIDTH - 8, Config.SCREEN_HEIGHT - 8, 1)

    -- Ligne décorative
    f_line(20, centerY - 10, Config.SCREEN_WIDTH - 20, centerY - 10, 6)

    -- Petits éléments décoratifs
    f_pixel(12, 12, 7)
    f_pixel(Config.SCREEN_WIDTH - 13, 12, 7)
    f_pixel(12, Config.SCREEN_HEIGHT - 13, 7)
    f_pixel(Config.SCREEN_WIDTH - 13, Config.SCREEN_HEIGHT - 13, 7)

    -- Titre
    f_print("FANTASY COMPUTER 128", centerX - 70, centerY - 65, 1)

    -- Présentation
    f_print("8-BIT FANTASY COMPUTER", 72, 65, 7)

    -- Version
    f_print("DEMO CARTRIDGE V0.1", 95, 155, 6)

    -- Signature
    f_print("POWERED BY FAN128", 100, 180, 1)

    -- Animation du logo
    f_spr(logoAnimation, 150, 100)

    -- Animation des points
    local position = (elapsed * 30) % Config.ANIMATION_WIDTH
    local cycle = math.floor(elapsed * 30 / Config.ANIMATION_WIDTH)
    local color = (cycle % 15) + 1

    for i = 0, Config.ANIMATION_POINT_COUNT - 1 do
        local x = Config.ANIMATION_START_X
            + ((position + i * Config.ANIMATION_SPACING) % Config.ANIMATION_WIDTH)

        f_circle_fill(x, centerY + 30, 3, ((color + i - 1) % 15) + 1)
    end
end

function Screens.drawMenuScreen()
    f_cls(0)
    f_print("MENU PRINCIPAL", 110, 100, 7)
end

return Screens
