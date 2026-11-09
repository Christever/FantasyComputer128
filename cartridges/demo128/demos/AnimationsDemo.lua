local AnimationsDemo = {}

local chestSprites
local chestOpened = false

local animationSheet1, heroicSheet, heartSheet
local heartAnimation, animation1, heroicAnimation, animation2, slimeAnimation, chestAnimation

function AnimationsDemo.create()
    animationSheet1    = f_spritesheet("cartridges/demo128/assets/sprites/player.png", 16, 16)
    animation1         = f_animation(animationSheet1, { 1, 2, 3 }, 5, "loop")
    animation2         = f_animation(animationSheet1, { 5, 6, 7 }, 5)
    heroicSheet        = f_spritesheet("cartridges/demo128/assets/sprites/test.png", 16, 16)
    heroicAnimation    = f_animation(heroicSheet, { 1, 2 }, 2, "loop")
    heartSheet         = f_spritesheet("cartridges/demo128/assets/sprites/heart.png", 16, 16)
    heartAnimation     = f_animation(heartSheet, { 1, 2 }, 2, "loop")

    local slimeSprite  = require("cartridges.demo128.demos.sprites.SlimeAnim")

    local slimeSprites = slimeSprite.create()
    slimeAnimation     = f_animation_sprites(slimeSprites, 4, "loop")

    local chestSprite  = require("cartridges.demo128.demos.sprites.ChestAnim")
    chestSprites       = chestSprite.create()
    chestAnimation     = f_animation_sprites(chestSprites, 4, "once")
end

function AnimationsDemo.draw()
    if f_btnp("UP") then
        chestOpened = true
        f_reset_anim(chestAnimation)
        f_play_anim(chestAnimation)
    end
    f_cls(0)

    -- Titre
    f_print("ANIMATIONS DEMO", 104, 8, 7)

    -- Separateur
    f_line(10, 22, 310, 22, 5)

    -- Zone gauche : sprites internes
    f_print("LUA SPRITES", 35, 34, 4)

    -- Animation du slime
    f_spr(slimeAnimation, 55, 65)

    f_print("SLIME", 48, 88, 7)
    f_print("f_animation_sprites()", 15, 110, 3)

    -- Animation du coffre
    if chestOpened then
        f_spr(chestAnimation, 55, 125)
    else
        f_spr(chestSprites[1], 55, 125)
    end


    f_print("CHEST", 48, 145, 7)
    f_print("MODE ONCE", 35, 155, 3)
    f_print("PRESS UP TO PLAY", 15, 165)

    -- Zone droite : animations
    f_print("SPRITESHEET\nANIMATIONS", 170, 34, 4)

    -- Premiere rangee
    f_spr(animation1, 195, 60)
    f_spr(animation2, 260, 60)

    f_print("PLAYER", 190, 82, 7)
    f_print("PLAYER", 255, 82, 7)

    -- Deuxieme rangee
    f_spr(heroicAnimation, 195, 100)
    f_spr(heartAnimation, 260, 100)

    f_print("HEROIC", 195, 122, 7)
    f_print("HEART", 255, 122, 7)

    -- Explications
    f_print("f_animation()", 175, 145, 3)
    f_print("f_spr()", 175, 157, 3)

    -- Separateur
    f_line(10, 180, 310, 180, 5)

    f_print("FANTASY COMPUTER 128", 88, 190, 7)
end

return AnimationsDemo
