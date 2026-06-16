local C         = require("constants")
local Player    = require("src.player")
local Collision = require("src.collision")
local UI        = require("src.ui")

local players

local function reset()
    --inicia carregando os sprites 
    players = {
        Player.new(
        160,
        C.SH/2 - C.PH/2, 
        {0.25, 0.55, 1},
        {
            left="a", 
            right="d", 
            up="w", 
            down="s",
            attack ="space",
        }
    ),
        Player.new(
        C.SW - 160 - C.PW, 
        C.SH/2 - C.PH/2, 
        {1, 0.3, 0.2},
        {
            left="left", 
            right="right", 
            up="up",  
            down="down",
            attack="0"
        }
    ),
    }
    players[1].sprites = {
    left      = love.graphics.newImage("src/assets/lagartorP1LI.png"),
    right      = love.graphics.newImage("src/assets/lagartorP1RI.png"),
    attackR   = love.graphics.newImage("src/assets/lagartorP1RA.png"),
    attackL   = love.graphics.newImage("src/assets/lagartorP1LA.png"),
    walkR = love.graphics.newImage("src/assets/lagartorP1R.png"),
    walkL = love.graphics.newImage("src/assets/lagartorP1L.png"),
}
players[2].facing = "left"
 players[2].sprites = {
    left = love.graphics.newImage("src/assets/lagartorP2LI.png"),
    right = love.graphics.newImage("src/assets/lagartorP2RI.png"),
    attackR = love.graphics.newImage("src/assets/lagartorP2RA.png"),
    attackL = love.graphics.newImage("src/assets/lagartorP2LA.png"),
    walkR = love.graphics.newImage("src/assets/lagartorP2R.png"),
    walkL = love.graphics.newImage("src/assets/lagartorP2L.png"),
    
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
    if key == players[1].keys.attack then
    Player.attack(players[1])    
    end    
    

    if key == players[2].keys.attack then
        Player.attack(players[2])
    end

    if key == "r" then 
        reset() 
        end

    if key == "escape" then 
        love.event.quit() 
        end
end
