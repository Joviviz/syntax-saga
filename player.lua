Player = {}

function Player:load()
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60
    self.xVelocity = 0
    self.yVelocity = 100
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500

    self.maxHealth = 3
    self.health = 3
    
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

end

function Player:update(dt)
    self:syncPhysics()  
    self:move(dt)
end

function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        if self.xVelocity < self.maxSpeed then
            if self.xVelocity + self.acceleration * dt < self.maxSpeed then
                self.xVelocity = self.xVelocity + self.acceleration * dt
            else
                self.xVelocity = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a", "left") then
        if self.xVelocity > self.maxSpeed then
            if self.xVelocity - self.acceleration * dt > self.maxSpeed then
                self.xVelocity = self.xVelocity - self.acceleration * dt
            else
                self.xVelocity = -self.maxSpeed
            end
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVelocity, self.yVelocity)
end

function Player:draw()
    -- Love desenha o jogador do ponto de comeco, no topo a esquerda do retangulo
    -- ou seja eh necessario dividir os valores para renderizar o personagem pelo meio
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.width / 2, self.width, self.height)
end