if arg[2] == "debug" then
    require("lldebugger").start()
end

local STI = require("sti")
require("player")
require("coin")
require("gui")
require("box")
require("button") -- Carrega o modulo do botao
-- Carrega o modulo do menu
local Menu = require("menu")

-- Fix blurry sprites
love.graphics.setDefaultFilter("nearest", "nearest")

-- Variael para controlar o estado (menu ou jogo)
gameState = "menu"
-- Declara as variaveis globais para que ambas as funcoes possam acessa-las
Map = nil
World = nil
background = nil

-- Funcao que contem TODA a logica de carregamento
function loadGame()
    Map = STI("map/1.lua", {"box2d"})
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, endContact)
    Map:box2d_init(World)
    Map.layers.solid.visible = false
    background = love.graphics.newImage("assets/background.png")

    Player:load()
    GUI:load()

    Box.new(350, 330)
    Box.new(450, 330)

    Coin.new(300, 200)
    Coin.new(400, 200)
    Coin.new(500, 100)
    
    local buttonWidth = 64
    local buttonHeight = 16
    
    local buttonX = 540 
    local buttonY = 328 
    Button.new(buttonX, buttonY, buttonWidth, buttonHeight)
end

function love.load()
    -- Funcao load agora carrega apenas fundo (para o menu) e o menu
    background = love.graphics.newImage("assets/background.png")
    Menu.load()
end

function love.update(dt)
    -- if para so atualizar o jogo quando nao estivermos no menu
    if gameState == "game" then
        World:update(dt)
        Player:update(dt)
        Coin.updateAll(dt)
        Box.updateAll(dt)
        Button.updateAll(dt) 
    end
end

function love.draw()
    -- Fundo eh desenhado em ambos os estados, proporcional a tela
    local scaleX = love.graphics.getWidth() / background:getWidth()
    local scaleY = love.graphics.getHeight() / background:getHeight()
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    -- if/else para desenhar o menu OU o jogo
    if gameState == "menu" then
        Menu.draw()
    elseif gameState == "game" then
        -- O codigo de desenho original do jogo (exceto o fundo) vai aqui
        Map:draw(0, 0, 2, 2)
        GUI:draw()
        love.graphics.push()
        love.graphics.scale(2,2)
        Player:draw()
        Box.drawAll()
        Coin.drawAll()
        Button.drawAll() 
        love.graphics.pop()
    end
end

function love.keypressed(key)
    -- Tecla ESC para fechar o jogo
    if key == "escape" then
        love.event.quit()
    end

    -- Permitir para pulo apenas em jogo
    if gameState == "game" then
        Player:jump(key)
    end
end

-- Funcao dos cliques do mouse no menu
function love.mousepressed(x, y, button)
    if gameState == "menu" then
        local newState = Menu.mousepressed(x, y, button)
        if newState == "game" then
            gameState = "game"
            loadGame()
        end
    end
end

-- These two are all good the problem is in player.lua
function beginContact(a, b, collision)
    -- if para verificar colisoes apenas em jogo
    if gameState == "game" then
        -- Collect coin before player begins contact
        if Coin.beginContact(a, b, collision) then 
            return 
        end
        Player:beginContact(a, b, collision)
        Button.beginContact(a, b, collision)
    end
end


function endContact(a, b, collision)
    -- if para verificar colisoes apenas em jogo
    if gameState == "game" then
        Player:endContact(a, b, collision)
        Button.endContact(a, b, collision) 
    end
end