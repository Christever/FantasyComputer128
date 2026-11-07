local Screens       = require("cartridges.screens")
local Config        = require("cartridges.config")
local Menu          = require("cartridges.menu")

local SCREEN_WIDTH  = Config.SCREEN_WIDTH
local SCREEN_HEIGHT = Config.SCREEN_HEIGHT
local CENTER_X      = SCREEN_WIDTH / 2
local CENTER_Y      = SCREEN_HEIGHT / 2

local elapsed       = 0
local logoAnimation
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

    if currentScreen == "title" then
        Screens.drawTitleScreen(logoAnimation, elapsed)
    elseif currentScreen == "menu" then
        Menu.update()
        Screens.drawMenuScreen(Menu.selection)
    end
end
