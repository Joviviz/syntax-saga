function love.load()
	player = {}
	player.x = 100
	player.y = 100
	player.speed = 3
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		player.x = player.x + player.speed
	end
	if love.keyboard.isDown("left") then
		player.x = player.x - player.speed
	end
	if love.keyboard.isDown("down") then
		player.x = player.y - player.speed
	end
	if love.keyboard.isDown("up") then
		player.x = player.y + player.speed
	end
end

function love.draw()
	love.graphics.circle("fill", player.x, player.y, 100)
end