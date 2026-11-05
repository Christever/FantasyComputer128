function BOOT()
    cls(4)
end

function FAN128()
    cls(0)
        -- Polygone vide
    polygone({
        { x = 40, y = 40 },
        { x = 100, y = 30 },
        { x = 120, y = 80 },
        { x = 70, y = 110 },
        { x = 30, y = 80 }
    }, 2)

    -- Polygone plein
    polygone_fill({
        { x = 160, y = 40 },
        { x = 220, y = 30 },
        { x = 240, y = 80 },
        { x = 190, y = 110 },
        { x = 150, y = 80 }
    }, 4)
end
