local Screens       = require("cartridges.demo128.screens")
local Config        = require("cartridges.demo128.config")
local Menu          = require("cartridges.demo128.menu")
local GraphicsDemo  = require("cartridges.demo128.demos.GraphicsDemo")
local PaletteDemo   = require("cartridges.demo128.demos.PaletteDemo")
local SpritesDemo   = require("cartridges.demo128.demos.SpritesDemo")

local SCREEN_WIDTH  = Config.SCREEN_WIDTH
local SCREEN_HEIGHT = Config.SCREEN_HEIGHT
local CENTER_X      = SCREEN_WIDTH / 2
local CENTER_Y      = SCREEN_HEIGHT / 2

local elapsed       = 0
local logoAnimation
local currentScreen = "title"
local selectedItem  = nil


function BOOT()
    SpritesDemo.createPlayer()
end

function FAN128(dt)
    f_cls(0)

    elapsed = elapsed + dt

    if currentScreen == "title" then
        Screens.drawTitleScreen(logoAnimation, elapsed)

        if f_btnp("START") then
            currentScreen = "menu"
        end
    elseif currentScreen == "menu" then
        Menu.update()

        Screens.drawMenuScreen(Menu.selection)

        if f_btnp("START") then
            selectedItem = Menu.getSelectedItem()
            currentScreen = "demo"
        end
    elseif currentScreen == "demo" then
        if selectedItem == "GRAPHICS" then
            GraphicsDemo.draw()
        elseif selectedItem == "PALETTE" then
            PaletteDemo.draw()
        elseif selectedItem == "SPRITES" then
            SpritesDemo.update(dt)
            SpritesDemo.draw()
        else
            f_print("DEMO : " .. selectedItem, 100, 90, 7)
        end
        if f_btnp("B") then
            currentScreen = "menu"
        end
    end
end
