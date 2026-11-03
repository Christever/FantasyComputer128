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

    video:drawText(20, 20, "HELLO, WORLD!")
    video:drawText(20, 40, "10 + 20 = 30")
    video:drawText(20, 60, "PRICE: 150.50")
    print("Test setPixel terminé")
end

return VideoTest
