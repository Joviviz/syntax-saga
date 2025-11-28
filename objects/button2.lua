local Button2 = {}
local ActiveButtons2 = {}
local Box = require("objects/box")

function Button2.new(x, y, width, height)
    local self = {}
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.touchingBoxes = {}
    self.boxCount = 0

    self.body = love.physics.newBody(World, self.x, self.y, "static")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 0)
    self.fixture:setUserData("Button2")

    table.insert(ActiveButtons2, self)
    return self
end

function Button2.updateAll(dt)
    for _, b in ipairs(ActiveButtons2) do
        local count = 0
        for _ in pairs(b.touchingBoxes) do
            count = count + 1
        end
        b.boxCount = count
    end
end

function Button2.drawAll()
    love.graphics.setColor(0, 0, 1)
    for _, b in ipairs(ActiveButtons2) do
        love.graphics.rectangle("fill", b.x - b.width/2, b.y - b.height/2, b.width, b.height)
    end
    love.graphics.setColor(1,1,1)
end

function Button2.beginContact(a, b, collision)
    local buttonFixture = (a:getUserData() == "Button2") and a or ((b:getUserData() == "Button2") and b or nil)
    local boxFixture = (a:getUserData() == "Box") and a or ((b:getUserData() == "Box") and b or nil)
    if not (buttonFixture and boxFixture) then return end

    local nx, ny = collision:getNormal()
    local boxIsOnTop = false

    if a == buttonFixture and ny < -0.3 then
        boxIsOnTop = true
    end
    if b == buttonFixture and ny > 0.3 then
        boxIsOnTop = true
    end

    if not boxIsOnTop then return end

    local box = nil
    for _, bx in ipairs(Box.getActiveBoxes()) do
        if bx.fixture == boxFixture then
            box = bx
            break
        end
    end

    local button = nil
    for _, bt in ipairs(ActiveButtons2) do
        if bt.fixture == buttonFixture then
            button = bt
            break
        end
    end

    if button and box then
        print("DEBUG Button2: caixa entrou no botão2")
        button.touchingBoxes[box] = true
    end
end

function Button2.endContact(a, b, collision)
    local buttonFixture = (a:getUserData() == "Button2") and a or ((b:getUserData() == "Button2") and b or nil)
    local boxFixture = (a:getUserData() == "Box") and a or ((b:getUserData() == "Box") and b or nil)
    if not (buttonFixture and boxFixture) then return end

    local box = nil
    for _, bx in ipairs(Box.getActiveBoxes()) do
        if bx.fixture == boxFixture then
            box = bx
            break
        end
    end

    local button = nil
    for _, bt in ipairs(ActiveButtons2) do
        if bt.fixture == buttonFixture then
            button = bt
            break
        end
    end

    if button and box then
        print("DEBUG Button2: caixa saiu do botão2")
        button.touchingBoxes[box] = nil
    end
end

function Button2.getTotalBoxCount()
    local total = 0
    for _, b in ipairs(ActiveButtons2) do
        total = total + b.boxCount
    end
    return total
end

function Button2.clearAll()
    for _, bt in ipairs(ActiveButtons2) do
        if bt.body then bt.body:destroy() end
    end
    ActiveButtons2 = {}
end

return Button2
