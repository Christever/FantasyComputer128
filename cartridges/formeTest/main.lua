function BOOT()
    f_cls(0)
end

function FAN128(dt)
    f_cls(0)

    -- Ellipse horizontale pleine
    f_ellipse_fill(80, 70, 50, 25, 2)

    -- Ellipse verticale pleine
    f_ellipse_fill(220, 70, 25, 50, 4)

    -- Ellipse partiellement hors ecran
    f_ellipse_fill(20, 160, 40, 30, 7)
end