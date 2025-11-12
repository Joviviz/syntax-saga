Flag = { img = love.graphics.newImage("assets/flag.png") }
Flag.__index = Flag
Flag.width = Flag.img:getWidth()
Flag.height = Flag.img:getHeight()

ActiveFlags = {}

function Flag.new(x, y)
    local instance = setmetatable({}, Flag)
    instance.x = x
    instance.y = y

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(Flag.width, Flag.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(ActiveFlags, instance)
end

function Flag.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveFlags) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                return true
            end
        end
    end
    return false
end

function Flag.drawAll()
    for i, instance in ipairs(ActiveFlags) do
        love.graphics.draw(Flag.img, instance.x, instance.y)
    end
end