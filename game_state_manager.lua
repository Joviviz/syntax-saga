local GSM = {}

local Menu = require("menu")

GSM.states = {
    menu = {
        load = function()
            Menu.load()
        end,
        update = function(dt)
            Menu.update(dt)
        end,
        draw = function()
            Menu.draw()
        end,
        mousepressed = function(x, y, button)
            return Menu.mousepressed(x, y, button)
        end
    },

    level1 = { file = "levels.level1" },
    level2 = { file = "levels.level2" },
    level3 = { file = "levels.level3" },
    level4 = { file = "levels.level4" },
    level5 = { file = "levels.level5" },
}

GSM.current = "menu"

function GSM.loadState(name)
    GSM.current = name

    if name == "menu" then
        GSM.states.menu.load()
        return
    end

    local levelData = require(GSM.states[name].file)
    if loadLevel then
        loadLevel(levelData)
    end
end

function GSM.update(dt)
    if GSM.current == "menu" then
        GSM.states.menu.update(dt)
    end
end

function GSM.draw()
    if GSM.current == "menu" then
        GSM.states.menu.draw()
    end
end

function GSM.mousepressed(x, y, button)
    if GSM.current == "menu" then
        return GSM.states.menu.mousepressed(x, y, button)
    end
end

return GSM
