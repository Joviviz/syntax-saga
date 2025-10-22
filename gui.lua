GUI = {}

function GUI:load()
    self.coins        = {}
    self.coins.img    = love.graphics.newImage("assets/coin.png")
    self.coins.width  = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale  = 3
    self.coins.x      = 50
    self.coins.y      = 50

    -- Font
    self.font         = love.graphics.newFont("assets/bit.ttf", 36)

    -- Fix scale
    self.xScaleFix    = self.coins.x + self.coins.width * self.coins.scale
    self.yScaleFix    = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
end

function GUI:update()

end

function GUI:draw()
    self:displayCoins()
    self:setCoinFont()
end

-- Coins
function GUI:displayCoins()
    -- shadow
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
    -- text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end
function GUI:setCoinFont()
    love.graphics.setFont(self.font)
    -- shadow
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(" : " .. Player.coins, self.xScaleFix + 2, self.yScaleFix + 2)
    -- text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(" : " .. Player.coins, self.xScaleFix, self.yScaleFix)
end