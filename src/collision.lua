--sistema de colisão 
local C      = require("constants")
local Player = require("src.player")

local Collision = {}

function Collision.aabb(a, b)
    return a.x < b.x + C.PW and a.x + C.PW > b.x
       and a.y < b.y + C.PH and a.y + C.PH > b.y
end

function Collision.push(p1, p2)
    if  not Collision.aabb(p1, p2)  then return end
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
        

local function dealDamage(attacker, defender)
    if attacker.isAttacking and attacker.dmgTimer <= 0 then

        -- Parry
        if defender.isParrying then
            defender.isParrying = false
            defender.parryTimer = 0

            print("PARRY!")
            attacker.dmgTimer = C.DMG_CD
            return
        end

        -- Defesa
        local damage = C.DAMAGE

        if defender.isBlocking then
            damage = damage * C.BLOCK_MULTIPLIER
        end

        defender.hp = math.max(0, defender.hp - damage)
        attacker.dmgTimer = C.DMG_CD
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
        h = C.PH
    }
    
end
return Collision
