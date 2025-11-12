local Box = {img = love.graphics.newImage("assets/box.png")}
Box.__index = Box
Box.width = Box.img:getWidth()
Box.height = Box.img:getHeight()

local ActiveBoxes = {}

function Box:load()
end

function Box.new(x, y)
    local self = {}
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.isBeingPushed = false
    self.grounded = false
    self.gravity = 1500  -- <<< força gravitacional manual

    self.body = love.physics.newBody(World, x, y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData("Box")
    self.fixture:setFriction(0.8)
    self.fixture:setRestitution(0)
    self.body:setLinearDamping(5)

    table.insert(ActiveBoxes, self)
end

function Box.updateAll(dt)
    for _, b in ipairs(ActiveBoxes) do
        local bx, by = b.body:getPosition()

        -- 🔹 Gravidade manual (similar ao Player)
        if not b.grounded then
            local vx, vy = b.body:getLinearVelocity()
            b.body:setLinearVelocity(vx, vy + b.gravity * dt)
        end

        -- 🔹 Parar de se mover se não estiver sendo empurrada
        if not b.isBeingPushed then
            local vx, vy = b.body:getLinearVelocity()
            if math.abs(vx) > 0.1 then
                b.body:setLinearVelocity(vx * 0.8, vy)
            end
        end

        -- 🔹 Resetar estado
        b.isBeingPushed = false
        b.grounded = false -- será redefinido em beginContact se tocar o chão
    end
end

function Box.drawAll()
    for _, b in ipairs(ActiveBoxes) do
        local bx, by = b.body:getPosition()
        love.graphics.draw(
            Box.img,
            bx,
            by,
            b.body:getAngle(), 
            Box.scaleX,
            Box.scaleY,
            Box.img:getWidth()/2,  
            Box.img:getHeight()/2 
        )
    end
    love.graphics.setColor(1, 1, 1)
end

-- 🔹 Detectar contato com chão ou player
function Box.beginContact(a, b)
    local boxFixture = (a:getUserData() == "Box") and a or ((b:getUserData() == "Box") and b or nil)
    if boxFixture then
        for _, box in ipairs(ActiveBoxes) do
            if box.fixture == boxFixture then
                box.isBeingPushed = true

                -- Se colidiu com o chão
                local other = (boxFixture == a) and b or a
                local otherType = other:getUserData()
                if otherType == "Ground" or otherType == "Tile" or otherType == "solid" then
                    box.grounded = true
                end
            end
        end
    end
end

function Box.getActiveBoxes()
    return ActiveBoxes
end

return Box