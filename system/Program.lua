local Graphics  = require("api.Graphics")
local MemoryAPI = require("api.Memory")
local Logger    = require("system.Logger")
local InputAPI  = require("api.Input")

---@class Program
local Program   = {}
Program.__index = Program

---@param video Video
---@param animationManager AnimationManager
function Program.new(video, animationManager)
    local self            = setmetatable({}, Program)

    self.boot             = nil
    self.fan128           = nil
    self.loaded           = false
    self.animationManager = animationManager

    Graphics.init(video, animationManager)

    return self
end

function Program:load(path)
    self.animationManager:clear()
    local chunk, errorMessage = love.filesystem.load(path)

    if not chunk then
        print("Erreur de chargement :", errorMessage)
        return false
    end

    local environment = {

        -- Ecran
        f_screen_width      = Graphics.screen_width,
        f_screen_height     = Graphics.screen_height,
        f_cls               = Graphics.cls,
        f_palette           = Graphics.palette,
        f_color             = Graphics.color,

        -- Graphique
        f_pixel             = Graphics.pixel,
        f_print             = Graphics.print,
        f_line              = Graphics.line,
        f_rect_fill         = Graphics.rect_fill,
        f_rect              = Graphics.rect,
        f_circle            = Graphics.circle,
        f_circle_fill       = Graphics.circle_fill,
        f_ellipse           = Graphics.ellipse,
        f_ellipse_fill      = Graphics.ellipse_fill,
        f_triangle          = Graphics.triangle,
        f_triangle_fill     = Graphics.triangle_fill,
        f_polygone          = Graphics.polygone,
        f_polygone_fill     = Graphics.polygone_fill,

        -- SPRITES
        f_sprite            = Graphics.sprite,
        f_spr               = Graphics.spr,
        f_spritesheet       = Graphics.spritesheet,
        f_get_sprite        = Graphics.get_sprite,

        -- ANIMATION
        f_animation         = Graphics.animation,
        f_stop_anim         = Graphics.stop_anim,
        f_play_anim         = Graphics.play_anim,
        f_reset_anim        = Graphics.reset_anim,
        f_set_anim_speed    = Graphics.set_anim_speed,

        -- Input
        f_btn               = InputAPI.btn,
        f_btnp              = InputAPI.btnp,
        f_btnr              = InputAPI.btnr,

        --- JOYSTICK
        f_axis              = InputAPI.axis,
        f_direction         = InputAPI.direction,
        f_joystickCount     = InputAPI.joystickCount,
        f_joystickConnected = InputAPI.joystickConnected,

        -- Accès mémoire
        f_peek              = MemoryAPI.peek,
        f_poke              = MemoryAPI.poke,

    }

    setmetatable(environment, {
        __index = _G
    })

    setfenv(chunk, environment)

    local success, result = pcall(chunk)

    if not success then
        print("Erreur d'execution :", result)
        return false
    end
    -- Initialisation de la cartouche
    if environment.BOOT then
        local bootSuccess, bootError = pcall(environment.BOOT)

        if not bootSuccess then
            print("CARTRIDGE BOOT ERROR :", bootError)
            Logger.error("CARTRIDGE BOOT ERROR : " .. tostring(bootError))
            self.fan128 = nil
            self.loaded = false
            self.errorMessage = bootError
            return false
        end
    end

    self.fan128 = environment.FAN128
    self.loaded = true

    return true
end

function Program:update(dt)
    if self.loaded and self.fan128 then
        local success, errorMessage = pcall(self.fan128, dt)

        if not success then
            self.errorMessage = errorMessage
            self.fan128 = nil
            self.loaded = false

            print("CARTRIDGE RUNTIME ERROR :", errorMessage)
            Logger.error("CARTRIDGE RUNTIME ERROR : " .. tostring(errorMessage))
        end
    end
end

--- Arrête le programme en cours.
function Program:stop()
    self.fan128 = nil
    self.loaded = false
end

return Program
