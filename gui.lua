local Button = require("objects/button")
local Player = require("player")

local GUI = {}

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("assets/coin.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 3
    self.coins.x = 50
    self.coins.y = 50

    -- Font
    self.font = love.graphics.newFont("assets/bit.ttf", 36)

    -- Fix scale
    self.xScaleFix = self.coins.x + self.coins.width * self.coins.scale
    self.yScaleFix = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
end

function GUI:update()

end

function GUI:draw()
    -- Desenha as moedas (como ja fazia)
    self:displayCoins()
    self:setCoinFont()
    -- self:displayBoxCount()
    self:displayLevelNumber()
    self:displayLevelHint()
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

-- function GUI:displayBoxCount()
    
--     local count = 0
--     if gameState == "game" then
--         count = Button.getTotalBoxCount()
--     end

--     local text = "x = " .. count

--     love.graphics.setFont(self.font)

--     local screenWidth = love.graphics.getWidth()
--     local textWidth = self.font:getWidth(text)
    
--     local padding = 50 
--     local x = screenWidth - textWidth - padding
    
--     local y = self.yScaleFix 

--     love.graphics.setColor(0, 0, 0, 0.5)
--     love.graphics.print(text, x + 2, y + 2)
    
--     love.graphics.setColor(1, 1, 1, 1)
--     love.graphics.print(text, x, y)
-- end

function GUI:drawBackgroundBox(x, y, w, h, r, g, b, a)
    love.graphics.setColor(r, g, b, a or 1)
    love.graphics.rectangle("fill", x, y, w, h, 16, 16)
    love.graphics.setColor(1, 1, 1, 1)
end


function GUI:displayLevelHint()

    local hintFont = love.graphics.newFont("assets/bit.ttf", 40)
    love.graphics.setFont(hintFont)

    local text = nil

    -- Fase 1
    if gameState == "level1" then
        text = "se caixas == 1 --> plataformaSobe()"

    -- Fase 2
    elseif gameState == "level2" then
        text = "se botao.recebeCaixa() --> plataformaSobe()"

    -- Fase 3
    elseif gameState == "level3" then
        text = "se caixa1 e caixa2 --> plataformaSobe()"

    -- Fase 4
    elseif gameState == "level4" then
        text = "se botao1.recebeCaixa() ou botao2.recebeCaixa() --> plataformaSobe()"

    -- Fase 5
    elseif gameState == "level5" then
        text = "enquanto caixa --> plataformaGira()"
    end

    -- Se não estiver em fase válida, sai
    if not text then return end

    -- Centralizar
    local screenWidth = love.graphics.getWidth()
    local textWidth = hintFont:getWidth(text)

    local x = (screenWidth - textWidth) / 2
    local y = 140
    local padding = 20

    -- Fundo
    self:drawBackgroundBox(
        x - padding,
        y - padding,
        textWidth + padding * 2,
        hintFont:getHeight() + padding * 2,
        0, 0, 0, 0.5
    )

    -- Sombra
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(text, x + 3, y + 3)

    -- Texto
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, x, y)
end


function GUI:displayLevelNumber()
    if gameState:match("^level%d+$") then
        local bigFont = love.graphics.newFont("assets/bit.ttf", 100)
        love.graphics.setFont(bigFont)

        local levelNum = string.match(gameState, "%d+")
        local text = "Fase " .. levelNum

        local screenWidth = love.graphics.getWidth()
        local textWidth = bigFont:getWidth(text)

        local x = (screenWidth - textWidth) / 2
        
        local y = 20

        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.print(text, x + 3, y + 3)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(text, x, y)
    end
end



return GUI