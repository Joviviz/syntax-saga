-- Este arquivo funciona como um "módulo", cuidando de toda a lógica do menu.

local Menu = {}

-- Função para carregar os recursos do menu (fonte, botões, etc.)
function Menu.load()
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    
    local fontSize = 28
    Menu.font = love.graphics.newFont("assets/bit.ttf", fontSize)

    -- Botão "Fase 1"
    Menu.startButton1 = {
        text = "Fase 1",
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 - 80,
        width = 200,
        height = 50
    }

    -- Botão "Fase 2"
    Menu.startButton2 = {
        text = "Fase 2",
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 - 10,
        width = 200,
        height = 50
    }

    -- Botão "Sair"
    Menu.exitButton = {
        text = "Sair",
        x = windowWidth / 2 - 100,
        y = windowHeight / 2 + 60,
        width = 200,
        height = 50
    }
end

-- Desenha o menu principal
function Menu.draw()
    love.graphics.setFont(Menu.font)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Syntax Saga", 0, 120, love.graphics.getWidth(), "center")

    -- Desenhar botões com cores diferentes
    -- Botão Fase 1
    love.graphics.setColor(0, 0.7, 0.2)
    love.graphics.rectangle("fill", Menu.startButton1.x, Menu.startButton1.y, Menu.startButton1.width, Menu.startButton1.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(Menu.startButton1.text, Menu.startButton1.x, Menu.startButton1.y + 10, Menu.startButton1.width, "center")

    -- Botão Fase 2
    love.graphics.setColor(0.2, 0.5, 0.8)
    love.graphics.rectangle("fill", Menu.startButton2.x, Menu.startButton2.y, Menu.startButton2.width, Menu.startButton2.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(Menu.startButton2.text, Menu.startButton2.x, Menu.startButton2.y + 10, Menu.startButton2.width, "center")

    -- Botão Sair
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.rectangle("fill", Menu.exitButton.x, Menu.exitButton.y, Menu.exitButton.width, Menu.exitButton.height)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(Menu.exitButton.text, Menu.exitButton.x, Menu.exitButton.y + 10, Menu.exitButton.width, "center")
end

-- Detecta cliques do mouse e retorna o estado do jogo correspondente
function Menu.mousepressed(x, y, button)
    if button == 1 then
        -- Fase 1
        if x >= Menu.startButton1.x and x <= (Menu.startButton1.x + Menu.startButton1.width) and
           y >= Menu.startButton1.y and y <= (Menu.startButton1.y + Menu.startButton1.height) then
            return "level1"
        end

        -- Fase 2
        if x >= Menu.startButton2.x and x <= (Menu.startButton2.x + Menu.startButton2.width) and
           y >= Menu.startButton2.y and y <= (Menu.startButton2.y + Menu.startButton2.height) then
            return "level2"
        end

        -- Sair
        if x >= Menu.exitButton.x and x <= (Menu.exitButton.x + Menu.exitButton.width) and
           y >= Menu.exitButton.y and y <= (Menu.exitButton.y + Menu.exitButton.height) then
            love.event.quit()
        end
    end
end

return Menu
