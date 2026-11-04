---@class Basic
local Basic = {}
Basic.__index = Basic

---@param video Video
---@return Basic
function Basic.new(video)
    local self = setmetatable({}, Basic)

    self.video = video

    return self
end

--- Exécute un programme BASIC.
---@param source string Code source du programme.
function Basic:run(source)
    for line in source:gmatch("[^\r\n]+") do
        self:executeLine(line)
    end
end

--- Analyse et exécute une ligne BASIC.
---@param line string Ligne de code.
function Basic:executeLine(line)
    line = line:match("^%s*(.-)%s*$")

    if line == "" then
        return
    end

    local command, arguments = line:match("^(%S+)%s*(.*)$")

    if not command then
        return
    end

    command = command:upper()

    if command == "CLS" then
        self.video:clear(0)
    end
end

return Basic
