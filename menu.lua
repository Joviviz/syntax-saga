local Menu = {}

function Menu.load()
    local w = love.graphics.getWidth()
    Menu.font = love.graphics.newFont("assets/bit.ttf", 28)

    Menu.buttons = {
        { text = "level 1", state = "level1", x = w / 2 - 100, y = 200, w = 200, h = 40 },
        { text = "level 2", state = "level2", x = w / 2 - 100, y = 260, w = 200, h = 40 },
        { text = "level 3", state = "level3", x = w / 2 - 100, y = 320, w = 200, h = 40 },
        { text = "level 4", state = "level4", x = w / 2 - 100, y = 380, w = 200, h = 40 },
        { text = "level 5", state = "level5", x = w / 2 - 100, y = 440, w = 200, h = 40 },
    }
end

function Menu.draw()
    love.graphics.setFont(Menu.font)
    love.graphics.printf("Syntax Saga", 0, 100, love.graphics.getWidth(), "center")

    for _, b in ipairs(Menu.buttons) do
        love.graphics.setColor(0.2, 0.6, 1)
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(b.text, b.x, b.y + 8, b.w, "center")
    end
end

function Menu.mousepressed(x, y, button)
    if button ~= 1 then return end

    for _, b in ipairs(Menu.buttons) do
        if x >= b.x and x <= b.x + b.w and y >= b.y and y <= b.y + b.h then
            return b.state
        end
    end
end

return Menu
