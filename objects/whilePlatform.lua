local WhilePlatform = {}
local Button = require("objects/button")

WhilePlatform.__index = WhilePlatform

local ActiveWhilePlatforms = {}

function WhilePlatform.new(x, y, width, height, distance)
    local instance = setmetatable({}, WhilePlatform)
    instance.x = x
    instance.y = y
    instance.width = width
    instance.height = height

    -- Movimento
    instance.startX = x
    instance.endX = x + distance
    instance.direction = 1

    -- Velocidade
    instance.baseSpeed = 50
    instance.speedPerBox = 150

    -- Fisicas
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, x, y, "kinematic")
    instance.physics.shape = love.physics.newRectangleShape(width, height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setFriction(1)

    table.insert(ActiveWhilePlatforms, instance)
    return instance
end

function WhilePlatform:update(dt)
    local boxCount = Button.getTotalBoxCount() -- count do botao

    -- velocidade atual baseado nas caixa
    local currentSpeed = self.baseSpeed + (boxCount * self.speedPerBox)

    local x, y = self.physics.body:getPosition()

    -- logica de ir e voltar
    if self.direction == 1 and x >= self.endX then
        self.direction = -1                 -- pra esquerda
        self.physics.body:setX(self.endX)   -- limite
    elseif self.direction == -1 and x <= self.startX then
        self.direction = 1                  -- pra direitcha
        self.physics.body:setX(self.startX) -- limite
    end

    self.physics.body:setLinearVelocity(currentSpeed * self.direction, 0)
end

function WhilePlatform:draw()
    love.graphics.setColor(0.8, 0.5, 0.2)
    local x, y = self.physics.body:getPosition()
    love.graphics.rectangle("fill", x - self.width / 2, y - self.height / 2, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

function WhilePlatform.updateAll(dt)
    for i, instance in ipairs(ActiveWhilePlatforms) do
        instance:update(dt)
    end
end

function WhilePlatform.drawAll()
    for i, instance in ipairs(ActiveWhilePlatforms) do
        instance:draw()
    end
end

function WhilePlatform.clearAll()
    for _, instance in ipairs(ActiveWhilePlatforms) do
        if instance.physics.body then
            instance.physics.body:destroy()
        end
    end
    ActiveWhilePlatforms = {}
end

return WhilePlatform
