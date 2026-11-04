---@class Audio
---@field bufferSize integer
---@field bufferCount integer
---@field source love.Source
local Audio = {}

Audio.__index = Audio

Audio.CHANNEL_COUNT = 4
Audio.SAMPLE_RATE = 44100

--- Crée une nouvelle instance Audio
---@return Audio
function Audio.new()
    local self = setmetatable({}, Audio)

    self.masterVolume = 1.0
    self.bufferSize = 1024
    self.bufferCount = 8

    self.source = love.audio.newQueueableSource(
        Audio.SAMPLE_RATE,
        16,
        2,
        self.bufferCount
    )
    self.channels = {}

    -- Initialisation des quatre canaux
    for i = 1, Audio.CHANNEL_COUNT do
        self.channels[i] = {
            waveform  = "square",
            frequency = 440,
            volume    = 1.0,
            enabled   = true,
            source    = nil,
            phase     = 0
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

--- Fait avancer la phase d'un canal audio
---@param channel table
---@param dt number
function Audio.updateChannel(channel, dt)
    if not channel.enabled then
        return
    end

    channel.phase = channel.phase + channel.frequency * dt

    -- La phase reste comprise entre 0 et 1
    channel.phase = channel.phase % 1
end

--- Génère le prochain échantillon d'un canal
---@param channel table
---@param dt number
---@return number
function Audio.generateChannelSample(channel, dt)
    if not channel.enabled then
        return 0
    end

    Audio.updateChannel(channel, dt)

    local sample = Audio.generateSample(
        channel.waveform,
        channel.phase
    )

    return sample * channel.volume
end

--- Mélange les échantillons des quatre canaux
---@param dt number
---@return number
function Audio:mixChannels(dt)
    local mixedSample = 0

    for i = 1, Audio.CHANNEL_COUNT do
        local channel = self.channels[i]

        mixedSample = mixedSample
            + Audio.generateChannelSample(channel, dt)
    end

    return math.max(-1, math.min(1, mixedSample / Audio.CHANNEL_COUNT))
end

--- Génère un bloc de données audio
---@param sampleCount integer
---@return love.SoundData
function Audio:generateBuffer(sampleCount)
    local soundData = love.sound.newSoundData(
        sampleCount,
        Audio.SAMPLE_RATE,
        16,
        2
    )

    for i = 0, sampleCount - 1 do
        local sample = self:mixChannels(1 / Audio.SAMPLE_RATE)

        soundData:setSample(i, 1, sample * self.masterVolume)
        soundData:setSample(i, 2, sample * self.masterVolume)
    end

    return soundData
end

--- Ajoute un bloc audio à la file de lecture
function Audio:queueBuffer()
    if self.source:getFreeBufferCount() <= 0 then
        return false
    end

    local soundData = self:generateBuffer(self.bufferSize)

    self.source:queue(soundData)

    return true
end

--- Démarre la lecture audio
function Audio:play()
    if not self.source:isPlaying() then
        self.source:play()
    end
end

--- Met à jour la file audio
function Audio:update()
    while self:queueBuffer() do
        -- Remplit la file tant qu'il reste de la place
    end

    self:play()
end

return Audio
