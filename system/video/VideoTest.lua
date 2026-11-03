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
    video:drawRect(20, 20, 100, 60)

    video:setColor(2)
    video:fillRect(150, 20, 100, 60)
    print("Test setPixel terminé")
end

return VideoTest
