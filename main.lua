if arg[2] == "debug" then
    require("lldebugger").start()
end

local STI = require("sti")
require("player")
require("coin")
require("gui")
require("spike")
require("box")

-- Fix blurry sprites
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	Map = STI("map/1.lua", {"box2d"})
	World = love.physics.newWorld(0,0)
	World:setCallbacks(beginContact, endContact)
	Map:box2d_init(World)
	Map.layers.solid.visible = false
	background = love.graphics.newImage("assets/background.png")

	Player:load()
	GUI:load()

	Box.new(350, 330)
	Box.new(450, 330)

	Coin.new(300, 200)
	Coin.new(400, 200)
	Coin.new(500, 100)
	Spike.new(500, 200)

end

function love.update(dt)
	World:update(dt)
	Player:update(dt)
	Coin.updateAll(dt)
	Spike.updateAll(dt)
	GUI.update(dt)
	Box.updateAll(dt)
end

function love.draw()
	love.graphics.draw(background)
	Map:draw(0, 0, 2, 2)

	love.graphics.push()
	love.graphics.scale(2,2)

	Player:draw()
	Box.drawAll()
	Coin.drawAll()
	Spike.drawAll()
	
	love.graphics.pop()
	GUI:draw()
end

function love.keypressed(key)
	Player:jump(key)
end


-- These two are all good the problem is in player.lua
-- A ORDEM DAS LINHAS EH ESSENCIAL NESSE CODIGO NAO MUDA PORFAVO
function beginContact(a, b, collision)
	-- Collect coin before player begins contact
	if Coin.beginContact(a, b, collision) then 
		return 
	end
	-- Dies before
	if Spike.beginContact(a, b, collision) then 
		return 
	end
		
	Player:beginContact(a, b, collision)
end


function endContact(a, b, collision)
	Player:endContact(a, b, collision)
end