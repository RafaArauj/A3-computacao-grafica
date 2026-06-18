local C         = require("constants")
local Player    = require("src.player")
local Collision = require("src.collision")
local UI        = require("src.ui")
local Effects   = require("src.effects")
local Sounds    = require("src.sounds")
local AI        = require("src.ai")

local players
local gameMode = 1

local spritesDef = {
    [1] = {
        p1 = {
            right    = "src/assets/lagartorP1RI.png",
            walkR    = "src/assets/lagartorP1R.png",
            attackR  = "src/assets/lagartorP1RA.png",
            left     = "src/assets/lagartorP1LI.png",
            walkL    = "src/assets/lagartorP1L.png",
            attackL  = "src/assets/lagartorP1LA.png",
            deathR   = "src/assets/lagartorP1RDeath.png",
            deathL   = "src/assets/lagartorP1LDeath.png",
            defenseR = "src/assets/lagartorP1RD.png",
            defenseL = "src/assets/lagartorP1LD.png",
        },
        p2 = {
            right    = "src/assets/lagartorP2RI.png",
            walkR    = "src/assets/lagartorP2R.png",
            attackR  = "src/assets/lagartorP2RA.png",
            left     = "src/assets/lagartorP2LI.png",
            walkL    = "src/assets/lagartorP2L.png",
            attackL  = "src/assets/lagartorP2LA.png",
            deathR   = "src/assets/lagartorDeathP2R.png",
            deathL   = "src/assets/lagartorDeathP2L.png",
            defenseR = "src/assets/lagartorP2RD.png",
            defenseL = "src/assets/lagartorP2LD.png",
        },
    },
    [2] = {
        p1 = {
            right    = "src/assets/LadyKateP1R.png",
            left     = "src/assets/LadyKateP1L.png",
            walkR    = "src/assets/LadyKateP1RW.png",
            walkL    = "src/assets/LadyKateP1LW.png",
            attackR  = "src/assets/LadyKateP1RA.png",
            attackL  = "src/assets/LadyKateP1LA.png",
            deathR   = "src/assets/LadyKateDeathP1R.png",
            deathL   = "src/assets/LadyKateDeathP1L.png",
            defenseR = "src/assets/LadyKateP1RD.png",
            defenseL = "src/assets/LadyKateP1LD.png",
        },
        p2 = {
            right    = "src/assets/LadyKateP2R.png",
            left     = "src/assets/LadyKateP2L.png",
            walkR    = "src/assets/LadyKateP2RW.png",
            walkL    = "src/assets/LadyKateP2LW.png",
            attackR  = "src/assets/LadyKateP2RA.png",
            attackL  = "src/assets/LadyKateP2LA.png",
            deathR   = "src/assets/LadyKateDeathP2R.png",
            deathL   = "src/assets/LadyKateDeathP2L.png",
            defenseR = "src/assets/LadyKateP2RD.png",
            defenseL = "src/assets/LadyKateP2LD.png",
        },
    },
    [3] = {
        p1 = {
            right    = "src/assets/ratitoP1R.png",
            left     = "src/assets/ratitoP1L.png",
            walkR    = "src/assets/ratitoP1RW.png",
            walkL    = "src/assets/ratitoP1LW.png",
            attackR  = "src/assets/ratitoP1RA.png",
            attackL  = "src/assets/ratitoP1LA.png",
            deathR   = "src/assets/ratitoP1RDeath.png",
            deathL   = "src/assets/ratitoP1LDeath.png",
            defenseR = "src/assets/ratitoP1RD.png",
            defenseL = "src/assets/ratitoP1LD.png",
        },
        p2 = {
            right    = "src/assets/ratitoP2R.png",
            left     = "src/assets/ratitoP2L.png",
            walkR    = "src/assets/ratitoP2RW.png",
            walkL    = "src/assets/ratitoP2LW.png",
            attackR  = "src/assets/ratitoP2RA.png",
            attackL  = "src/assets/ratitoP2LA.png",
            deathR   = "src/assets/ratitoP2RDeath.png",
            deathL   = "src/assets/ratitoP2LDeath.png",
            defenseR = "src/assets/ratitoP2RD.png",
            defenseL = "src/assets/ratitoP2LD.png",
        },
    },
}

local background
local CharSelect = require("src.charselect")
local gameState  = "select"

function love.load()
    love.window.setTitle("Jogo")
    love.window.setMode(C.SW, C.SH, {resizable = true})
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

local function applyScreenSize()
    C.SW, C.SH = love.graphics.getDimensions()
    C.GROUND_Y = C.SH - 180
end

local function toggleFullscreen()
    local isFS = love.window.getFullscreen()
    if isFS then
        love.window.setMode(800, 600, {resizable = true})
    else
        local w, h = love.window.getDesktopDimensions()
        love.window.setMode(w, h, {fullscreen = true, fullscreentype = "desktop"})
    end
    applyScreenSize()
    if players then
        for _, p in ipairs(players) do
            p.x = math.max(0, math.min(C.SW - C.PW, p.x))
            if p.y > C.GROUND_Y then p.y = C.GROUND_Y end
        end
        players[2].x = math.max(players[1].x + C.PW + 1, players[2].x)
    end
end

local function reset(choices)
    applyScreenSize()

    players = {
        Player.new(160, C.SH / 2 - C.PH / 2, {0.25, 0.55, 1},
            {left = "a", right = "d", up = "w", down = "s", attack = "space"}),
        Player.new(C.SW - 160 - C.PW, C.SH / 2 - C.PH / 2, {1, 0.3, 0.2},
            {left = "left", right = "right", up = "up", down = "down", attack = "0"}),
    }
    players[2].facing = "left"

    if choices then
        players[1].sprites = loadSprites(spritesDef[choices[1].char][choices[1].variant])
        players[2].sprites = loadSprites(spritesDef[choices[2].char][choices[2].variant])
    end
    players[2].isBot = (gameMode == 1)
end

function love.update(dt)
    if gameState ~= "game" then return end
    Effects.update(dt)
    if players[1].hp <= 0 or players[2].hp <= 0 then return end
    for i, p in ipairs(players) do
        if p.isBot then
            local opponent = (i == 1) and players[2] or players[1]
            AI.update(p, opponent, dt)
        end
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

function love.resize(w, h)
    applyScreenSize()
    if players then
        for _, p in ipairs(players) do
            p.x = math.max(0, math.min(C.SW - C.PW, p.x))
            if p.y > C.GROUND_Y then p.y = C.GROUND_Y end
        end
    end
end

function love.keypressed(key)
    if key == "f11" then toggleFullscreen() return end

    if gameState == "select" then
        CharSelect.keypressed(key)
        if CharSelect.isP1Confirmed() and not CharSelect.isP2Active() then
            CharSelect.confirmBot()
        end
        if CharSelect.isReady() then
            gameMode = CharSelect.isP2Active() and 2 or 1
            local choices = CharSelect.getChoices()
            reset(choices)
            gameState = "game"
        end
        return
    end

    if key == players[1].keys.attack and not players[1].isBot then Player.attack(players[1]) end
    if key == players[2].keys.attack and not players[2].isBot then Player.attack(players[2]) end
    if key == players[1].keys.up     and not players[1].isBot then Player.jump(players[1])   end
    if key == players[2].keys.up     and not players[2].isBot then Player.jump(players[2])   end
    if key == players[1].keys.down   and not players[1].isBot then Player.parry(players[1])  end
    if key == players[2].keys.down   and not players[2].isBot then Player.parry(players[2])  end
    if key == "r" then
        CharSelect.reset()
        gameState = "select"
    end
    if key == "escape" then love.event.quit() end
end
