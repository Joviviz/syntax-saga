local GameStateManager = {}

GameStateManager.currentPhase = 1
GameStateManager.totalPhases = 5
GameStateManager.state = "menu" -- menu, game, phaseComplete, gameOver

function GameStateManager:init()
    self.currentPhase = 1
    self.state = "menu"
end

function GameStateManager:loadPhase(phaseNumber)
    self.currentPhase = phaseNumber
    self.state = "game"
    
    -- Limpar entidades anteriores
    self:clearEntities()
    
    -- Carregar nova fase
    self:setupPhase(phaseNumber)
end

function GameStateManager:clearEntities()
    -- Limpar coins
    for i = #ActiveCoins, 1, -1 do
        ActiveCoins[i].physics.body:destroy()
        table.remove(ActiveCoins, i)
    end
    
    -- Limpar spikes
    for i = #ActiveSpikes, 1, -1 do
        ActiveSpikes[i].physics.body:destroy()
        table.remove(ActiveSpikes, i)
    end
    
    -- Limpar boxes
    for i = #ActiveBoxes, 1, -1 do
        ActiveBoxes[i].physics.body:destroy()
        table.remove(ActiveBoxes, i)
    end
    
    -- Limpar buttons
    for i = #ActiveButtons, 1, -1 do
        ActiveButtons[i].physics.body:destroy()
        table.remove(ActiveButtons, i)
    end
    
    -- Limpar platforms
    for i = #ActivePlatforms, 1, -1 do
        ActivePlatforms[i].physics.body:destroy()
        table.remove(ActivePlatforms, i)
    end
    
    -- Resetar player
    Player:reset()
end

function GameStateManager:setupPhase(phaseNumber)
    local Phases = require("phases")
    local phase = Phases.data[phaseNumber]
    
    if not phase then return end
    
    -- Carregar as coisos
    for _, coin in ipairs(phase.coins) do
        Coin.new(coin.x, coin.y)
    end
    Spike.scale = 0.2
    for _, spike in ipairs(phase.spikes) do
        Spike.new(spike.x, spike.y)
    end
    for _, box in ipairs(phase.boxes) do
        Box.new(box.x, box.y)
    end
    for _, platform in ipairs(phase.platforms) do
        Platform.new(platform.x, platform.y, platform.width, platform.height)
    end
    for _, button in ipairs(phase.buttons) do
        Button.new(button.x, button.y, button.width, button.height)
    end
    if phase.flag then
        Flag.new(phase.flag.x, phase.flag.y)
    end
end

function GameStateManager:nextPhase()
    if self.currentPhase < self.totalPhases then
        self:loadPhase(self.currentPhase + 1)
    else
        self:winGame()
    end
end

function GameStateManager:winGame()
    self.state = "gameWon"
end

function GameStateManager:gameOver()
    self.state = "gameOver"
end

function GameStateManager:setState(newState)
    self.state = newState
end

function GameStateManager:getState()
    return self.state
end

return GameStateManager