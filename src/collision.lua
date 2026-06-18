--sistema de colisão
local C       = require("constants")
local Effects = require("src.effects")
local Sounds  = require("src.sounds")

local Collision = {}

function Collision.aabb(a, b)
    return a.x < b.x + C.PW and a.x + C.PW > b.x
       and a.y < b.y + C.PH and a.y + C.PH > b.y
end

function Collision.push(p1, p2)
    if not Collision.aabb(p1, p2) then return end
    if p1.x < p2.x then
        if p2.vx < 0 then
            p2.x = p1.x + C.PW
        else
            p1.x = p2.x - C.PW
        end
    else
        if p1.vx < 0 then
            p1.x = p2.x + C.PW
        else
            p2.x = p1.x - C.PW
        end
    end
end

local function hitEffect(attacker, victim)
    local hitX = (attacker.facing == "right") and (attacker.x + C.PW) or attacker.x
    local hitY = attacker.y + C.PH / 2

    local wasDead = victim.hp <= 0
    Sounds.playPunch()

    if not wasDead and victim.hp <= 0 then
        Effects.spawnDeath(hitX, hitY)
        Sounds.playDeath()
    else
        Effects.spawnHit(hitX, hitY)
    end

    if victim.hp <= 0 then
        victim.isDead = true
    end

    victim.hitFlash = 0.15
end

local function dealDamage(attacker, defender)
    if not (attacker.isAttacking and attacker.dmgTimer <= 0) then return end

    if defender.isParrying then
        defender.isParrying = false
        defender.parryTimer = 0
        attacker.dmgTimer   = C.DMG_CD
        Effects.shake(6, 0.2)
        return
    end

    local before = defender.hp
    local damage = defender.isBlocking and math.floor(C.DAMAGE * C.BLOCK_MULT) or C.DAMAGE
    defender.hp = math.max(0, defender.hp - damage)
    attacker.dmgTimer = C.DMG_CD

    if defender.hp < before then
        hitEffect(attacker, defender)
    end
end

function Collision.applyDamage(p1, p2)
    Collision.push(p1, p2)

    local dist = math.abs((p1.x + C.PW) - p2.x)
    if dist > 10 then return end

    dealDamage(p1, p2)
    dealDamage(p2, p1)
end

function Collision.attackBox(p)
    local reach = 30
    return {
        x = p.x + C.PW,
        y = p.y,
        w = reach,
        h = C.PH,
    }
end

return Collision
