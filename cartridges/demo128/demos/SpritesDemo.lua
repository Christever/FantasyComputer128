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

    f_print("SPRITES DEMO", 112, 10, 7)

    -- Creation directe
    f_print("SPRITE CREATION", 16, 35, 4)
    f_print("Created with internal instructions", 16, 46, 7)

    -- Animation
    local player = playerFrames[currentFrame]

    if player then
        f_spr(player, 152, 80)
    end

    f_print("3 FRAMES ANIMATION", 16, 150, 3)
    f_print("Created with f_sprite() and f_spr_pixel()", 16, 162, 7)

    -- Spritesheet
    f_print("SPRITESHEET", 16, 180, 4)
    f_print("Load sprites from an image file", 16, 192, 7)
end

return SpritesDemo
