local Config        = require("cartridges.config")

local SCREEN_WIDTH  = Config.SCREEN_WIDTH
local SCREEN_HEIGHT = Config.SCREEN_HEIGHT
local CENTER_X      = SCREEN_WIDTH / 2
local CENTER_Y      = SCREEN_HEIGHT / 2

local elapsed       = 0
local position, logoAnimation
local currentScreen = "title"

function BOOT()
    logoAnimation = f_animation(
        f_spritesheet("assets/sprites/test.png", 16, 16),
        { 1, 2 },
        2,
        "loop"
    )
end

function FAN128(dt)
    -- Efface l'ecran avec un fond noir
    f_cls(0)

    if currentScreen == "title" and f_btnp("START") then
        currentScreen = "menu"
    end

    elapsed = elapsed + dt

    local cycle = math.floor(elapsed * 30 / Config.ANIMATION_WIDTH)
    position = (elapsed * 30) % Config.ANIMATION_WIDTH

    local color = (cycle % 15) + 1

    -- Cadre extérieur
    f_rect(4, 4, SCREEN_WIDTH - 8, SCREEN_HEIGHT - 8, 1)

    -- Ligne décorative
    f_line(20, CENTER_Y - 10, SCREEN_WIDTH - 20, CENTER_Y - 10, 6)

    -- Petits éléments décoratifs
    f_pixel(12, 12, 7)
    f_pixel(SCREEN_WIDTH - 13, 12, 7)
    f_pixel(12, SCREEN_HEIGHT - 13, 7)
    f_pixel(SCREEN_WIDTH - 13, SCREEN_HEIGHT - 13, 7)

    -- Titre
    f_print("FANTASY COMPUTER 128", CENTER_X - 70, CENTER_Y - 65, 1)

    -- Présentation
    f_print("8-BIT FANTASY COMPUTER", 72, 65, 7)

    -- Version
    f_print("DEMO CARTRIDGE V0.1", 95, 155, 6)

    -- Signature
    f_print("POWERED BY FAN128", 100, 180, 1)

    f_spr(logoAnimation, 150, 100)

    for i = 0, Config.ANIMATION_POINT_COUNT - 1 do
        local x = Config.ANIMATION_START_X + ((position + i * Config.ANIMATION_SPACING) % Config.ANIMATION_WIDTH)

        f_circle_fill(
            x,
            CENTER_Y + 30,
            3,
            ((color + i - 1) % 15) + 1
        )
    end
end
