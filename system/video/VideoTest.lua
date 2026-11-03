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

    video:setColor(1)
    video:drawEllipse(80, 80, 50, 25)

    video:setColor(2)
    video:fillEllipse(220, 80, 40, 20)

    video:setColor(3)
    video:drawEllipse(160, 150, 70, 15)
    print("Test setPixel terminé")
end

return VideoTest
