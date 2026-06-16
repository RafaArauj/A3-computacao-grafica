local C = require("constants")
local CharSelect = {}

local characters = {
    { name = "Largartor", menu = "src/assets/lagartorMenu.png"},
    { name = "Lady Kate", menu = "src/assets/LadyKateMenu.png"},
}

local menuImgs = {}
local cursors = {1, 1}
local confirmed = { false, false}
local firstPick = {}

function CharSelect.load()
    for i, c in ipairs(characters) do 
        menuImgs[i] = love.graphics.newImage(c.menu)
    end
end

function CharSelect.keypressed(key)
    if not confirmed[1] then
        if key == "a" then cursors[1] = math.max(1, cursors[1] - 1)
        end

        if key == "d"  then cursors[1] = math.min(#characters, cursors[1] + 1)
        end

        if key == "0" then
            confirmed[1] = true
            if not firstPick[cursors[1]] then firstPick[cursors[1]] = 1 end
        end
    end
    
    if not confirmed[2] then
        if key == "left" then cursors[2] = math.max(1, cursors[2] - 1)
        end

        if key == "right"  then cursors[2] = math.min(#characters, cursors[2] + 1)
        end

        if key == "space" then
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
        result[p] = {char = charIdx, variant = variant }
    end
    return result
end


function CharSelect.draw()
    love.graphics.setColor(0.12, 0.12, 0.16)
    love.graphics.rectangle("fill", 0, 0, C.SW, C.SH)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Selecione o personagem", 0, 40, C.SW, "center")
    love.graphics.printf("P1: A/D + Esaço       p2: Setas + 0", 0, 65, C.SW, "center")

    local boxW, boxH = 160, 160
    local spacing = 40
    local totalW = #characters * boxW + (#characters - 1) * spacing
    local startX = (C.SW - totalW)/2

    for i, c in ipairs(characters) do
        local bx = startX + (i - 1) * (boxW + spacing)
        local by = C.SH / 2 - boxH / 2


        if cursors[1] == i then
            love.graphics.setColor(0.25, 0.55, 1, confirmed[1] and 1 or 0.6)
            love.graphics.rectangle("line", bx - 4, by - 4, boxW + 8, boxH + 8, 4)
        end

        if cursors[2] == i then
            love.graphics.setColor(1, 0.3, 0.2, confirmed[2] and 1 or 0.6)
            love.graphics.rectangle("line", bx - 8, by - 8, boxW + 16, boxH + 16, 4)
        end

        
        love.graphics.setColor(1, 1, 1)
        local img = menuImgs[i]
        local scale = math.min(boxW / img:getWidth(), boxH / img:getHeight())
        local iw, ih = img:getWidth() * scale, img:getHeight() * scale
        love.graphics.draw(img, bx + (boxW - iw) / 2, by + (boxH - ih) / 2, 0, scale, scale)

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.printf(c.name, bx, by + boxH + 8, boxW, "center")
    end

    if CharSelect.isReady() then
        love.graphics.setColor(1, 0.9, 0.1)
        love.graphics.printf("Pressione R para iniciar!", 0, C.SH - 60, C.SW, "center")
    end
end

function CharSelect.reset()
    cursors = { 1, 1 }
    confirmed = { false, false }
    firstPick = {}
end

return CharSelect