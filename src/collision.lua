--sistema de colisão 
local C      = require("constants")
local Player = require("src.player")

local Collision = {}

function Collision.aabb(a, b)
    return a.x < b.x + C.PW and a.x + C.PW > b.x
       and a.y < b.y + C.PH and a.y + C.PH > b.y
end

function Collision.applyDamage(p1, p2)
    if not Collision.aabb(p1, p2) then return end

    if p1.isAttacking and p1.dmgTimer <= 0 then
        p2.hp = math.max(0, p2.hp - C.DAMAGE)
        p1.dmgTimer = C.DMG_CD
        p1.isAttacking = false
    end

    if p2.isAttacking and p2.dmgTimer <= 0 then
        p1.hp = math.max(0, p1.hp - C.DAMAGE)
        p2.dmgTimer = C.DMG_CD
        p2.isAttacking = false
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
