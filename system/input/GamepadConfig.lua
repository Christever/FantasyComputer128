---@class GamepadConfig
local GamepadConfig = {}

-- Profils des manettes reconnues
GamepadConfig.PROFILES = {

    -- Saitek P880
    ["03001ba9a30600000901000000010000"] = {
        name = "SAITEK P880",

        buttons = {
            A = "a",
            B = "b",
            START = "rightshoulder",
            SELECT = "leftshoulder"
        }
    }

}

return GamepadConfig