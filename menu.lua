-- Este arquivo funciona como um "modulo", cuidando de toda a logica do menu.

local Menu = {}

-- Funcao para carregar os recursos do menu (fonte, etc.)
function Menu.load()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    
    local fontSize = 28
    Menu.font = love.graphics.newFont("assets/bit.ttf", fontSize)

    -- Propriedades do botao "Iniciar"
    Menu.startButton = {
        text = "Iniciar",
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 - 50,
        width = 200,
        height = 50
    }

    -- Propriedades do botao "Sair"
    Menu.exitButton = {
        text = "Sair",
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 + 20,
        width = 200,
        height = 50
    }
end

-- Desenho do menu
function Menu.draw()
    love.graphics.setFont(Menu.font)

    love.graphics.printf("Syntax Saga", 0, 150, love.graphics.getWidth(), "center")

    -- Botao "Iniciar"
    love.graphics.setColor(0, 0.7, 0.2)
    love.graphics.rectangle("fill", Menu.startButton.x, Menu.startButton.y, Menu.startButton.width, Menu.startButton.height)
    
    -- Botao "Sair"
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", Menu.exitButton.x, Menu.exitButton.y, Menu.exitButton.width, Menu.exitButton.height)

    -- Texto dos botoes
    love.graphics.setColor(1, 1, 1)
    local textOffsetY = (Menu.startButton.height / 2) - (Menu.font:getHeight() / 2)
    love.graphics.printf(Menu.startButton.text, Menu.startButton.x, Menu.startButton.y + 10, Menu.startButton.width, "center")
    love.graphics.printf(Menu.exitButton.text, Menu.exitButton.x, Menu.exitButton.y + 10, Menu.exitButton.width, "center")
end

-- Função que verifica os cliques e retorna o novo estado se um botão for pressionado
function Menu.mousepressed(x, y, button)
    if button == 1 then
        -- Clique do botão "Iniciar"
        if x >= Menu.startButton.x and x <= (Menu.startButton.x + Menu.startButton.width) and
           y >= Menu.startButton.y and y <= (Menu.startButton.y + Menu.startButton.height) then
            return "game"
        end

        -- Clique do botão "Sair"
        if x >= Menu.exitButton.x and x <= (Menu.exitButton.x + Menu.exitButton.width) and
           y >= Menu.exitButton.y and y <= (Menu.exitButton.y + Menu.exitButton.height) then
            love.event.quit()
        end
    end
end

-- Retorna a tabela "Menu"
return Menu