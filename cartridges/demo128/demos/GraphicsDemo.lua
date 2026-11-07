local GraphicsDemo = {}

function GraphicsDemo.draw()

    f_cls(0)

    -- Titre
    f_print("GRAPHICS DEMO", 105, 10, 7)

    -- Pixels
    f_print("PIXELS", 20, 35, 6)

    f_pixel(30, 55, 7)
    f_pixel(35, 55, 8)
    f_pixel(40, 55, 9)
    f_pixel(45, 55, 10)

    -- Lignes
    f_print("LINES", 100, 35, 6)

    f_line(100, 55, 150, 55, 2)
    f_line(100, 65, 150, 85, 3)
    f_line(100, 85, 150, 65, 4)

    -- Rectangles
    f_print("RECTANGLES", 200, 35, 6)

    f_rect(205, 50, 35, 25, 7)
    f_rect_fill(250, 50, 35, 25, 3)

    -- Cercles
    f_print("CIRCLES", 20, 105, 6)

    f_circle(40, 145, 18, 7)
    f_circle_fill(90, 145, 18, 2)

    -- Triangles
    f_print("TRIANGLES", 150, 105, 6)

    f_triangle(165, 165, 185, 125, 205, 165, 7)
    f_triangle_fill(225, 165, 245, 125, 265, 165, 3)

end

return GraphicsDemo