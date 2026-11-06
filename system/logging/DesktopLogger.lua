---@class DesktopLogger
local DesktopLogger = {}

--- Initialise le moteur de journalisation Desktop.
function DesktopLogger.init()
end

--- Écrit un message dans le fichier journal.
---@param entry string
function DesktopLogger.write(entry)
    local previousContent = ""

    local file = io.open("system.log", "r")

    if file then
        previousContent = file:read("*a") or ""
        file:close()
    end

    file = io.open("system.log", "w")

    if not file then
        print("ERREUR : impossible d'ouvrir system.log")
        return
    end

    local header, remaining = previousContent:match(
        "^(========== NOUVELLE SESSION ==========\n\n)(.*)$"
    )

    if header then
        file:write(header)
        file:write(entry)
        file:write(remaining)
    else
        file:write(entry)
        file:write(previousContent)
    end

    file:close()
end

function DesktopLogger.startSession()
    local previousContent = ""

    local file = io.open("system.log", "r")

    if file then
        previousContent = file:read("*a") or ""
        file:close()
    end

    file = io.open("system.log", "w")

    if not file then
        print("ERREUR : impossible d'ouvrir system.log")
        return
    end

    file:write("========== NOUVELLE SESSION ==========\n\n")
    file:write(previousContent)
    file:close()
end

return DesktopLogger
