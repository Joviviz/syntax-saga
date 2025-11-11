Box = {}
ActiveBoxes = {}

function Box.load()

    Box.img = love.graphics.newImage("assets/box.png") 
    Box.img_width = Box.img:getWidth()
    Box.img_height = Box.img:getHeight()
end

function Box.new(x, y)
    local self = {}
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.isBeingPushed = false
    self.grounded = false
    self.gravity = 1500

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

        if not b.grounded then
            local vx, vy = b.body:getLinearVelocity()
            b.body:setLinearVelocity(vx, vy + b.gravity * dt)
        end

        if not b.isBeingPushed then
            local vx, vy = b.body:getLinearVelocity()
            if math.abs(vx) > 0.1 then
                b.body:setLinearVelocity(vx * 0.8, vy)
            end
        end

        b.isBeingPushed = false
        b.grounded = false
    end
end

function Box.drawAll()
    love.graphics.setColor(1, 1, 1)
    
    for _, b in ipairs(ActiveBoxes) do
        local bx, by = b.body:getPosition()
        
        -- ⬅️ MUDANÇA (Desenha a imagem em vez do retângulo)
        love.graphics.draw(
            Box.img,
            bx,
            by,
            b.body:getAngle(),
            1, -- ⬅️ CORREÇÃO (era Box.scaleX)
            1, -- ⬅️ CORREÇÃO (era Box.scaleY)
            Box.img_width / 2,  
            Box.img_height / 2 
        )
    end
    -- Não precisa mais restaurar a cor, pois já definimos como branco
end

function Box.beginContact(a, b)
    local boxFixture = (a:getUserData() == "Box") and a or ((b:getUserData() == "Box") and b or nil)
    if boxFixture then
        for _, box in ipairs(ActiveBoxes) do
            if box.fixture == boxFixture then
                box.isBeingPushed = true
                local other = (boxFixture == a) and b or a
                local otherType = other:getUserData()
                if otherType == "Ground" or otherType == "Tile" or otherType == "solid" then
                    box.grounded = true
                end
            end
        end
    end
end