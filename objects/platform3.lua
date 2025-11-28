local Platform3 = {}
Platform3.__index = Platform3

local Button = require("objects/button")
local Button2 = require("objects/button2")

local ActivePlatforms3 = {}

function Platform3.new(x, y, width, height)
    local obj = setmetatable({}, Platform3)

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

    table.insert(ActivePlatforms3, obj)
    return obj
end

function Platform3:update()
    local normalCount = Button.getTotalBoxCount()
    local secondaryCount = Button2.getTotalBoxCount()

    -- XOR: sobe se apenas UM estiver ativo
    local exactlyOneActive = (normalCount == 1 and secondaryCount == 0)
                        or (normalCount == 0 and secondaryCount == 1)

    if exactlyOneActive then
        self.targetY = self.startY - 100
    else
        self.targetY = self.startY
    end

    local _, y = self.physics.body:getPosition()
    if math.abs(y - self.targetY) > 1 then
        local dir = (self.targetY < y) and -1 or 1
        self.physics.body:setLinearVelocity(0, dir * self.moveSpeed)
    else
        self.physics.body:setLinearVelocity(0, 0)
    end
end

function Platform3.updateAll(dt)
    for _, p in ipairs(ActivePlatforms3) do
        p:update(dt)
    end
end

function Platform3.drawAll()
    love.graphics.setColor(1, 0.5, 0)
    for _, p in ipairs(ActivePlatforms3) do
        local x, y = p.physics.body:getPosition()
        love.graphics.rectangle("fill", x - p.width/2, y - p.height/2, p.width, p.height)
    end
    love.graphics.setColor(1,1,1)
end

function Platform3.clearAll()
    for _, p in ipairs(ActivePlatforms3) do
        if p.physics.body then p.physics.body:destroy() end
    end
    ActivePlatforms3 = {}
end

return Platform3
