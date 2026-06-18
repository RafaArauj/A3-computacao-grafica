local C = require("constants")
local Player = require("src.player")

local AI = {}

function AI.update(bot, enemy, dt)

    local botCenter = bot.x + C.PW / 2
    local enemyCenter = enemy.x + C.PW / 2

    local distance = enemyCenter - botCenter

    local minDistance = 30
    local maxDistance = 40

    bot.vx = 0

    if math.abs(distance) > maxDistance then

        if distance > 0 then
            bot.vx = C.SPEED
            bot.facing = "right"
        else
            bot.vx = -C.SPEED
            bot.facing = "left"
        end

    elseif math.abs(distance) < minDistance then

        if distance > 0 then
            bot.vx = -C.SPEED * 0.6
            bot.facing = "right"
        else
            bot.vx = C.SPEED * 0.6
            bot.facing = "left"
        end

    end

    if bot.onGround and math.random() < 0.001 then
        Player.jump(bot)
    end

    if math.abs(distance) >= minDistance and math.abs(distance) <= maxDistance then

        if math.random() < 0.02 then
            Player.attack(bot)
        end

    end

    if enemy.isAttacking then

        if math.random() < 0.01 then
            bot.isBlocking = true
        end

    else
        bot.isBlocking = false
    end

end

return AI