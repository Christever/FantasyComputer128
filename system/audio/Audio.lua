local bit = require("bit")

---@class Audio
local Audio = {}

---@enum VolumeRange
local Volume = {
    Min = 0,
    Low = 25,
    Medium = 50,
    High = 75,
    Max = 100
}


---@enum Waveform
local Waveform = {
    Square = "square",
    Triangle = "triangle",
    Sawtooth = "sawtooth",
    Noise = "noise"
}

local MusicalNote = {
    DO = 261.63,
    RE = 293.66,
    MI = 329.63,
    FA = 349.23,
    SOL = 392.00,
    LA = 440.00,
    SI = 493.88
}


Audio.__index       = Audio

Audio.CHANNEL_COUNT = 4
Audio.SAMPLE_RATE   = 44100

Audio.Volume        = Volume
Audio.Waveform      = Waveform
Audio.MusicalNote   = MusicalNote

Audio.MIN_OCTAVE    = 1
Audio.MAX_OCTAVE    = 7

--- Calcule la fréquence d'une note selon son octave
---@param note number Fréquence de base de la note
---@param octave integer Octave souhaitée
---@return number|nil
function Audio.getNoteFrequency(note, octave)
    if octave < Audio.MIN_OCTAVE or octave > Audio.MAX_OCTAVE then
        return nil
    end

    return note * (2 ^ (octave - 4))
end

--- Définit une séquence de notes musicales
---@param sequence table
---@return boolean
function Audio:setSequence(sequence)
    if type(sequence) ~= "table" or #sequence == 0 then
        return false
    end

    self.sequence = sequence
    self.sequenceIndex = 1
    self.sequencePlaying = false
    self.sequenceTimer = 0

    return true
end

--- Démarre la lecture de la séquence musicale
---@return boolean
function Audio:playSequence()
    if #self.sequence == 0 then
        return false
    end

    self.sequenceIndex   = 1
    self.sequenceTimer   = 0
    self.sequencePlaying = true
    self.sequencePaused  = false

    return true
end

--- Met en pause la séquence musicale
function Audio:pauseSequence()
    if not self.sequencePlaying then
        return false
    end

    self.sequencePaused = true
    self.paused = true
    self.source:pause()
    return true
end

--- Reprend la lecture d'une séquence musicale
---@return boolean
function Audio:resumeSequence()
    if not self.sequencePlaying or not self.sequencePaused then
        return false
    end

    self.sequencePaused = false
    self.paused = false

    if not self.source:isPlaying() then
        self.source:play()
    end

    return true
end

--- Met à jour la lecture de la séquence musicale
---@param dt number Temps écoulé en secondes
function Audio:updateSequence(dt)
    if not self.sequencePlaying or self.sequencePaused then
        return
    end

    self.sequenceTimer = self.sequenceTimer - dt

    if self.sequenceTimer > 0 then
        return
    end

    local item = self.sequence[self.sequenceIndex]

    if not item then
        self.sequencePlaying = false
        return
    end

    if item.rest then
        self:setChannelEnabled(1, false)
    else
        self:playNote(
            1,
            item.note,
            item.octave,
            item.duration,
            item.volume
        )
    end

    self.sequenceTimer = item.duration
    self.sequenceIndex = self.sequenceIndex + 1
end

--- Arrête la lecture de la séquence musicale
function Audio:stopSequence()
    self.sequencePlaying = false
    self.sequencePaused  = false
    self.sequenceIndex   = 1
    self.sequenceTimer   = 0

    self:setChannelEnabled(1, false)
end

--- Indique si une séquence musicale est en cours
---@return boolean
function Audio:isSequencePlaying()
    return self.sequencePlaying
end

--- Retourne la note actuellement sélectionnée dans la séquence
---@return table|nil
function Audio:getCurrentSequenceItem()
    if self.sequenceIndex <= 1 then
        return nil
    end

    return self.sequence[self.sequenceIndex - 1]
end

--- Retourne la position actuelle dans la séquence
---@return integer
function Audio:getSequencePosition()
    return self.sequenceIndex - 1
end

--- Crée une nouvelle instance Audio
---@return Audio
function Audio.new()
    local self           = setmetatable({}, Audio)

    self.masterVolume    = 1.0
    self.bufferSize      = 1024
    self.bufferCount     = 8
    self.playing         = false
    self.paused          = false
    self.muted           = false
    self.source          = love.audio.newQueueableSource(
        Audio.SAMPLE_RATE,
        16,
        2,
        self.bufferCount
    )
    self.channels        = {}
    self.noiseState      = 0xACE1
    self.noiseFrequency  = 440
    self.noisePhase      = 0

    self.sequence        = {}
    self.sequenceIndex   = 1
    self.sequencePlaying = false
    self.sequencePaused  = false
    self.sequenceTimer   = 0

    -- Initialisation des quatre canaux
    for i = 1, Audio.CHANNEL_COUNT do
        self.channels[i] = {
            waveform  = "square",
            frequency = 440,
            volume    = 1.0,
            enabled   = false,
            source    = nil,
            phase     = 0,
            duration  = 0
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

--- Génère un bruit pseudo-aléatoire rétro (LFSR)
---@return number
function Audio:generateNoise(dt)
    self.noisePhase = self.noisePhase + self.noiseFrequency * dt

    if self.noisePhase >= 1 then
        self.noisePhase = self.noisePhase % 1

        local lsb = bit.band(self.noiseState, 1)

        self.noiseState = bit.rshift(self.noiseState, 1)

        if lsb ~= 0 then
            self.noiseState = bit.bxor(self.noiseState, 0xB400)
        end
    end

    return bit.band(self.noiseState, 1) == 1 and 1 or -1
end

--- Définit la fréquence du générateur de bruit
---@param frequency number Fréquence en Hz
---@return boolean
function Audio:setNoiseFrequency(frequency)
    frequency = math.max(1, math.min(20000, frequency))
    self.noiseFrequency = frequency
    self.noisePhase = 0

    return true
end

--- Retourne la fréquence du générateur de bruit
---@return number
function Audio:getNoiseFrequency()
    return self.noiseFrequency
end

--- Réinitialise le générateur de bruit
function Audio:resetNoise()
    self.noiseState = 0xACE1
    self.noisePhase = 0
end

--- Fait avancer la phase d'un canal audio
---@param channel table
---@param dt number
function Audio.updateChannel(channel, dt)
    if channel.duration > 0 then
        channel.duration = channel.duration - dt

        if channel.duration <= 0 then
            channel.duration = 0
            channel.enabled = false
        end
    end

    channel.phase = (channel.phase + channel.frequency * dt) % 1
end

--- Génère le prochain échantillon d'un canal
---@param channel table
---@param dt number
---@return number
function Audio.generateChannelSample(channel, dt, audio)
    if not channel.enabled then
        return 0
    end

    Audio.updateChannel(channel, dt)

    local sample

    if channel.waveform == "noise" then
        sample = audio:generateNoise(dt)
    else
        sample = Audio.generateSample(
            channel.waveform,
            channel.phase
        )
    end

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
            + Audio.generateChannelSample(channel, dt, self)
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

        local volume = self.muted and 0 or self.masterVolume

        soundData:setSample(i, 1, sample * volume)
        soundData:setSample(i, 2, sample * volume)
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

--- Met à jour la file audio
function Audio:update(dt)
    if not self.playing or self.paused then
        return
    end

    self:updateSequence(dt)

    while self:queueBuffer() do
        -- Remplit la file tant qu'il reste de la place
    end

    self:play()
end

--- Définit la fréquence d'un canal audio
---@param channelIndex 1|2|3|4 Numéro du canal
---@param frequency number Fréquence en Hz (20 à 20000)
function Audio:setChannelFrequency(channelIndex, frequency)
    local channel = self.channels[channelIndex]

    if not channel then
        return false
    end

    frequency = math.max(20, math.min(20000, frequency))

    channel.frequency = frequency

    return true
end

--- Active ou désactive un canal audio
---@param channelIndex 1|2|3|4 Numéro du canal
---@param enabled boolean État du canal
function Audio:setChannelEnabled(channelIndex, enabled)
    local channel = self.channels[channelIndex]

    if not channel then
        return false
    end

    channel.enabled = enabled

    return true
end

--- Joue une note musicale sur un canal pendant une durée déterminée
---@param channelIndex 1|2|3|4 Numéro du canal
---@param note number Note issue de Audio.MusicalNote
---@param octave integer Octave souhaitée (1 à 7)
---@param duration number Durée en secondes
---@param volume integer Volume de 0 à 100
---@return boolean
function Audio:playNote(channelIndex, note, octave, duration, volume)
    local channel = self.channels[channelIndex]
    if not channel then return false end

    if duration <= 0 then return false end

    local frequency = Audio.getNoteFrequency(note, octave)
    if not frequency then return false end

    self:setChannelFrequency(channelIndex, frequency)
    self:setChannelVolume(channelIndex, volume)

    channel.phase = 0
    channel.duration = duration
    channel.enabled = true

    return true
end

--- Définit la forme d'onde d'un canal
---@param channelIndex 1|2|3|4 Numéro du canal
---@param waveform Waveform
function Audio:setChannelWaveform(channelIndex, waveform)
    local channel = self.channels[channelIndex]

    if not channel then
        return false
    end

    local validWaveforms = {
        [Waveform.Square] = true,
        [Waveform.Triangle] = true,
        [Waveform.Sawtooth] = true,
        [Waveform.Noise] = true
    }

    if not validWaveforms[waveform] then
        return false
    end

    channel.waveform = waveform

    return true
end

--- Définit le volume d'un canal audio
---@param channelIndex 1|2|3|4 integer Numéro du canal (1 à 4)
---@param volume integer  Volume (0 à 100)
function Audio:setChannelVolume(channelIndex, volume)
    local channel = self.channels[channelIndex]

    if not channel then
        return false
    end

    volume = math.max(0, math.min(100, volume))

    channel.volume = volume / 100

    return true
end

--- Définit le volume général
---@param volume number Volume entre 0 et 100
---@return boolean
function Audio:setMasterVolume(volume)
    volume = math.max(0, math.min(100, volume))
    self.masterVolume = volume / 100
    return true
end

--- Retourne le volume général en pourcentage
---@return number
function Audio:getMasterVolume()
    return self.masterVolume * 100
end

--- Active ou désactive le mode muet
---@param muted boolean
function Audio:setMuted(muted)
    self.muted = muted
end

--- Indique si le mode muet est actif
---@return boolean
function Audio:isMuted()
    return self.muted
end

--- Inverse l'état du mode muet
---@return boolean
function Audio:toggleMute()
    self.muted = not self.muted
    return self.muted
end

--- Démarre la lecture audio
function Audio:play()
    self.playing = true
    self.paused  = false

    if not self.source:isPlaying() then
        self.source:play()
    end
end

--- Arrête la lecture audio
function Audio:stop()
    self.playing = false
    self.paused  = false
    self.source:stop()
end

function Audio:pause()
    self.paused = true
    self.source:pause()
end

--- Réinitialise le système audio.
function Audio:reset()
    -- Arrêter la lecture
    self:stop()

    -- Réinitialiser les canaux
    for i = 1, Audio.CHANNEL_COUNT do
        local channel = self.channels[i]

        channel.frequency = 440
        channel.volume = 1.0
        channel.enabled = false
        channel.phase = 0
        channel.duration = 0
    end

    -- Réinitialiser le générateur de bruit
    self:resetNoise()

    -- Réinitialiser les séquences
    self.sequence = {}
    self.sequenceIndex = 1
    self.sequencePlaying = false
    self.sequencePaused = false
    self.sequenceTimer = 0

    -- Réinitialiser les paramètres généraux
    self.masterVolume = 1.0
    self.muted = false
end

return Audio
