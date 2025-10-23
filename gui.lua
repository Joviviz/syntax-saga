require("button")

GUI = {}

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

    -- 🔹 Adicionado: Chamada para a nova funcao que desenha a contagem de caixas
    self:displayBoxCount()
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

-- Funcao para contar e desenhar as caixas
function GUI:displayBoxCount()
    
    -- Contagem (com seguranca)
    local count = 0
    -- So tentamos obter a contagem se o jogo estiver a correr (senao 'Button' da erro)
    if gameState == "game" then
        count = Button.getTotalBoxCount()
    end

    -- Texto ("x = N")
    local text = "x = " .. count

    -- Fonte
    love.graphics.setFont(self.font)

    -- Posicao (Canto superior direito)
    local screenWidth = love.graphics.getWidth()
    local textWidth = self.font:getWidth(text)
    
    -- Posicao X: Largura da tela - largura do texto - espacamento
    local padding = 50 -- Vamos usar o mesmo 'padding' X das moedas
    local x = screenWidth - textWidth - padding
    
    -- Posicao Y: Usar a mesma altura Y das moedas (self.yScaleFix) para alinhar
    local y = self.yScaleFix 

    -- shadow
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(text, x + 2, y + 2)
    
    -- text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, x, y)
end