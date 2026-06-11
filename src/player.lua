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
        attackTimer = 0
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
    if love.keyboard.isDown(p.keys.left)  then p.vx = -C.SPEED end
    if love.keyboard.isDown(p.keys.right) then p.vx =  C.SPEED end
    if love.keyboard.isDown(p.keys.up)    then p.vy = -C.SPEED end
    if love.keyboard.isDown(p.keys.down)  then p.vy =  C.SPEED end

    -- normaliza diagonal
    if p.vx ~= 0 and p.vy ~= 0 then
        local f = C.SPEED / math.sqrt(2 * C.SPEED * C.SPEED)
        p.vx = p.vx * f
        p.vy = p.vy * f
    end

    p.x = math.max(0, math.min(C.SW - C.PW, p.x + p.vx * dt))
    p.y = math.max(0, math.min(C.SH - C.PH, p.y + p.vy * dt))

    if p.dmgTimer > 0 then p.dmgTimer = p.dmgTimer - dt end
end

function Player.isMoving(p)
    return p.vx ~= 0 or p.vy ~= 0
end

function Player.attack(p)
    if p.attackTimer <= 0 then
        print("ATAQUE")
        p.isAttacking = true
        p.attackTimer= 0.2
    end
end
return Player
