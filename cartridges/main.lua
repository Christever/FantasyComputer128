local cartridges = f_get_cartridges()
local selection = 1

function BOOT()
    selection = 1
end

function FAN128(dt)
    f_cls(0)

    -- Cadre
    f_rect(4, 4, 312, 192, 1)

    -- Titre
    f_print("FANTASY COMPUTER 128", 85, 25, 7)
    f_print("CARTRIDGE SELECT", 105, 50, 6)

    -- Liste des cartouches
    for i, cartridge in ipairs(cartridges) do
        local y = 85 + (i - 1) * 18

        if i == selection then
            f_print(">", 95, y, 6)
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

    -- Validation
    if f_btnp("START") then
        f_load_cartridge(cartridges[selection].path)
    end
end