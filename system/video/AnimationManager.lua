---@class AnimationManager
local AnimationManager = {}

function AnimationManager.new()
    local self = setmetatable({}, { __index = AnimationManager })

    self.animations = {}

    return self
end

--- Enregistre une animation.
---@param animation Animation
function AnimationManager:add(animation)
    table.insert(self.animations, animation)
end

--- Met à jour toutes les animations.
---@param dt number
function AnimationManager:update(dt)
    for _, animation in ipairs(self.animations) do
        animation:update(dt)
    end
end

--- Supprime toutes les animations enregistrées.
function AnimationManager:clear()
    self.animations = {}
end

return AnimationManager
