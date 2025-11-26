local Flag = { img = love.graphics.newImage("assets/flag.png") }
Flag.__index = Flag
Flag.width = Flag.img:getWidth()
Flag.height = Flag.img:getHeight()

local ActiveFlags = {}
local Player = require("player")

function Flag.new(x, y)
    local instance = setmetatable({}, Flag)
    instance.x = x
    instance.y = y

    local scaledWidth = Flag.width * Flag.scale
    local scaledHeight = Flag.height * Flag.scale

    instance.physics={}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(scaledWidth, scaledHeight)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(ActiveFlags, instance)
    
end

function Flag:update(dt)
end

function Flag:updateAll(dt)
    for i, instance in ipairs(ActiveFlags) do
        instance:update(dt)
    end
end

function Flag:drawAll()
    for i, instance in ipairs(ActiveFlags) do
        instance:draw()
    end
end

function Flag:clearAll()
    for _, instance in ipairs(ActiveFlags) do
        if instance.physics and instance.physics.body then
            instance.physics.body:destroy()
        end
        Flag.instances = {}
        ActiveFlags = {}
    end
end

function Flag.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveFlags) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:changeLevel()
                return true
            end
        end        
    end
    
end


return Flag