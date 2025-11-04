Coin = { img = love.graphics.newImage("assets/coin.png") }
Coin.__index = Coin
Coin.width = Coin.img:getWidth()
Coin.height = Coin.img:getHeight()

ActiveCoins = {}

function Coin.new(x, y)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y

    -- Coin SPPPPPPIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIN
    instance.scaleX = 1
    instance.randomTimeOffset = math.random(0, 100)

    -- Interacao com o jogador
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    instance.toBeRemoved = false


    -----
    table.insert(ActiveCoins, instance)
end

function Coin:update(dt)
    self:spin(dt)
    self:checkRemove()
end

function Coin:spin(dt)
    -- Sin waves (-1 -> 0 -> 1 -> 0 -> -1 ...)
    -- print(math.sin(love.timer.getTime()))
    self.scaleX = math.sin(love.timer.getTime() * 3 + self.randomTimeOffset)
end

function Coin:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
end

function Coin:updateAll(dt)
    for i, instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end
end

function Coin.drawAll()
    for i, instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

-- Funcoes de contato com jogador
function Coin.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:incrementCoins()
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

function Coin:remove()
    -- loopa na tabela dos coins ativos e remove o coin
    -- que foi tocado, escolhendo seu index
    for i, instance in ipairs(ActiveCoins) do
        if instance == self then
            table.remove(ActiveCoins, i)
            self.physics.body:destroy()
        end
    end
end
