local SpritesDemo = {}

-- SPRITES CREES
local PlayerSprite = require("cartridges.demo128.demos.sprites.PlayerSprite")
local ChestSprite = require("cartridges.demo128.demos.sprites.ChestSprite")
local SlimeSprite = require("cartridges.demo128.demos.sprites.SlimeSprite")
local TreeSprite = require("cartridges.demo128.demos.sprites.TreeSprite")

local perosSheet
local perso1, perso2, perso3, perso4
local player, chest, slime, tree

function SpritesDemo.create()
    player     = PlayerSprite.create()
    chest      = ChestSprite.create()
    slime      = SlimeSprite.create()
    tree       = TreeSprite.create()

    perosSheet = f_spritesheet("cartridges/demo128/assets/sprites/player.png", 16, 16)

    perso1     = f_get_sprite(perosSheet, 1)
    perso2     = f_get_sprite(perosSheet, 2)
    perso3     = f_get_sprite(perosSheet, 3)
    perso4     = f_get_sprite(perosSheet, 4)
end

function SpritesDemo.draw()
    f_cls(0)

    -- Titre
    f_print("SPRITES DEMO", 112, 8, 7)

    -- Separateur
    f_line(10, 22, 310, 22, 5)

    -- Zone gauche : creation directe
    f_print("SPRITE CREATION", 16, 34, 4)

    -- Premiere rangee
    if player then
        f_spr(player, 40, 60)
        f_print("PLAYER", 32, 82, 7)
    end

    if chest then
        f_spr(chest, 112, 60)
        f_print("CHEST", 104, 82, 7)
    end

    -- Deuxieme rangee
    if slime then
        f_spr(slime, 40, 100)
        f_print("SLIME", 32, 122, 7)
    end

    if tree then
        f_spr(tree, 112, 100)
        f_print("TREE", 108, 122, 7)
    end

    -- Instructions
    f_print("f_sprite()", 16, 142, 3)
    f_print("f_spr_pixel()", 16, 154, 3)

    -- Separateur vertical
    f_line(160, 30, 160, 175, 5)

    -- Zone droite : spritesheet
    f_print("SPRITESHEET", 180, 34, 4)
    f_spr(perso1, 195, 60)
    f_spr(perso2, 260, 60)
    f_spr(perso3, 195, 100)
    f_spr(perso4, 260, 100)

    -- Explication
    f_print("ONE IMAGE,\n MANY SPRITES", 175, 135, 3)
    f_print("f_spritesheet()", 175, 157, 3)
    f_print("f_get_sprite()", 175, 169, 3)

    -- Bas de l'ecran
    f_line(10, 180, 310, 180, 5)
    f_print("FANTASY COMPUTER 128", 88, 190, 7)
end

return SpritesDemo
