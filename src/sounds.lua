local Sounds = {}

local punchSrc
local deathSrc

local function makePunchSound()
    local rate = 44100
    local dur  = 0.13
    local n    = math.floor(rate * dur)
    local sd   = love.sound.newSoundData(n, rate, 16, 1)
    for i = 0, n - 1 do
        local t   = i / rate
        local env = math.exp(-t * 28)
        local tone  = math.sin(2 * math.pi * 80 * t) * 0.4
        local noise = (love.math.random() * 2 - 1) * 0.6
        sd:setSample(i, math.max(-1, math.min(1, (tone + noise) * env)))
    end
    return love.audio.newSource(sd)
end

local function makeDeathSound()
    local rate = 44100
    local dur  = 0.55
    local n    = math.floor(rate * dur)
    local sd   = love.sound.newSoundData(n, rate, 16, 1)
  
    for i = 0, n - 1 do
        local t = i / rate
        local env, sample
        if t < 0.08 then
            env    = math.exp(-t * 40)
            sample = (love.math.random() * 2 - 1) * env * 0.9
        else
            local t2  = t - 0.08
            env       = math.exp(-t2 * 5)
            local freq = 260 * math.exp(-t2 * 3.5)
            sample = math.sin(2 * math.pi * freq * t) * env * 0.7
                   + (love.math.random() * 2 - 1) * env * 0.15
        end
        sd:setSample(i, math.max(-1, math.min(1, sample)))
    end
    return love.audio.newSource(sd)
end

function Sounds.load()
    punchSrc = makePunchSound()
    deathSrc = makeDeathSound()
end

function Sounds.playPunch()
    if not punchSrc then return end
    local clone = punchSrc:clone()
    clone:setVolume(0.7)
    clone:play()
end

function Sounds.playDeath()
    if not deathSrc then return end
    local clone = deathSrc:clone()
    clone:setVolume(0.9)
    clone:play()
end

return Sounds
