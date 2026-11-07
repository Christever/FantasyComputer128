local animationTimer = 0
local currentFrame = 1
local SpritesDemo = {}

local player

function SpritesDemo.createPlayer()
    player = f_sprite(16, 16, -1)

    if not player then
        print("ERREUR : f_sprite ne retourne rien")
        return
    end

    print("Sprite cree : " .. player.width .. "x" .. player.height)

    -- Chapeau
    for x = 5, 12 do
        f_spr_pixel(player, x, 2, 4)
    end

    -- Tete
    for y = 3, 8 do
        for x = 4, 13 do
            f_spr_pixel(player, x, y, 7)
        end
    end

    -- Yeux
    f_spr_pixel(player, 6, 5, 0)
    f_spr_pixel(player, 11, 5, 0)

    -- Corps
    for y = 9, 13 do
        for x = 5, 12 do
            f_spr_pixel(player, x, y, 3)
        end
    end

    -- Jambes
    for x = 5, 7 do
        f_spr_pixel(player, x, 14, 4)
    end

    for x = 10, 12 do
        f_spr_pixel(player, x, 14, 4)
    end
end

function SpritesDemo.update(dt)
    animationTimer = animationTimer + dt

    if animationTimer >= 0.25 then
        animationTimer = 0
        currentFrame = currentFrame == 1 and 2 or 1

        -- Efface les anciennes positions des jambes.
        for y = 14, 15 do
            for x = 5, 12 do
                f_spr_pixel(player, x, y, -1)
            end
        end

        -- Dessine les jambes selon l'image actuelle.
        if currentFrame == 1 then
            for x = 5, 7 do
                f_spr_pixel(player, x, 14, 4)
            end

            for x = 10, 12 do
                f_spr_pixel(player, x, 14, 4)
            end
        else
            for x = 5, 7 do
                f_spr_pixel(player, x, 15, 4)
            end

            for x = 10, 12 do
                f_spr_pixel(player, x, 14, 4)
            end
        end
    end
end

function SpritesDemo.draw()
    f_cls(0)

    f_print("SPRITES DEMO", 105, 10, 7)

    if player then
        print("Player :", player)
        print("Largeur :", player and player.width)
        f_spr(player, 152, 80)
        f_spr(player, 152, 80)
    end
end

return SpritesDemo
