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

function Collision.applyDamage(p1, p2)
    Collision.push(p1, p2)

    local dist = math.abs((p1.x + C.PW) - p2.x)
    if dist > 10 then return end

    if p1.isAttacking and p1.dmgTimer <= 0 then
        local before = p2.hp
        local dmg = p2.isDefending and math.floor(C.DAMAGE * C.DEF_MULT) or C.DAMAGE
        p2.hp = math.max(0, p2.hp - dmg)
        p1.dmgTimer = C.DMG_CD
        if p2.hp < before then
            hitEffect(p1, p2)
        end
    end

    if p2.isAttacking and p2.dmgTimer <= 0 then
        local before = p1.hp
        local dmg = p1.isDefending and math.floor(C.DAMAGE * C.DEF_MULT) or C.DAMAGE
        p1.hp = math.max(0, p1.hp - dmg)
        p2.dmgTimer = C.DMG_CD
        if p1.hp < before then
            hitEffect(p2, p1)
        end
    end
end

function Collision.attackBox(p)
    local reach = 30
    return {
        x = p.x + C.PW,
        y = p.y,
        w = reach,
        h = C.PH
    }
end

return Collision
