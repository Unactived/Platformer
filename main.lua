bump = require 'libs.bump.bump'

world = nil -- Storage

ground_0 = {}
ground_1 = {}


-- Player object
player = {
    x = 16,
    y = 16,

    -- Homemade physics
    xVelocity = 0,
    yVelocity = 0,
    acceleration = 100,
    maxSpeed = 600,
    friction = 20, -- Slows down player, may accelerate on icy stuff

    -- Jumping
    isJumping = false, -- action of jumping
    isGrounded = false, -- on the ground
    hasReachedMax = false,
    jumpAcceleration = 450,
    jumpMaxSpeed = 10,
    gravity = 90,

    -- Storage
    img = nil
}

function love.load()
    world = bump.newWorld(16) -- tile size

    player.img = love.graphics.newImage('assets/sprites/player.png')

    world:add(player, player.x, player.y, player.img:getWidth(), player.img:getHeight())

    -- Test level
    world:add(ground_0, 120, 360, 640, 16)
    world:add(ground_1, 0, 448, 640, 32)
end

function love.update(dt)
local prevX, prevY = player.x, player.y

    -- Friction
    player.xVelocity = player.xVelocity * (1 - math.min(dt * player.friction, 1))
    player.yVelocity = player.yVelocity * (1 - math.min(dt * player.friction, 1))

    -- Gravity
    player.yVelocity = player.yVelocity + player.gravity * dt

    if love.keyboard.isDown('left', 'q') and player.xVelocity > -player.maxSpeed then
        player.xVelocity = player.xVelocity - player.acceleration* dt
    elseif love.keyboard.isDown('right', 'd') and player.xVelocity < player.maxSpeed then
        player.xVelocity = player.xVelocity + player.acceleration* dt
    end

    if love.keyboard.isDown('up', 'z') then
        if -player.yVelocity < player.jumpMaxSpeed and not player.hasReachedMax then
            player.yVelocity = player.yVelocity - player.jumpAcceleration * dt
        elseif math.abs(player.yVelocity) > player.jumpMaxSpeed then
            player.hasReachedMax = true
        end

        player.isGrounded = false -- jumping
    end

    local goalX = player.x + player.xVelocity
    local goalY = player.y + player.yVelocity

    player.filter = function(item, other)
        local x, y, w, h = world:getRect(other)
        local pX, pY, pW, pH = world:getRect(item)
        local playerBottom = pY + pH
        local otherBottom = y + h

        if playerBottom <= y then
            return 'slide'
        end
    end

    player.x, player.y, collisions, len = world:move(player, goalX, goalY, player.filter)

    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then
            player.hasReachedMax = true
            player.isGrounded = false
        elseif coll.normal.y < 0 then
            player.hasReachedMax = false
            player.isGrounded = true
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push('quit')
    end
end

function love.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
    love.graphics.rectangle('fill', world:getRect(ground_0))
    love.graphics.rectangle('fill', world:getRect(ground_1))
end
