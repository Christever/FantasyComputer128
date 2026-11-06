---@class WebLogger
local WebLogger = {}

--- Initialise le moteur de journalisation Web.
function WebLogger.init()
end

--- Écrit un message dans la console du navigateur.
---@param entry string
function WebLogger.write(entry)
    print(entry)
end

return WebLogger