local C         = require("constants")
local Player    = require("src.player")
local Collision = require("src.collision")
local UI        = require("src.ui")

local players

local function reset()
    players = {
        Player.new(160, C.SH/2 - C.PH/2, {0.25, 0.55, 1},
            {left="a", right="d", up="w", down="s"}),
        Player.new(C.SW - 160 - C.PW, C.SH/2 - C.PH/2, {1, 0.3, 0.2},
            {left="left", right="right", up="up", down="down"}),
    }
end

function love.load()
    love.window.setTitle("Jogo")
    love.window.setMode(C.SW, C.SH, {resizable=false})
    reset()
end

function love.update(dt)
    if players[1].hp <= 0 or players[2].hp <= 0 then return end
    for _, p in ipairs(players) do
        Player.update(p, dt)
    end
    Collision.applyDamage(players[1], players[2])
end

function love.draw()
    UI.drawBackground()
    for i, p in ipairs(players) do
        UI.drawStickman(p)
        UI.drawHPBar(p, i)
    end
    UI.drawHints()
    UI.drawGameOver(players)
    love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
    if key == "r" then reset() end
    if key == "escape" then love.event.quit() end
end
