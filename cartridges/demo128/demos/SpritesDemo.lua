local animationTimer = 0
local currentFrame = 1
local SpritesDemo = {}
local playerFrames = {}
local frameDuration = 0.25

local function createPlayerSprite()
    local sprite = f_sprite(16, 16, -1)

    -- Chapeau
    for x = 5, 12 do
        f_spr_pixel(sprite, x, 2, 4)
    end

    -- Tete
    for y = 3, 8 do
        for x = 4, 13 do
            f_spr_pixel(sprite, x, y, 7)
        end
    end

    -- Yeux
    f_spr_pixel(sprite, 6, 5, 0)
    f_spr_pixel(sprite, 11, 5, 0)

    -- Corps
    for y = 9, 13 do
        for x = 5, 12 do
            f_spr_pixel(sprite, x, y, 3)
        end
    end

    return sprite
end

function SpritesDemo.createPlayer()
    -- Image 1 : jambes normales
    playerFrames[1] = createPlayerSprite()

    for x = 5, 7 do
        f_spr_pixel(playerFrames[1], x, 14, 4)
    end

    for x = 10, 12 do
        f_spr_pixel(playerFrames[1], x, 14, 4)
    end

    -- Image 2 : jambe gauche avance
    playerFrames[2] = createPlayerSprite()

    for x = 5, 7 do
        f_spr_pixel(playerFrames[2], x, 14, 4)
    end

    for x = 10, 12 do
        f_spr_pixel(playerFrames[2], x, 15, 4)
    end

    -- Image 3 : jambe droite avance
    playerFrames[3] = createPlayerSprite()

    for x = 5, 7 do
        f_spr_pixel(playerFrames[3], x, 15, 4)
    end

    for x = 10, 12 do
        f_spr_pixel(playerFrames[3], x, 14, 4)
    end
end

function SpritesDemo.update(dt)
    animationTimer = animationTimer + dt

    if animationTimer >= frameDuration then
        animationTimer = animationTimer - frameDuration

        currentFrame = currentFrame + 1

        if currentFrame > #playerFrames then
            currentFrame = 1
        end
    end
end

function SpritesDemo.draw()
    f_cls(0)

    -- Titre
    f_print("SPRITES DEMO", 112, 8, 7)

    -- Separateur
    f_line(10, 22, 310, 22, 5)

    -- Zone gauche : creation directe
    f_print("SPRITE CREATION", 16, 34, 4)
    f_print("Internal\ninstructions", 16, 46, 7)

    local player = playerFrames[currentFrame]

    if player then
        f_spr(player, 56, 72)
    end

    f_print("f_sprite()", 16, 130, 7)
    f_print("f_spr_pixel()", 16, 142, 7)
    f_print("f_spr()", 16, 154, 7)

    -- Separateur vertical
    f_line(160, 30, 160, 175, 5)

    -- Zone droite : spritesheet
    f_print("SPRITESHEET", 180, 34, 3)
    f_print("Image loading", 180, 46, 7)

    f_print("Coming soon...", 180, 90, 6)

    -- Bas de l'ecran
    f_line(10, 180, 310, 180, 5)
    f_print("FANTASY COMPUTER 128", 88, 190, 7)
end

return SpritesDemo
