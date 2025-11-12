if arg[2] == "debug" then
    require("lldebugger").start()
end

local STI = require("sti")
require("player")
require("objects/coin")
require("gui")
require("objects/spike")
require("objects/box")
require("objects/button")
require("objects/platform")
require("objects/flag")
local Menu = require("menu")
local GameStateManager = require("gameStateManager")

love.graphics.setDefaultFilter("nearest", "nearest")

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

	GameStateManager:loadPhase(1)

	-- Spike.scale = 0.2
	-- Spike.new(220, 327)
	-- Spike.new(195, 327)
	-- Spike.new(170, 327)

	-- -- Box.new(350, 330)
	-- -- Box.new(450, 330)
	-- Box.new(510, 35)
	-- Box.new(600, 35)

	-- Coin.new(300, 200)
	-- Coin.new(400, 200)
	-- Coin.new(500, 100)

	-- -- x, y, width, height
	-- Platform.new(600, 200, 100, 16)

	-- local buttonWidth = 64
	-- local buttonHeight = 16
	-- local buttonX = 540 
	-- local buttonY = 328 
	-- Button.new(buttonX, buttonY, buttonWidth, buttonHeight)
end

function love.load()
	background = love.graphics.newImage("assets/background.png")
	GameStateManager:init()
	Menu.load()
end

function love.update(dt)
	if GameStateManager:getState() == "game" then
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

	local state = GameStateManager:getState()

	if state == "menu" then
		Menu.draw()
	elseif state == "game" then
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

	elseif state == "phaseComplete" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Fase " .. GameStateManager.currentPhase .. " Completa!", 0, 300, love.graphics.getWidth(), "center")
        love.graphics.printf("Clique para continuar", 0, 350, love.graphics.getWidth(), "center")
    
	elseif state == "gameWon" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Você venceu!", 0, 300, love.graphics.getWidth(), "center")
    
	elseif state == "gameOver" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Game Over!", 0, 300, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	if GameStateManager:getState() == "game" then
		Player:jump(key)
	end
end

function love.mousepressed(x, y, button)
	local state = GameStateManager:getState()

	if state == "menu" then
		local newState = Menu.mousepressed(x, y, button)

		if newState == "game" then
			loadGame()
		end
	elseif state == "phaseComplete" then
        GameStateManager:nextPhase()
	end
end

-- These two are all good the problem is in player.lua
-- A ORDEM DAS LINHAS EH ESSENCIAL NESSE CODIGO NAO MUDA PORFAVO
function beginContact(a, b, collision)
	local state = GameStateManager:getState()
	if state == "game" then
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
	local state = GameStateManager:getState()
	if state == "game" then
		Player:endContact(a, b, collision)
		Button.endContact(a, b, collision)
	end
end
