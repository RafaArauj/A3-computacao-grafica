--desenho da interface
local C = require("constants")
local UI = {}

function UI.drawBackground(bg)
    love.graphics.setColor(1, 1, 1)
    local scaleX = C.SW / bg:getWidth()
    local scaleY = C.SH / bg:getHeight()
    love.graphics.draw(bg, 0, 0, 0, scaleX, scaleY)
end

local function drawShadow(p)
    local escala      = 3
    local shadowCX    = p.x + C.PW * escala / 2
    local shadowCY    = C.GROUND_Y + C.PH * escala

    local distFromGround = math.max(0, C.GROUND_Y - p.y)
    local t           = math.min(1, distFromGround / 200)

    local rx    = 28 * (1 - t * 0.55)
    local ry    = rx  * 0.28
    local alpha = 0.38 * (1 - t * 0.65)

    love.graphics.setColor(0, 0, 0, alpha)
    love.graphics.ellipse("fill", shadowCX, shadowCY, rx, ry)
    love.graphics.setColor(1, 1, 1)
end

function UI.drawStickman(p)
    if not p.sprites then return end

    drawShadow(p)

    local img

    if p.isDead then
        img = (p.facing == "right") and p.sprites.deathR or p.sprites.deathL
        love.graphics.setColor(1, 1, 1)
        local escala = 3
        local scaleX = C.PW * escala / img:getWidth()
        local scaleY = C.PH * escala / img:getHeight()
        local drawH  = img:getHeight() * scaleY
        love.graphics.draw(img, p.x, C.GROUND_Y + C.PH * escala - drawH, 0, scaleX, scaleY)
        return
    end

    if p.hp <= 0 then
        img = (p.facing == "right") and p.sprites.deathR or p.sprites.deathL
        if not img then
            img = (p.facing == "right") and p.sprites.right or p.sprites.left
        end
    elseif p.isAttacking then
        img = (p.facing == "right") and p.sprites.attackR or p.sprites.attackL
    elseif p.vx ~= 0 or p.vy ~= 0 then
        if p.walkFrame == 0 then
            img = (p.facing == "right") and p.sprites.right or p.sprites.left
        else
            img = (p.facing == "right") and p.sprites.walkR or p.sprites.walkL
        end
    else
        img = (p.facing == "right") and p.sprites.right or p.sprites.left
    end

    local flash = p.hitFlash or 0
    if flash > 0 then
        local t = flash / 0.15
        love.graphics.setColor(1, 1 - t, 1 - t, 1)
    elseif p.isDefending then
        love.graphics.setColor(0.4, 0.6, 1, 1)
    else
        love.graphics.setColor(1, 1, 1)
    end

    local escala = 3
    local scaleX = C.PW * escala / img:getWidth()
    local scaleY = C.PH * escala / img:getHeight()
    love.graphics.draw(img, p.x, p.y, 0, scaleX, scaleY)
    love.graphics.setColor(1, 1, 1)
end

function UI.drawHPBar(p, idx)
    local barW = 180
    local barH = 18
    local pad  = 20
    local bx   = (idx == 1) and pad or (C.SW - pad - barW)
    local by   = 16

    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", bx, by, barW, barH, 4)

    local ratio = p.hp / C.MAX_HP
    love.graphics.setColor(1 - ratio, ratio, 0)
    love.graphics.rectangle("fill", bx, by, barW * ratio, barH, 4)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("P" .. idx .. "  " .. p.hp .. "/" .. C.MAX_HP, bx, by + 1, barW, "center")
end

function UI.drawHints()
    love.graphics.setColor(0.5, 0.5, 0.55)
end

function UI.drawGameOver(players)
    if players[1].hp > 0 and players[2].hp > 0 then return end

    local winner = (players[1].hp <= 0) and "Jogador 2 venceu!" or "Jogador 1 venceu!"
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, C.SH/2 - 45, C.SW, 90)
    love.graphics.setColor(1, 0.9, 0.1)
    love.graphics.printf(winner, 0, C.SH/2 - 28, C.SW, "center")
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.printf("Pressione R para jogar de novo", 0, C.SH/2 + 4, C.SW, "center")
end

return UI
