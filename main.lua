local C         = require("constants")
local Player    = require("src.player")
local Collision = require("src.collision")
local UI        = require("src.ui")
local Effects   = require("src.effects")
local Sounds    = require("src.sounds")

local players

local spritesDef = {
    [1] = {
        p1 = {
            right   = "src/assets/lagartorP1RI.png",
            walkR   = "src/assets/lagartorP1R.png",
            attackR = "src/assets/lagartorP1RA.png",
            left    = "src/assets/lagartorP1LI.png",
            walkL   = "src/assets/lagartorP1L.png",
            attackL = "src/assets/lagartorP1LA.png",
            deathR  = "src/assets/lagartorP1RDeath.png",
            deathL  = "src/assets/lagartorP1LDeath.png",
        },
        p2 = {
            right   = "src/assets/lagartorP2RI.png",
            walkR   = "src/assets/lagartorP2R.png",
            attackR = "src/assets/lagartorP2RA.png",
            left    = "src/assets/lagartorP2LI.png",
            walkL   = "src/assets/lagartorP2L.png",
            attackL = "src/assets/lagartorP2LA.png",
            deathR  = "src/assets/lagartorDeathP2R.png",
            deathL  = "src/assets/lagartorDeathP2L.png",
        },
    },
    [2] = {
        p1 = {
            right   = "src/assets/LadyKateP1R.png",
            left    = "src/assets/LadyKateP1L.png",
            walkR   = "src/assets/LadyKateP1RW.png",
            walkL   = "src/assets/LadyKateP1LW.png",
            attackR = "src/assets/LadyKateP1RA.png",
            attackL = "src/assets/LadyKateP1LA.png",
            deathR  = "src/assets/LadyKateDeathP1R.png",
            deathL  = "src/assets/LadyKateDeathP1L.png",
        },
        p2 = {
            right   = "src/assets/LadyKateP2R.png",
            left    = "src/assets/LadyKateP2L.png",
            walkR   = "src/assets/LadyKateP2RW.png",
            walkL   = "src/assets/LadyKateP2LW.png",
            attackR = "src/assets/LadyKateP2RA.png",
            attackL = "src/assets/LadyKateP2LA.png",
            deathR  = "src/assets/LadyKateDeathP2R.png",
            deathL  = "src/assets/LadyKateDeathP2L.png",
        },
    },
    [3] = {
        p1 = {
            right   = "src/assets/ratitoP1R.png",
            left    = "src/assets/ratitoP1L.png",
            walkR   = "src/assets/ratitoP1RW.png",
            walkL   = "src/assets/ratitoP1LW.png",
            attackR = "src/assets/ratitoP1RA.png",
            attackL = "src/assets/ratitoP1LA.png",
            deathR  = "src/assets/ratitoP1RDeath.png",
            deathL  = "src/assets/ratitoP1LDeath.png",
        },
        p2 = {
            right   = "src/assets/ratitoP2R.png",
            left    = "src/assets/ratitoP2L.png",
            walkR   = "src/assets/ratitoP2RW.png",
            walkL   = "src/assets/ratitoP2LW.png",
            attackR = "src/assets/ratitoP2RA.png",
            attackL = "src/assets/ratitoP2LA.png",
            deathR  = "src/assets/ratitoP2RDeath.png",
            deathL  = "src/assets/ratitoP2LDeath.png",
        },
    },
}

local background
local CharSelect = require("src.charselect")
local gameState  = "select"

function love.load()
    love.window.setTitle("Jogo")
    love.window.setMode(C.SW, C.SH, {resizable=false})
    background = love.graphics.newImage("src/assets/parallax-forest-back-trees-1.png.png")
    Sounds.load()
    CharSelect.load()
end

local function loadSprites(def)
    local s = {}
    for k, path in pairs(def) do
        s[k] = love.graphics.newImage(path)
    end
    return s
end

local function reset(choices)
    players = {
        Player.new(160, C.SH/2 - C.PH/2, {0.25,0.55,1}, {left="a",right="d",up="w",down="s",attack="space"}),
        Player.new(C.SW-160-C.PW, C.SH/2 - C.PH/2, {1,0.3,0.2}, {left="left",right="right",up="up",down="down",attack="0"}),
    }
    players[2].facing = "left"
    if choices then
        players[1].sprites = loadSprites(spritesDef[choices[1].char][choices[1].variant])
        players[2].sprites = loadSprites(spritesDef[choices[2].char][choices[2].variant])
    end
end

function love.update(dt)
    if gameState ~= "game" then return end
    Effects.update(dt)
    if players[1].hp <= 0 or players[2].hp <= 0 then return end
    for _, p in ipairs(players) do
        Player.update(p, dt)
    end
    Collision.applyDamage(players[1], players[2])
end

function love.draw()
    if gameState == "select" then
        CharSelect.draw()
        return
    end

    local ox, oy = Effects.getShakeOffset()
    love.graphics.push()
    love.graphics.translate(ox, oy)

    UI.drawBackground(background)
    for i, p in ipairs(players) do
        UI.drawStickman(p)
        UI.drawHPBar(p, i)
    end
    UI.drawHints()
    Effects.draw()
    UI.drawGameOver(players)

    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
    if gameState == "select" then
        CharSelect.keypressed(key)
        if CharSelect.isReady() then
            local choices = CharSelect.getChoices()
            reset(choices)
            gameState = "game"
        end
        return
    end

    if key == players[1].keys.attack then Player.attack(players[1]) end
    if key == players[2].keys.attack then Player.attack(players[2]) end
    if key == "r" then
        gameState = "select"
        CharSelect.reset()
    end
    if key == "escape" then love.event.quit() end
end
