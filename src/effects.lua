-- efeitos visuais: partículas e tela mexendo
local Effects = {}
local active = {}

local particles = {}
local shake = { timer = 0, intensity = 0 }

local function addParticle(x, y, big)
    local count = big and 20 or 8
    for _ = 1, count do
        local angle = love.math.random() * math.pi * 2
        local speed = love.math.random(60, big and 240 or 160)
        local life  = love.math.random() * 0.25 + 0.1
        table.insert(particles, {
            x = x, y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed - (big and 80 or 40),
            life = life,
            maxLife = life,
            size = love.math.random(big and 4 or 2, big and 8 or 5),
            r = 1,
            g = big and love.math.random() * 0.2 or love.math.random() * 0.6,
            b = 0,
        })
    end
end

function Effects.spawnHit(x, y)
    addParticle(x, y, false)
    Effects.shake(4, 0.12)
end

function Effects.spawnDeath(x, y)
    addParticle(x, y, true)
    Effects.shake(10, 0.45)
end

function Effects.shake(intensity, duration)
    if intensity > shake.intensity then
        shake.intensity = intensity
        shake.timer     = duration
    end
end

function Effects.getShakeOffset()
    if shake.timer <= 0 then return 0, 0 end
    local s = shake.intensity * (shake.timer / 0.45)
    return love.math.random(-s, s), love.math.random(-s, s)
end

function Effects.update(dt)
    shake.timer = math.max(0, shake.timer - dt)
    if shake.timer <= 0 then shake.intensity = 0 end

    for i = #particles, 1, -1 do
        local pt = particles[i]
        pt.life = pt.life - dt
        if pt.life <= 0 then
            table.remove(particles, i)
        else
            pt.x  = pt.x  + pt.vx * dt
            pt.y  = pt.y  + pt.vy * dt
            pt.vy = pt.vy + 500 * dt  -- gravidade
        end
    end
end

function Effects.draw()
    for _, pt in ipairs(particles) do
        local alpha = pt.life / pt.maxLife
        love.graphics.setColor(pt.r, pt.g, pt.b, alpha)
        love.graphics.rectangle("fill", pt.x - pt.size/2, pt.y - pt.size/2, pt.size, pt.size)
    end
    love.graphics.setColor(1, 1, 1)
end

return Effects
