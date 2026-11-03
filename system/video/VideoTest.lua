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

    video:clear(3)

    
end

return VideoTest
