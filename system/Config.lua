---@class Config
local Config = {}

-- Mode de fonctionnement
Config.DEVELOPER_MODE = false

-- Durée de l'écran de démarrage (secondes)
Config.STARTUP_DURATION = 10

-- Programme chargé actuellement
Config.PROGRAM_PATH = "programs/main.lua"

-- Cartouche
Config.CARTRIDGE_PATH = "cartridges/main.lua"

Config.PLATFORM = "desktop"

-- Mode debug
Config.DEBUG_MODE = false

Config.LOADING_DURATION = 1

return Config