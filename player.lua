Player = {}

function Player:load()
    -- Jogador
    self.x = 100
    self.y = 0
    self.width = 20
    self.height = 60

    -- Movimentacao
    self.xVelocity = 0
    self.yVelocity = 100
    self.maxSpeed = 200
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.grounded = false
    -- Pulo
    self.jumpAmount = -500
    self.hasDoubleJump = true
    self.graceTime = 0
    self.graceDuration = 0.1

    -- Features Futuras
    self.maxHealth = 3
    self.health = 3
    
    -- Configs
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self:loadAssets()
end

-- Carregar ASSETS (WIP)
function Player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}
    self.animation.run = {total = 6, current = 1}
    for i = 1, self.animation.run.total do
        print(i)
    end
end

-- Frames
function Player:update(dt)
    self:syncPhysics()  
    self:move(dt)
    self:applyGravity(dt)
    self:decreaseGraceTime(dt)
end

-- Gravidade
function Player:applyGravity(dt)
    if self.grounded == false then
        self.yVelocity = self.yVelocity + self.gravity * dt
    end
end


-- Movimentacao
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
        if self.xVelocity > -self.maxSpeed then
            if self.xVelocity - self.acceleration * dt > -self.maxSpeed then
                self.xVelocity = self.xVelocity - self.acceleration * dt
            else
                self.xVelocity = -self.maxSpeed
            end
        end
    else
        self:applyFriction(dt)
    end
end

-- Friccao para desacelerar o jogador
function Player:applyFriction(dt)
    if self.xVelocity > 0 then
        if self.xVelocity - self.friction * dt > 0 then
            self.xVelocity = self.xVelocity - self.friction * dt
        else
            self.xVelocity = 0
        end
    elseif self.xVelocity < 0 then
        if self.xVelocity + self.friction * dt < 0 then
            self.xVelocity = self.xVelocity + self.friction * dt
        else
            self.xVelocity = 0
        end
    end
end

-- Syncar Fisicas
function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVelocity, self.yVelocity)
end

-- Mecanicas de contato com blocos
function Player:beginContact(a, b, collision)
    -- conferir se o jogador esta no tocando o chao
    if self.grounded == true then return end
    -- Retorna as coordenadas que aponta de um objeto A
    -- para um objeto B, se A esta embaixo de A entao o vetor
    -- sera um valor positivo
	local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

function Player:jump(key)
    if (key == "w" or key == "up") then
        if self.grounded or self.graceTime > 0 then
            self.yVelocity = self.jumpAmount
            self.graceTime = 0
        elseif self.hasDoubleJump then
            self.hasDoubleJump = false
            self.yVelocity = self.jumpAmount * 0.8
        end
    end
end

function Player:decreaseGraceTime(dt)
    if not self.grounded then
        self.graceTime = self.graceTime - dt
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVelocity = 0
    self.grounded = true
    self.hasDoubleJump = true
    self.graceTime = self.graceDuration
end

-- 
function Player:endContact(a, b, collision)
	if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end




function Player:draw()
    -- Love desenha o jogador do ponto de comeco, no topo a esquerda do retangulo
    -- ou seja eh necessario dividir os valores para renderizar o personagem pelo meio
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end