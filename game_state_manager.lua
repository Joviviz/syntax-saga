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

    fase1 = { file = "fases.fase1" },
    fase2 = { file = "fases.fase2" },
    fase3 = { file = "fases.fase3" },
    fase4 = { file = "fases.fase4" },
    fase5 = { file = "fases.fase5" },
}

GSM.current = "menu"

function GSM.loadState(name)
    GSM.current = name

    if name == "menu" then
        GSM.states.menu.load()
        return
    end

    local faseData = require(GSM.states[name].file)
    if loadLevel then
        loadLevel(faseData)
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
