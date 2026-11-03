---@type Palette
local Palette = require("system.video.Palette")
local Video = require("system.video.Video")
local Sprite = require("system.video.Sprite")

local VideoTest = {}

---comment
---@param video Video
function VideoTest.run(video)
    print("========== SPRITE TEST ==========")
    Palette.setColor(0, 0, 0, 0)
    Palette.setColor(1, 255, 0, 0)
    Palette.setColor(2, 0, 255, 0)
    Palette.setColor(3, 0, 0, 255)
    Palette.setColor(4, 255, 255, 255)

    video:clear(0)

local sprite = Sprite.new(16, 16, 1)

sprite:setTransparentColor(0)

for y = 1, 16 do
    for x = 1, 8 do
        sprite:setPixel(x, y, 2)
    end
end

-- Affichage sans retournement
video:drawSprite(sprite, 100, 80)
end

return VideoTest
