local C         = require("constants")
local Player    = require("src.player")
local Collision = require("src.collision")
local UI        = require("src.ui")
local AI = require("src.ai")

local players

local function reset()
    --inicia carregando os sprites 
    players = {
        Player.new(
        160,
        C.GROUND_Y,
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
        C.GROUND_Y,
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

    players[2].isBot = true


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

    local width, height = love.window.getDesktopDimensions()

    love.window.setMode(0, 0, {
    fullscreen = true,
    fullscreentype = "desktop"
})
C.SW = width
C.SH = height

    reset()
end

function love.update(dt)
    if players[1].hp <= 0 or players[2].hp <= 0 then return end
    for _, p in ipairs(players) do

    if p.isBot then
        AI.update(p, players[1], dt)
    end

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

    if key == players[1].keys.up then
        Player.jump(players[1])
    end

    if key == players[2].keys.up then
        Player.jump(players[2])
    end

    if key == players[1].keys.down then
        Player.parry(players[1])
    end

    if key == players[2].keys.down then
        Player.parry(players[2])
    end

    if key == "r" then 
        reset() 
        end

    if key == "escape" then 
        love.event.quit() 
        end
end
