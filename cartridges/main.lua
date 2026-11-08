local cartridges = f_get_cartridges()
local selection = 1
local elapsed = 0

local MAX_VISIBLE_CARTRIDGES = 4
local firstVisible = 1

local titleSheet
local titleAnimation

function BOOT()
    selection = 1
    firstVisible = 1
    elapsed = 0

    titleSheet = f_spritesheet("cartridges/assets/title.png", 16, 16)
    titleAnimation = f_animation(titleSheet, { 1, 2 }, 2, "loop")
end

function FAN128(dt)
    f_cls(0)
    elapsed = elapsed + dt

    f_rect(15, 85, 70, 60, 15)
    f_spr(titleAnimation, 40, 100)
    f_print("FAN128", 25, 125, 3)

    -- Cadre
    f_rect(4, 4, 312, 192, 1)

    -- Titre
    f_print("FANTASY COMPUTER 128", 85, 25, 7)
    f_print("CARTRIDGE SELECT", 105, 50, 6)

    -- Liste des cartouches
    for i = firstVisible, math.min(firstVisible + MAX_VISIBLE_CARTRIDGES - 1, #cartridges) do
        local cartridge = cartridges[i]
        local y = 85 + (i - firstVisible) * 18

        if i == selection then
            f_print(">", 95, y, 5)
            f_print(cartridge.name, 110, y, 5)
        else
            f_print(cartridge.name, 110, y, 7)
        end
    end

    -- Navigation
    if f_btnp("UP") then
        selection = selection - 1
    end

    if f_btnp("DOWN") then
        selection = selection + 1
    end

    -- Boucle de sélection
    if selection < 1 then
        selection = #cartridges
    end

    if selection > #cartridges then
        selection = 1
    end

    if selection < firstVisible then
        firstVisible = selection
    elseif selection >= firstVisible + MAX_VISIBLE_CARTRIDGES then
        firstVisible = selection - MAX_VISIBLE_CARTRIDGES + 1
    end

    if math.floor(elapsed * 2) % 2 == 0 then
        f_print("PRESS START", 90, 165, 3)
    end

    -- Validation
    if f_btnp("START") then
        f_load_cartridge(cartridges[selection].path)
    end
end
