local C = require("constants")

local UI = {}

function UI.drawBackground()
    love.graphics.setColor(0.12, 0.12, 0.16)
    love.graphics.rectangle("fill", 0, 0, C.SW, C.SH)
end

function UI.drawStickman(p)
    local cx = p.x + C.PW / 2
    love.graphics.setColor(p.color)
    love.graphics.rectangle("fill", p.x, p.y, C.PW, C.PH, 6)
    love.graphics.circle("fill", cx, p.y - C.HEAD_R - 2, C.HEAD_R)
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
