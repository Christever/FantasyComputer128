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
    video:drawLine(10, 10, 100, 10)

    video:setColor(2)
    video:drawLine(10, 20, 100, 80)

    video:drawLine(10, 90, 100, 30, 3)
    print("Test setPixel terminé")
end

return VideoTest
