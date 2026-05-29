local C      = require("constants")
local Player = require("src.player")

local Collision = {}

function Collision.aabb(a, b)
    return a.x < b.x + C.PW and a.x + C.PW > b.x
       and a.y < b.y + C.PH and a.y + C.PH > b.y
end

function Collision.applyDamage(p1, p2)
    if not Collision.aabb(p1, p2) then return end

    if Player.isMoving(p1) and p1.dmgTimer <= 0 then
        p2.hp = math.max(0, p2.hp - C.DAMAGE)
        p1.dmgTimer = C.DMG_CD
    end

    if Player.isMoving(p2) and p2.dmgTimer <= 0 then
        p1.hp = math.max(0, p1.hp - C.DAMAGE)
        p2.dmgTimer = C.DMG_CD
    end
end

return Collision
