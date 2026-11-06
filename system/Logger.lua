local DesktopLogger = require("system.logging.DesktopLogger")
local WebLogger     = require("system.logging.WebLogger")
local Config        = require("system.Config")

local LoggerEngine

if Config.PLATFORM == "desktop" then
    LoggerEngine = DesktopLogger
elseif Config.PLATFORM == "web" then
    LoggerEngine = WebLogger
else
    error(
        "Plateforme inconnue : " .. tostring(Config.PLATFORM),
        2
    )
end

LoggerEngine.init()

LoggerEngine.startSession()

---@class Logger
local Logger = {}

Logger.LEVELS = {
    INFO = "INFO",
    WARNING = "WARNING",
    ERROR = "ERROR",
    DEBUG = "DEBUG"
}

Logger.LOG_DIRECTORY = "logs"
Logger.LOG_FILE = "logs/system.log"

--- Initialise le système de journalisation.
function Logger.init()
    love.filesystem.createDirectory(Logger.LOG_DIRECTORY)
    Logger.info("TEST INFO")
    Logger.warning("TEST WARNING")
    Logger.error("TEST ERROR")
    Logger.debug("TEST DEBUG")
end

--- Écrit un message dans le fichier journal.
---@param level string
---@param message string
function Logger.log(level, message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    local entry = string.format(
        "[%s] [%s] %s\n",
        timestamp,
        level,
        message
    )

    LoggerEngine.write(entry)
end



function Logger.info(message)
    Logger.log(Logger.LEVELS.INFO, message)
end

function Logger.warning(message)
    Logger.log(Logger.LEVELS.WARNING, message)
end

function Logger.error(message)
    Logger.log(Logger.LEVELS.ERROR, message)
end

--- Vérifie une condition et journalise une erreur si elle est fausse.
---@param condition boolean
---@param message string
---@return boolean
function Logger.assert(condition, message)
    if not condition then
        Logger.raise(message)
    end

    return condition
end

function Logger.debug(message)
    if not Config.DEBUG_MODE then
        return
    end

    Logger.log(Logger.LEVELS.DEBUG, message)
end

--- Journalise une erreur et interrompt l'exécution.
---@param message string
function Logger.raise(message)
    Logger.error(message)
    error(message, 2)
end

return Logger
