local Player = {}

function Player:load()
    -- Jogador
    self.x = 50
    self.y = 0
    self.width = 16
    self.height = 30 -- it was 32, 32 makes his height not being able to go under 2 blocks
    -- Starting position
    self.startX = self.x
    self.startY = self.y

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
    -- Animacoes
    self.direction = "right"
    self.state = "idle"

    -- vida
    self.health = { current = 1, max = 1 }
    self.alive = true

    -- Moedas
    self.coins = 0

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
    self.animation = { timer = 0, rate = 0.1 }
    -- Animacao de correr
    self.animation.run = { total = 5, current = 1, img = {} }
    for i = 1, self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("assets/player/run/" .. i .. ".png")
    end

    -- Animacao idle
    self.animation.idle = { total = 1, current = 1, img = {} }
    self.animation.idle.img[1] = love.graphics.newImage("assets/player/idle/1.png")

    self.animation.draw = self.animation.idle.img[1]



    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end

-- Frames
function Player:update(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:decreaseGraceTime(dt)
    self:animate(dt)
    self:setDirection()
    self:setState()
    self:respawn()
end

function Player:draw()
    local scaleX = 1
    if self.direction == "left" then
        scaleX = -1
    end
    -- love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    -- Love desenha o jogador do ponto de comeco, no topo a esquerda do retangulo
    -- ou seja eh necessario dividir os valores para renderizar o personagem pelo meio
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2,
        self.animation.height / 2)
end

-- Animacoes de andar
function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.rate < self.animation.timer then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.state]
    -- print(anim.current)
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else
        anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
end

function Player:setDirection()
    if self.xVelocity > 0 then
        self.direction = "right"
    elseif self.xVelocity < 0 then
        self.direction = "left"
    end
end

function Player:setState()
    if self.xVelocity == 0 then
        self.state = "idle"
    else
        self.state = "run"
    end
    -- Printar state que o personagem esta para teste
    -- print(self.state)
end

-- Gravidade
function Player:applyGravity(dt)
    if self.grounded == false then
        self.yVelocity = self.yVelocity + self.gravity * dt
    end
end

-- Movimentacao
function Player:move(dt)
    -- Pesquisar na math library
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
        elseif ny < 0 then
            self:hitCeiling(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self:hitCeiling(collision)
        end
    end
end

function Player:hitCeiling(collision)
    if self.yVelocity < 0 then
        self.yVelocity = 0
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

-- Moedas
function Player:incrementCoins()
    self.coins = self.coins + 1
    print("Coins: " .. self.coins)
end

-- Funcoes de tomar dano/reiniciar fases
function Player:takeDamage(amount)
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
    else
        self.health.current = 0
        self:die()
    end
    print("Player health: " .. self.health.current)
end

function Player:die()
    print("Player died")
    self.alive = false
end

function Player:respawn()
    if self.alive == false then
        self.physics.body:setPosition(self.startX, self.startY)
        self.health.current = self.health.max
        self.alive = true
        
    end
end

function Player:getY()
    return self.y
end

return Player