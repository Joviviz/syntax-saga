local Camera = {
    x = 0,
    y = 0,
    scale = 2,
}

function Camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:reset()
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    -- Centro da window
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y
    local RS = self.x + love.graphics.getWidth() / 2

    if self.x < 0 then
        self.x = 0
    elseif RS > MapWidth  then
        self.x = MapWidth - love.graphics.getWidth() / 2
    end
    end
end

return Camera