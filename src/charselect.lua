local C = require("constants")
local CharSelect = {}

local characters = {
    { name = "Largartor", menu = "src/assets/lagartorMenu.png" },
    { name = "Lady Kate", menu = "src/assets/LadyKateMenu.png" },
    { name = "Ratito",    menu = "src/assets/RatitoMenu.png"   },
}

local menuImgs  = {}
local cursors   = { 1, 1 }
local confirmed = { false, false }
local firstPick = {}
local p2Active  = false

function CharSelect.load()
    for i, c in ipairs(characters) do
        menuImgs[i] = love.graphics.newImage(c.menu)
    end
end

function CharSelect.isP1Confirmed()
    return confirmed[1]
end

function CharSelect.isP2Active()
    return p2Active
end

function CharSelect.confirmBot()
    if not confirmed[2] then
        cursors[2]   = love.math.random(1, #characters)
        confirmed[2] = true
        if not firstPick[cursors[2]] then firstPick[cursors[2]] = 2 end
    end
end

function CharSelect.keypressed(key)
    -- P2 entra na partida
    if key == "2" and not p2Active then
        p2Active = true
        return
    end

    -- P1: A/D navega, Espaço confirma
    if not confirmed[1] then
        if key == "a" then cursors[1] = math.max(1, cursors[1] - 1) end
        if key == "d" then cursors[1] = math.min(#characters, cursors[1] + 1) end
        if key == "space" then
            confirmed[1] = true
            if not firstPick[cursors[1]] then firstPick[cursors[1]] = 1 end
        end
    end

    -- P2: Setas navega, 0 confirma (só se ativo)
    if p2Active and not confirmed[2] then
        if key == "left"  then cursors[2] = math.max(1, cursors[2] - 1) end
        if key == "right" then cursors[2] = math.min(#characters, cursors[2] + 1) end
        if key == "0" then
            confirmed[2] = true
            if not firstPick[cursors[2]] then firstPick[cursors[2]] = 2 end
        end
    end
end

function CharSelect.isReady()
    return confirmed[1] and confirmed[2]
end

function CharSelect.getChoices()
    local result = {}
    for p = 1, 2 do
        local charIdx = cursors[p]
        local variant = (firstPick[charIdx] == p) and "p1" or "p2"
        result[p] = { char = charIdx, variant = variant }
    end
    return result
end

function CharSelect.draw()
    love.graphics.setColor(0.12, 0.12, 0.16)
    love.graphics.rectangle("fill", 0, 0, C.SW, C.SH)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Selecione o personagem", 0, 40, C.SW, "center")
    love.graphics.setColor(0.75, 0.75, 0.85)
    love.graphics.printf("P1: A / D  +  Espaco", 0, 65, C.SW, "center")
    if p2Active then
        love.graphics.setColor(1, 0.5, 0.3)
        love.graphics.printf("P2: Setas  +  0", 0, 83, C.SW, "center")
    else
        love.graphics.setColor(0.45, 0.45, 0.55)
        love.graphics.printf("Pressione 2 para P2 entrar  |  F11: tela cheia", 0, 83, C.SW, "center")
    end

    local boxW, boxH = 160, 160
    local spacing    = 40
    local totalW     = #characters * boxW + (#characters - 1) * spacing
    local startX     = (C.SW - totalW) / 2

    for i, c in ipairs(characters) do
        local bx = startX + (i - 1) * (boxW + spacing)
        local by = C.SH / 2 - boxH / 2

        if cursors[1] == i then
            love.graphics.setColor(0.25, 0.55, 1, confirmed[1] and 1 or 0.6)
            love.graphics.rectangle("line", bx - 4, by - 4, boxW + 8, boxH + 8, 4)
        end

        if p2Active and cursors[2] == i then
            love.graphics.setColor(1, 0.3, 0.2, confirmed[2] and 1 or 0.6)
            love.graphics.rectangle("line", bx - 8, by - 8, boxW + 16, boxH + 16, 4)
        end

        love.graphics.setColor(1, 1, 1)
        local img   = menuImgs[i]
        local scale = math.min(boxW / img:getWidth(), boxH / img:getHeight())
        local iw    = img:getWidth()  * scale
        local ih    = img:getHeight() * scale
        love.graphics.draw(img, bx + (boxW - iw) / 2, by + (boxH - ih) / 2, 0, scale, scale)

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.printf(c.name, bx, by + boxH + 8, boxW, "center")
    end

    if CharSelect.isReady() then
        love.graphics.setColor(1, 0.9, 0.1)
        love.graphics.printf("Iniciando...", 0, C.SH - 50, C.SW, "center")
    end
end

function CharSelect.reset()
    cursors   = { 1, 1 }
    confirmed = { false, false }
    firstPick = {}
    p2Active  = false
end

return CharSelect
