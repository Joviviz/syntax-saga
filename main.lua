if arg[2] == "debug" then
    require("lldebugger").start()
end

local STI = require("sti")
require("player")
local Coin = require("objects/coin")
local GUI = require("gui")
local Spike = require("objects/spike")
local Box = require("objects/box")
local Button = require("objects/button")
local Platform = require("objects/platform")
local Flag = require("objects/flag")
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

	Spike.scale = 0.2
	Spike.new(220, 327)
	Spike.new(195, 327)
	Spike.new(170, 327)

	-- Box.new(350, 330)
	-- Box.new(450, 330)
	Box.new(510, 35)
	Box.new(600, 35)

	Coin.new(300, 200)
	Coin.new(400, 200)
	Coin.new(500, 100)

	-- x, y, width, height
	Platform.new(600, 200, 100, 16)

	local buttonWidth = 64
	local buttonHeight = 16
	local buttonX = 540 
	local buttonY = 328 
	Button.new(buttonX, buttonY, buttonWidth, buttonHeight)
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
		GUI.update(dt)
		Platform.updateAll(dt)
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

-- These two are all good the problem is in player.lua
-- A ORDEM DAS LINHAS EH ESSENCIAL NESSE CODIGO NAO MUDA PORFAVO
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
	end
end
