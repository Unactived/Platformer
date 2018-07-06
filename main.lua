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
    jumpAcceleration = 500,
    jumpMaxSpeed = 9.5,
    gravity = 80,

    -- Needs to be loaded in love
    img = nil
}


function love.load()
    player.img = love.graphics.newImage('assets/sprites/player.png')
end

function love.update(dt)
    player.x = player.x + player.xVelocity
    player.y = player.y + player.yVelocity

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
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push('quit')
    end
end

function love.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
end
