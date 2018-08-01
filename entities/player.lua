local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local player = Class{
    __includes = Entity -- inheritance
}

function player:init(world, x, y)
    self.img = love.graphics.newImage('/assets/sprites/player.png')

    Entity.init(self, world, x, y, self.img:getWidth(),
    self.img:getHeight())

    -- Homemade physics
    self.xVelocity = 0
    self.yVelocity = 0
    self.acceleration = 100
    self.maxSpeed = 600
    self.friction = 20 -- Slows down player, may accelerate on icy stuff

    -- Jumping
    self.isJumping = false -- action of jumping
    self.isGrounded = false -- on the ground
    self.hasReachedMax = false
    self.jumpAcceleration = 450
    self.jumpMaxSpeed = 10
    self.gravity = 90

    self.world:add(self, self:getRect())
end

function player:collisionFilter(other)
    local x, y, w, h = self.world:getRect(other)
    local playerBottom = pY + pH
    local otherBottom = y + h

    if playerBottom <= y then
        return 'slide'
    end
end

function player:update(dt)
    local prevX, prevY = self.x, self.y

    -- Friction
    self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
    self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

    -- Gravity
    self.yVelocity = self.yVelocity + self.gravity * dt

    if love.keyboard.isDown('left', 'q') and self.xVelocity > -self.maxSpeed
        then self.xVelocity = self.xVelocity - self.acceleration* dt
    elseif love.keyboard.isDown('right', 'd') and self.xVelocity < self.maxSpeed then
        self.xVelocity = self.xVelocity + self.acceleration* dt
    end

    if love.keyboard.isDown('up', 'z') then
        if -self.yVelocity < self.jumpMaxSpeed and not self.hasReachedMax then
            self.yVelocity = self.yVelocity - self.jumpAcceleration * dt
        elseif math.abs(self.yVelocity) > self.jumpMaxSpeed then
            self.hasReachedMax = true
        end

        self.isGrounded = false -- jumping
    end

    local goalX = self.x + self.xVelocity
    local goalY = self.y + self.yVelocity



    self.x, self.y, collisions, len = world:move(self, goalX, goalY, self.filter)

    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then
            self.hasReachedMax = true
            self.isGrounded = false
        elseif coll.normal.y < 0 then
            self.hasReachedMax = false
            self.isGrounded = true
        end
    end
end

function player:draw()
    love.graphics.draw(self.img, self.x, self.y)
end

return player
