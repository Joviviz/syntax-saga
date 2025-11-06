Button = {}
ActiveButtons = {} -- Lista para guardar todos os nossos botoes

function Button.new(x, y, width, height)
    local self = {}
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- Contador de caixas
    self.touchingBoxes = {} -- Tabela "set" para contar as caixas
    self.boxCount = 0      -- Contagem atualizada

    -- Corpo fisico (estatico)
    self.body = love.physics.newBody(World, self.x, self.y, "static")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    
    -- Fixture
    self.fixture = love.physics.newFixture(self.body, self.shape, 0) -- Densidade 0
    
    self.fixture:setUserData("Button")

    table.insert(ActiveButtons, self)
    return self
end

-- Funcao para atualizar a contagem de caixas
function Button.updateAll(dt)
    -- Itera por todos os botoes criados
    for _, b in ipairs(ActiveButtons) do
        local count = 0
        -- Conta quantas caixas estao na tabela "touchingBoxes"
        for _ in pairs(b.touchingBoxes) do
            count = count + 1
        end
        b.boxCount = count
    end
end

-- Funcao para desenhar todos os botoes
function Button.drawAll()
    -- Define a cor para vermelho
    love.graphics.setColor(1, 0, 0) 
    
    for _, b in ipairs(ActiveButtons) do
        love.graphics.rectangle("fill", b.x - b.width / 2, b.y - b.height / 2, b.width, b.height)
    end
    
    -- Restaura a cor para branco
    love.graphics.setColor(1, 1, 1)
end


-- Verifica quando uma caixa ENTRA em contato
function Button.beginContact(a, b, collision)
    -- Verifica qual fixture eh o botao e qual eh a caixa
    local buttonFixture = (a:getUserData() == "Button") and a or ((b:getUserData() == "Button") and b or nil)
    local boxFixture = (a:getUserData() == "Box") and a or ((b:getUserData() == "Box") and b or nil)

    -- Ignora se a colisao nao for entre um boatao e uma caixa
    if not (buttonFixture and boxFixture) then return end

    -- Verifica se a caixa esta EM CIMA do botao
    local nx, ny = collision:getNormal()
    local boxIsOnTop = false

    -- Caso 1: A = Caixa, B = Botao. Normal (A->B) aponta PARA BAIXO
    if a == buttonFixture and ny < -0.3 then 
        boxIsOnTop = true 
    end
    -- Caso 2: A = Botao, B = Caixa. Normal (A->B) aponta PARA CIMA.
    if b == buttonFixture and ny > 0.3 then 
        boxIsOnTop = true
    end
    
    -- Se a colisao for em cima, adiciona a caixa
    if boxIsOnTop then
        -- Encontra o objeto "box" e "button" correspondentes
        local box = nil
        for _, b_obj in ipairs(ActiveBoxes) do -- "boxes" eh a tabela global de box.lua
            if b_obj.fixture == boxFixture then box = b_obj; break; end
        end
        
        local button = nil
        for _, btn_obj in ipairs(ActiveButtons) do
            if btn_obj.fixture == buttonFixture then button = btn_obj; break; end
        end

        -- Adiciona a caixa a lista de "tocando" do botao
        if box and button then
            button.touchingBoxes[box] = true
        end
    end
end

-- Verifica quando uma caixa SAI do contato
function Button.endContact(a, b, collision)
    -- Verifica qual fixture eh o botao e qual eh a caixa 
    local buttonFixture = (a:getUserData() == "Button") and a or ((b:getUserData() == "Button") and b or nil)
    local boxFixture = (a:getUserData() == "Box") and a or ((b:getUserData() == "Box") and b or nil)

    if not (buttonFixture and boxFixture) then return end

    -- Encontra o objeto "box" e "button"
    local box = nil
    for _, b_obj in ipairs(ActiveBoxes) do
        if b_obj.fixture == boxFixture then box = b_obj; break; end
    end
    
    local button = nil
    for _, btn_obj in ipairs(ActiveButtons) do
        if btn_obj.fixture == buttonFixture then button = btn_obj; break; end
    end

    -- Remove a caixa da lista "tocando"
    if box and button and button.touchingBoxes[box] then
        button.touchingBoxes[box] = nil
    end
end

-- Funcao para o GUI.lua obter a contagem total das caixas
function Button.getTotalBoxCount()
    local total = 0
    for _, b in ipairs(ActiveButtons) do
        total = total + b.boxCount
    end
    return total
end