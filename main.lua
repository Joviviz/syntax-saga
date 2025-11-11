if arg[2] == "debug" then
    require("lldebugger").start()
end

local STI = require("sti")
require("player")
require("coin")
require("gui")
require("spike")
require("box")
require("button")
require("platform")
local Menu = require("menu")

love.graphics.setDefaultFilter("nearest", "nearest")

gameState = "menu"
Map = nil
World = nil
background = nil

function loadGame()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background = love.graphics.newImage("assets/background.png")

    Player:load()
    GUI:load()
    Box.load()

    Spike.scale = 0.2
    Spike.new(75, 327)
    Spike.new(100, 327)
    Spike.new(125, 327)

    Box.new(225, 327)
    Box.new(275, 327)

    Coin.new(10, 300)
    Coin.new(30, 300)
    Coin.new(50, 300)

    Button.new(480, 360, 64, 16)

    Platform.new(560, 330, 64, 16)
end

function love.load()
    background = love.graphics.newImage("assets/background.png")
    Menu.load()
end

function love.update(dt)
    if gameState == "game" then
        World:update(dt)
        Player:update(dt)
        Coin.updateAll(dt)
        Box.updateAll(dt)
        Spike.updateAll(dt)
        Button.updateAll(dt)
        Platform:updateAll(dt)
        GUI.update(dt)
    end
end

function love.draw()
    local scaleX = love.graphics.getWidth() / background:getWidth()
    local scaleY = love.graphics.getHeight() / background:getHeight()
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    if gameState == "menu" then
        Menu.draw()
    elseif gameState == "game" then
        Map:draw(0, 0, 2, 2)
        GUI:draw()

        love.graphics.push()
        love.graphics.scale(2,2)

        Player:draw()
        Coin.drawAll()
        Box.drawAll()
        Spike.drawAll()
        Button.drawAll()
        Platform.drawAll()

        love.graphics.pop()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if gameState == "game" then
        Player:jump(key)
    end
end

function love.mousepressed(x, y, button)
    if gameState == "menu" then
        local newState = Menu.mousepressed(x, y, button)
        if newState == "game" then
            gameState = "game"
            loadGame()
        end
    end
end

function beginContact(a, b, collision)
    if gameState == "game" then
        if Coin.beginContact(a, b, collision) then 
            return 
        end
        if Spike.beginContact(a, b, collision) then 
            return 
        end
        Player:beginContact(a, b, collision)
        Button.beginContact(a, b, collision)
    end
end

function endContact(a, b, collision)
    if gameState == "game" then
        Player:endContact(a, b, collision)
        Button.endContact(a, b, collision)

        Box.beginContact(a, b, collision)
    end
end