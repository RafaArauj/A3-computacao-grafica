--tela de seleção de modo de jogo
local C = require("constants")
local Menu = {}

local cursor = 1
local options = {
    { label = "Single Player", desc = "vs CPU" },
    { label = "Multiplayer",   desc = "2 Jogadores" },
}

function Menu.load()
    cursor = 1
end

function Menu.keypressed(key)
    if key == "left" or key == "a" then
        cursor = math.max(1, cursor - 1)
    elseif key == "right" or key == "d" then
        cursor = math.min(#options, cursor + 1)
    elseif key == "return" or key == "space" or key == "0" then
        return cursor
    end
    return nil
end

function Menu.draw()
    love.graphics.setColor(0.12, 0.12, 0.16)
    love.graphics.rectangle("fill", 0, 0, C.SW, C.SH)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("MODO DE JOGO", 0, C.SH * 0.28, C.SW, "center")

    local boxW   = 220
    local boxH   = 100
    local gap    = 60
    local totalW = #options * boxW + (#options - 1) * gap
    local startX = (C.SW - totalW) / 2
    local by     = C.SH / 2 - boxH / 2

    for i, opt in ipairs(options) do
        local bx = startX + (i - 1) * (boxW + gap)

        if cursor == i then
            love.graphics.setColor(1, 0.9, 0.1, 0.18)
            love.graphics.rectangle("fill", bx, by, boxW, boxH, 8)
            love.graphics.setColor(1, 0.9, 0.1)
            love.graphics.rectangle("line", bx - 3, by - 3, boxW + 6, boxH + 6, 8)
            love.graphics.setColor(1, 0.9, 0.1)
        else
            love.graphics.setColor(0.22, 0.22, 0.28)
            love.graphics.rectangle("fill", bx, by, boxW, boxH, 8)
            love.graphics.setColor(0.4, 0.4, 0.5)
            love.graphics.rectangle("line", bx, by, boxW, boxH, 8)
            love.graphics.setColor(0.75, 0.75, 0.75)
        end
        love.graphics.printf(opt.label, bx, by + 22, boxW, "center")

        love.graphics.setColor(0.5, 0.5, 0.6)
        love.graphics.printf(opt.desc, bx, by + 56, boxW, "center")
    end

    love.graphics.setColor(0.45, 0.45, 0.55)
    love.graphics.printf("A / D  ou  ← →  para navegar     Espaço para confirmar", 0, C.SH - 50, C.SW, "center")
    love.graphics.printf("F11: alternar tela cheia", 0, C.SH - 28, C.SW, "center")
end

return Menu
