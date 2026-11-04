---@class Audio
local Audio = {}
Audio.__index = Audio

Audio.CHANNEL_COUNT = 4
Audio.SAMPLE_RATE = 44100

--- Crée une nouvelle instance Audio
---@return Audio
function Audio.new()
    local self = setmetatable({}, Audio)

    self.masterVolume = 1.0
    self.channels = {}

    -- Initialisation des quatre canaux
    for i = 1, Audio.CHANNEL_COUNT do
        self.channels[i] = {
            waveform = "square",
            frequency = 440,
            volume = 1.0,
            enabled = true,
            source = nil
        }
    end

    -- Formes d'onde par défaut
    self.channels[1].waveform = "square"
    self.channels[2].waveform = "triangle"
    self.channels[3].waveform = "sawtooth"
    self.channels[4].waveform = "noise"

    return self
end

--- Génère un échantillon sonore selon une forme d'onde
---@param waveform string
---@param phase number
---@return number
function Audio.generateSample(waveform, phase)
    if waveform == "square" then
        return phase < 0.5 and 1 or -1
    elseif waveform == "triangle" then
        return 1 - 4 * math.abs(phase - 0.5)
    elseif waveform == "sawtooth" then
        return 2 * phase - 1
    elseif waveform == "noise" then
        return love.math.random() * 2 - 1
    end

    return 0
end

return Audio
