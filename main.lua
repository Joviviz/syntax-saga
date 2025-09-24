local STI = require("sti")

function love.load()
	Map = STI("map/1.lua", {"box2d"})
	World = love.physics.newWorld(0,0)
	Map:box2d_init(World)
	Map.layers.solid.visible = false
	background = love.graphics.newImage("assets/background.png")

	player = {}
	player.x = 100
	player.y = 100
	player.speed = 3
end

function love.update(dt)
	World:update(dt)

	if love.keyboard.isDown("right") then
		player.x = player.x + player.speed
	end
	if love.keyboard.isDown("left") then
		player.x = player.x - player.speed
	end
	if love.keyboard.isDown("down") then
		player.y = player.y + player.speed
	end
	if love.keyboard.isDown("up") then
		player.y = player.y - player.speed
	end
end

function love.draw()
	love.graphics.draw(background)
	Map:draw(0, 0, 2, 2)
	love.graphics.push()
	love.graphics.scale(2,2)
	love.graphics.pop()

	love.graphics.circle("fill", player.x, player.y, 100)
end