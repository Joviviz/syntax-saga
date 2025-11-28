local Platform2 = {}
Platform2.__index = Platform2

local Button = require("objects/button")
local Button2 = require("objects/button2")

local ActivePlatforms2 = {}

function Platform2.new(x, y, width, height)
    local obj = setmetatable({}, Platform2)

    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height

    obj.startY = y
    obj.targetY = y
    obj.moveSpeed = 100

    obj.physics = {
        body = love.physics.newBody(World, x, y, "kinematic"),
    }
    obj.physics.shape = love.physics.newRectangleShape(width, height)
    obj.physics.fixture = love.physics.newFixture(obj.physics.body, obj.physics.shape)

    table.insert(ActivePlatforms2, obj)
    return obj
end

function Platform2:update()
    local normalCount = Button.getTotalBoxCount()
    local secondaryCount = Button2.getTotalBoxCount()

    if normalCount == 1 and secondaryCount == 1 then
        self.targetY = self.startY - 100
    else
        self.targetY = self.startY
    end
    
    local _, y = self.physics.body:getPosition()
    if math.abs(y - self.targetY) > 1 then
        local direction = (self.targetY < y) and -1 or 1
        self.physics.body:setLinearVelocity(0, direction * self.moveSpeed)
    else
        self.physics.body:setLinearVelocity(0, 0)
    end
end



function Platform2.updateAll(dt)
    for _, p in ipairs(ActivePlatforms2) do
        p:update(dt)
    end
end

function Platform2.drawAll()
    love.graphics.setColor(0.3, 0.8, 0.3)
    for _, p in ipairs(ActivePlatforms2) do
        local x, y = p.physics.body:getPosition()
        love.graphics.rectangle("fill", x - p.width/2, y - p.height/2, p.width, p.height)
    end
    love.graphics.setColor(1,1,1)
end

function Platform2.clearAll()
    for _, p in ipairs(ActivePlatforms2) do
        if p.physics and p.physics.body then
            p.physics.body:destroy()
        end
    end
    ActivePlatforms2 = {}
end


return Platform2
