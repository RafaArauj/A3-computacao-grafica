--movimentação e estado do jogador
local C = require("constants")
local Player = {}

function Player.new(x, y, color, keys)
    return {
        x = x, y = y,
        vx = 0, vy = 0,
        hp = C.MAX_HP,
        color = color,
        keys = keys,
        dmgTimer = 0,
        isAttacking = false,
        attackTimer = 0,
        facing = "right",
        walkTimer = 0,
        walkFrame = 0,
        hitFlash = 0,
        isDead = false,
        onGround = true,
    }
end

function Player.update(p, dt)
    if p.attackTimer> 0 then
        p.attackTimer = p.attackTimer -dt
    else 
        p.isAttacking = false
    end

    p.vx = 0
    p.vy = 0
    
    if p.isDead then return end
    if love.keyboard.isDown(p.keys.left)  then p.vx = -C.SPEED end
    if love.keyboard.isDown(p.keys.right) then p.vx =  C.SPEED end
    if p.vx > 0 then p.facing = "right"
    elseif p.vx < 0 then p.facing = "left" end

    p.vy = p.vy + C.GRAVITY * dt
    
    -- normaliza diagonal
    if p.vx ~= 0 or p.vy ~= 0 then
    p.walkTimer = p.walkTimer + dt
    if p.walkTimer >= 0.15 then
        p.walkTimer = 0
        p.walkFrame = 1 - p.walkFrame  -- alterna entre 0 e 1
    end
else
    p.walkTimer = 0
    p.walkFrame = 0
end

    p.x = math.max(0, math.min(C.SW - C.PW, p.x + p.vx * dt))
    p.y = p.y + p.vy * dt

    if p.y >= C.GROUND_Y then
    p.y = C.GROUND_Y
    p.vy = 0
    p.onGround = true
end

function Player.jump(p)
    if p.onGround then
        p.vy = C.JUMP_FORCE
        p.onGround = false
    end
end

    if p.dmgTimer > 0 then p.dmgTimer = p.dmgTimer - dt end
    if p.hitFlash > 0 then p.hitFlash = p.hitFlash - dt end
end

function Player.isMoving(p)
    return p.vx ~= 0 or p.vy ~= 0
end

function Player.attack(p)
    if p.attackTimer <= 0 then
        p.isAttacking = true
        p.attackTimer= 0.2
    end
end
return Player
