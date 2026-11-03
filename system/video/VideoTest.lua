---@type Palette
local Palette = require("system.video.Palette")
local Video = require("system.video.Video")

local VideoTest = {}

---comment
---@param video Video
function VideoTest.run(video)
    print("========== VIDEO TEST ==========")
    Palette.setColor(0, 0, 0, 0)
    Palette.setColor(1, 255, 0, 0)
    Palette.setColor(2, 0, 255, 0)
    Palette.setColor(3, 0, 0, 255)
    Palette.setColor(4, 255, 255, 255)
    video:clear(0)

    -- Polygone convexe vide
    video:setColor(1)
    video:drawPolygon({
        { x = 40,  y = 30 },
        { x = 120, y = 30 },
        { x = 140, y = 80 },
        { x = 80,  y = 110 },
        { x = 30,  y = 80 }
    })

    -- Polygone concave plein
    video:setColor(2)
    video:fillPolygon({
        { x = 190, y = 30 },
        { x = 280, y = 30 },
        { x = 250, y = 65 },
        { x = 280, y = 110 },
        { x = 190, y = 110 },
        { x = 220, y = 65 }
    })
    print("Test setPixel terminé")
end

return VideoTest
