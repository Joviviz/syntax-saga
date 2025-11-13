Flag = { img = love.graphics.newImage("assets/flag.png") }
Flag.__index = Flag
Flag.width = Flag.img:getWidth()
Flag.height = Flag.img:getHeight()

ActiveFlags = {}

-- function Flag.new(x, y)
--     local instance = setmetatable({}, Flag)
--     instance.x = x
--     instance.y = y

--     -- Interacao com o jogador
--     instance.physics = {}
--     instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
--     instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
--     instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
--     instance.physics.fixture:setSensor(true)
--     instance.toBeRemoved = false

    