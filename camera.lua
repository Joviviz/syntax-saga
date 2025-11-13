local Camera = {
    x = 0,
    y = 0,
    scale = 2,
}

function Camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:reset()
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    -- centraliza na janela considerando scale (X e Y)
    self.x = x - (love.graphics.getWidth() / self.scale) / 2
    self.y = y - (love.graphics.getHeight() / self.scale) / 2

    -- clamp básico se o mapa estiver carregado (usa STI properties se disponível)
    if Map and Map.width and Map.tilewidth and Map.height and Map.tileheight then
        local mapPixelW = Map.width * Map.tilewidth
        local mapPixelH = Map.height * Map.tileheight

        if self.x < 0 then self.x = 0 end
        if self.y < 0 then self.y = 0 end

        local viewW = love.graphics.getWidth() / self.scale
        local viewH = love.graphics.getHeight() / self.scale

        if self.x + viewW > mapPixelW then
            self.x = math.max(0, mapPixelW - viewW)
        end
        if self.y + viewH > mapPixelH then
            self.y = math.max(0, mapPixelH - viewH)
        end
    end
end

return Camera