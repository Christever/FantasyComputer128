local PaletteDemo = {}

function PaletteDemo.draw()
    f_cls(0)

    f_print("PALETTE DEMO", 105, 10, 7)

    f_print("COLOR PALETTE", 20, 35, 6)

    -- Affichage des 16 premieres couleurs
    for i = 0, 15 do
        local x = 20 + (i % 8) * 36
        local y = 55 + math.floor(i / 8) * 45

        f_rect_fill(x, y, 28, 28, i)
        f_print(tostring(i), x + 10, y + 32, 7)
    end
end

return PaletteDemo