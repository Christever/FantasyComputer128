local AnimationsDemo = {}

local animationSheet1, heroicSheet, heartSheet
local heartAnimation, animation1, heroicAnimation, animation2

function AnimationsDemo.create()
    animationSheet1 = f_spritesheet("cartridges/demo128/assets/sprites/player.png", 16, 16)
    animation1      = f_animation(animationSheet1, { 1, 2, 3 }, 5, "loop")
    animation2      = f_animation(animationSheet1, { 5, 6, 7 }, 5)
    heroicSheet     = f_spritesheet("cartridges/demo128/assets/sprites/test.png", 16, 16)
    heroicAnimation = f_animation(heroicSheet, { 1, 2 }, 2, "loop")
    heartSheet      = f_spritesheet("cartridges/demo128/assets/sprites/heart.png", 16, 16)
    heartAnimation  = f_animation(heartSheet, { 1, 2 }, 2, "loop")
end

function AnimationsDemo.draw()
    f_cls(0)

    -- Titre
    f_print("ANIMATIONS DEMO", 104, 8, 7)

    -- Separateur
    f_line(10, 22, 310, 22, 5)

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
