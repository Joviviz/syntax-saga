if arg[2] == "debug" then
    require("lldebugger").start()
end

local STI = require("sti")
local Menu = require("menu")
local GUI = require("gui")
local Camera = require("camera")


local Player = require("player")
local Coin = require("objects/coin")
local Spike = require("objects/spike")
local Box = require("objects/box")
local Button = require("objects/button")
local Platform = require("objects/platform")
local Flag = require("objects/flag")

love.graphics.setDefaultFilter("nearest", "nearest")

gameState = "menu"
Map = nil
World = nil
background = nil

function loadLevel(fase)
    Map = STI(fase.mapPath, {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
	Spike.scale = 0.2

    Player:load()
    GUI:load()

    background = love.graphics.newImage("assets/background.png")

    for _, s in ipairs(fase.spikes) do
        Spike.new(s.x, s.y)
    end
    for _, b in ipairs(fase.boxes) do
        Box.new(b.x, b.y)
    end
    for _, c in ipairs(fase.coins) do
        Coin.new(c.x, c.y)
    end
    for _, p in ipairs(fase.platforms) do
        Platform.new(p.x, p.y, p.w, p.h)
    end
    for _, bt in ipairs(fase.buttons) do
        Button.new(bt.x, bt.y, bt.w, bt.h)
    end
end

function love.load()
    background = love.graphics.newImage("assets/background.png")
    Menu.load()
end

function love.update(dt)
    if gameState ~= "menu" then
        World:update(dt)
        Player:update(dt)
        Coin.updateAll(dt)
        Box.updateAll(dt)
        Spike.updateAll(dt)
        Button.updateAll(dt)
        GUI.update(dt)
        Platform.updateAll(dt)
        -- Camera:setPosition(Player.x, 0)
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
		-- Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
		GUI:draw()

		love.graphics.push()
		love.graphics.scale(2,2)

		-- Camera:apply()

		Player:draw()
		Coin.drawAll()
		Box.drawAll()
		Spike.drawAll()
		Button.drawAll()
		Platform.drawAll()

		-- Camera:reset()

		love.graphics.pop()
	end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if gameState ~= "menu" then
        Player:jump(key)
    end
end

function love.mousepressed(x, y, button)
    if gameState == "menu" then
        local newState = Menu.mousepressed(x, y, button)
        if newState == "fase1" then
            local fase1 = require("fases.fase1")
            loadLevel(fase1)
            gameState = "fase1"
        elseif newState == "fase2" then
            local fase2 = require("fases.fase2")
            loadLevel(fase2)
            gameState = "fase2"
        end
    end
end

function beginContact(a, b, collision)
    if gameState ~= "menu" then
        if Coin.beginContact(a, b, collision) then return end
        if Spike.beginContact(a, b, collision) then return end
        Player:beginContact(a, b, collision)
        Button.beginContact(a, b, collision)
    end
end

function endContact(a, b, collision)
    if gameState ~= "menu" then
        Player:endContact(a, b, collision)
        Button.endContact(a, b, collision)
    end
end
