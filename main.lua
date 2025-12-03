if arg[2] == "debug" then
	require("lldebugger").start()
end

local STI = require("sti")
local Menu = require("menu")
local GUI = require("gui")


local Player = require("player")
local Box = require("objects/box")
local Button = require("objects/button")
local Button2 = require("objects/button2")
local Coin = require("objects/coin")
local Flag = require("objects/flag")
local Platform = require("objects/platform")
local Platform2 = require("objects/platform2")
local Platform3 = require("objects/platform3")
local Spike = require("objects/spike")
local WhilePlatform = require("objects/whilePlatform")

love.graphics.setDefaultFilter("nearest", "nearest")

gameState = "menu"
Map = nil
World = nil
background = nil

function loadLevel(level)
    Map = STI(level.mapPath, { "box2d" })
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    Spike.scale = 0.2

    Player:load()
    GUI:load()

    background = love.graphics.newImage("assets/background.png")

    if level.spikes then
        for _, s in ipairs(level.spikes) do
            Spike.new(s.x, s.y)
        end
    end
    if level.boxes then
        for _, b in ipairs(level.boxes) do
            Box.new(b.x, b.y)
        end
    end
    if level.coins then
        for _, c in ipairs(level.coins) do
            Coin.new(c.x, c.y)
        end
    end
    if level.platforms then
        for _, p in ipairs(level.platforms) do
            Platform.new(p.x, p.y, p.w, p.h)
        end
    end
    if level.buttons then
        for _, bt in ipairs(level.buttons) do
            Button.new(bt.x, bt.y, bt.w, bt.h)
        end
    end
    if level.buttons2 and type(level.buttons2) == "table" then
        for _, bt in ipairs(level.buttons2) do
            Button2.new(bt.x, bt.y, bt.w, bt.h)
        end
    end
    if level.platforms2 and type(level.platforms2) == "table" then
        for _, p in ipairs(level.platforms2) do
            Platform2.new(p.x, p.y, p.w, p.h)
        end
    end
	if level.platforms3 then
		for _, p in ipairs(level.platforms3) do
			Platform3.new(p.x, p.y, p.w, p.h)
		end
	end
	for _, f in ipairs(level.flag) do
		Flag.new(f.x, f.y)
	end
	if level.whilePlatforms then
		for _, wp in ipairs(level.whilePlatforms) do
			WhilePlatform.new(wp.x, wp.y, wp.w, wp.h, wp.dist)
		end
	end
    if level.flag then
        for _, f in ipairs(level.flag) do
            Flag.new(f.x, f.y)
        end
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
		if Player:getY() > 400 then
    		Player:die()
		end
		if Player:getX() < -20 then
    		Player:die()
		end
		Coin.updateAll(dt)
		Box.updateAll(dt)
		Spike.updateAll(dt)
		Flag.updateAll(dt)
		Button.updateAll(dt)
		Button2.updateAll(dt)
		Platform2.updateAll(dt)
		Platform3.updateAll(dt)
		GUI.update(dt)
		Platform.updateAll(dt)
		WhilePlatform.updateAll(dt)


		-- Bloco de Resetar a fase 
        if not Player.alive then
            -- 1. montar caminho pra folder do level
            local levelPath = "levels." .. gameState 
            
            -- 2. requerir o levelPath
            local levelData = require(levelPath)
            
            -- 3. limpar
            clearLevel()
            loadLevel(levelData)
            
            -- 4. loadLevel() chama Player:load(), que alive = true
        end

		-- Avancar fase
		if Player.levelFinished then

			-- descobrir nmr da fase
			local currentLevelNumber = tonumber(string.match(gameState, "%d+"))

			-- proxima fase
			local nextLevelNumber = currentLevelNumber + 1

			if nextLevelNumber <= 5 then
				local nextLevelName = "level" .. nextLevelNumber
				local nextLevelPath = "levels." .. nextLevelName

				-- carregar proxima fase
				local levelData = require(nextLevelPath)
				gameState = nextLevelName

				clearLevel()
				loadLevel(levelData)
			else
				gameState = "menu"
				clearLevel()
			end
		end
	end
end

function love.draw()
	local scaleX = love.graphics.getWidth() / background:getWidth()
	local scaleY = love.graphics.getHeight() / background:getHeight()
	love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

	if gameState == "menu" then
		Menu.draw()
	else
		Map:draw(0, 0, 2, 2)
		GUI:draw()
		love.graphics.push()
		love.graphics.scale(2, 2)
		Player:draw()
		Coin.drawAll()
		Box.drawAll()
		Spike.drawAll()
		Flag.drawAll()
		Button.drawAll()
		Platform.drawAll()
		WhilePlatform.drawAll()
		Button2.drawAll()
		Platform2.drawAll()
		Platform3.drawAll()
		love.graphics.pop()
	end
end

function love.keypressed(key)
	if key == "escape" then
		gameState = "menu"
		clearLevel()
	end

	if key == "r" then
		Player:die()
	end

	if gameState ~= "menu" then
		Player:jump(key)
	end
end

function love.mousepressed(x, y, button)
	if gameState == "menu" then
		local newState = Menu.mousepressed(x, y, button)

		if newState and newState:match("^level[1-5]$") then
			local level = require("levels." .. newState)
			clearLevel()
			loadLevel(level)
			gameState = newState
		end
	end
end

function beginContact(a, b, collision)
    if gameState == "menu" then return end

    if Coin.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end
    if Flag.beginContact and Flag.beginContact(a, b, collision) then return end

    if Button and Button.beginContact then Button.beginContact(a, b, collision) end
    if Button2 and Button2.beginContact then Button2.beginContact(a, b, collision) end

    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    if gameState == "menu" then return end

    Player:endContact(a, b, collision)

    if Button and Button.endContact then Button.endContact(a, b, collision) end
    if Button2 and Button2.endContact then Button2.endContact(a, b, collision) end
end



function clearLevel()
	Spike.clearAll()
	Box.clearAll()
	Coin.clearAll()
	Platform.clearAll()
	WhilePlatform.clearAll()
	Button.clearAll()
	Button2.clearAll()
	Platform2.clearAll()
	Platform3.clearAll()
	Flag.clearAll()
end
