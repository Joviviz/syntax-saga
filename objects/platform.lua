local Platform = {}
local Button = require("objects/button")

Platform.__index = Platform

local ActivePlatforms = {}

function Platform.new(x, y, width, height)
    local instance = setmetatable({}, Platform)
    instance.x = x
    instance.y = y
    instance.width = width
    instance.height = height

    -- Move
    instance.startY = y
    instance.targetY = y
    instance.moveSpeed = 100 --pxl persecond100

    -- Fisicas
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, x, y, "kinematic")
    instance.physics.shape = love.physics.newRectangleShape(width, height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)

    table.insert(ActivePlatforms, instance)
    return instance
end

function Platform:update()
    local boxCount = Button.getTotalBoxCount()-- count do botao
    -- mover baseado no boxcount
    self.targetY = self.startY - (boxCount * 50)

    local currentX, currentY = self.physics.body:getPosition()

    if math.abs(currentY - self.targetY) > 1 then
        local direction = self.targetY < currentY and -1 or 1
        self.physics.body:setLinearVelocity(0, direction * self.moveSpeed)
    else
        self.physics.body:setLinearVelocity(0, 0)
    end
end

function Platform:draw()
    love.graphics.setColor(0.5, 0.5, 0.8)
    local x, y = self.physics.body:getPosition()
    love.graphics.rectangle("fill", x - self.width / 2, y - self.height / 2, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
    
end

function Platform:updateAll(dt)
    for i, instance in ipairs(ActivePlatforms) do
        instance:update(dt)
    end
end

function Platform.drawAll()
    for i, instance in ipairs(ActivePlatforms) do
        instance:draw()
    end
end

function Platform.clearAll()
    for _, p in ipairs(ActivePlatforms) do
        if p.physics and p.physics.body then
            p.physics.body:destroy()
        end
        Platform.instances = {}
        ActivePlatforms = {}
    end
end

return Platform