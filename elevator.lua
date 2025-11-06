Elevator = {}
Elevator.__index = Elevator
ActiveElevators = {}

function Elevator.new(x, y, width, height)
    local self = setmetatable({}, Elevator)
    
    -- Coordenadas
    self.x = x
    self.y = y
    self.startY = y      
    self.targetY = 167
    
    -- Tamanho
    self.width = width
    self.height = height
    
    -- Movimento
    self.speed = 50    
    self.state = "down"  

    -- Fisica (Kinematic)
    self.body = love.physics.newBody(World, self.x, self.y, "kinematic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Elevator")
    
    table.insert(ActiveElevators, self)
    return self
end

function Elevator:update(dt)
    
    if Button.getTotalBoxCount() == 2 then
        -- 2 caixas (verdadeiro) = Vai para cima
        if self.y > self.targetY then
            self.state = "moving_up"
            self.y = self.y - self.speed * dt
            -- Para em cima
            if self.y < self.targetY then
                self.y = self.targetY
                self.state = "up"
            end
        end
    else
        -- Menos de 2 caixas (falso) = Vai para baixo
        if self.y < self.startY then
            self.state = "moving_down"
            self.y = self.y + self.speed * dt
            -- Para embaixo
            if self.y > self.startY then
                self.y = self.startY
                self.state = "down"
            end
        end
    end

    self.body:setPosition(self.x, self.y)
end

function Elevator:draw()
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end

-- Coisas pro main.lua chamar
function Elevator.updateAll(dt)
    for _, e in ipairs(ActiveElevators) do
         e:update(dt)
    end
end

function Elevator.drawAll()
    for _, e in ipairs(ActiveElevators) do
         e:draw()
    end
end

return Elevator