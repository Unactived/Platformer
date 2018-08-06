local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local player = Class{
    __includes = Entity -- inheritance
}

function player:init(world, x, y)
    self.frame = 1 -- frame index in animations tables
    self.dt = 0
    self.hitboxW = 19
    self.hitboxH = 30

    self.frameW = 50
    self.frameH = 37

    Entity.init(self, world, x, y, self.hitboxW, self.hitboxH)

    self.sheet = love.graphics.newImage('/assets/sprites/player_sheet.png')
    self.frames = {
        -- The values in the tables are the animation's line in the sheet and
        -- the animation's length used later to fill them with
        -- the appropriate amount of quads

        sprint = {0, 6},
        walk = {1, 6},
        idle = {2, 4},
        idleSword = {3, 4},
        run = {4, 6},
        runSword = {5, 6},
        crouch = {6, 4},
        crouchWalk = {7, 6},
        slide = {8, 2},
        attack = {9, 5},
        attack2 = {10, 6},
        attack3 = {11, 6},
        airAttack1 = {12, 4},
        airAttack2 = {13, 3},
        attackFalling = {14, 6},
        jump = {15, 4},
        fall = {16, 2},
        somersault = {17, 4},
        cornerGrab = {18, 4},
        cornerClimb = {19, 5},
        cornerJump = {20, 2},
        wallRun = {21, 6},
        wallSlide = {22, 2},
        wallClimb = {23, 4},
        swordDraw = {24, 4},
        swordSheathe = {25, 4},
        hurt = {26, 3},
        die = {27, 7},
        castSpell = {28, 4},
        castSpellLoop = {29, 4},
        useItem = {30, 3},
        waterIdle = {31, 6},
        waterSwim = {32, 4},
        stand = {33, 3},
        punch = {34, 4},
        punch2 = {35, 5},
        punch3 = {36, 4},
        kick = {37, 4},
        kick2 = {38, 4},
        dropKick = {39, 4},
        knockedDown = {40, 7},
        getUp = {41, 7},
        bowAim = {42, 5},
        bowShoot = {43, 4},
        airBow = {44, 6}
    }
    
    self.currentAnimation = self.frames.idle

    -- loads quads from the sheet
    for k, v in pairs(self.frames) do
        -- empty the tables and get appropriate variables
        animationLine = table.remove(v, 1)
        animationLen  = table.remove(v, 1)
        for i=0, animationLen do
            table.insert(v, love.graphics.newQuad(i * 50, animationLine * 37, self.frameW, self.frameH,
            self.sheet:getDimensions()))
        end
    end

    -- Homemade physics
    self.xVelocity = 0
    self.yVelocity = 0
    self.acceleration = 100
    self.maxSpeed = 600
    self.friction = 20 -- Slows down player, may accelerate on icy stuff

    -- Jumping
    self.isJumping = false -- action of jumping
    self.isGrounded = false -- on the ground
    self.isLeft = false -- Used to flip sprites
    self.hasReachedMax = false
    self.jumpAcceleration = 450
    self.jumpMaxSpeed = 10
    self.gravity = 90

    self.world:add(self, x, y, 19, 29) -- hitbox dimensions
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
    local oldAnimation = self.currentAnimation
  
    local prevX, prevY = self.x, self.y

    -- Friction
    self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))
    self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))

    -- Gravity
    self.yVelocity = self.yVelocity + self.gravity * dt

    if love.keyboard.isDown('left', 'q') then
      self.isLeft = true
      if self.xVelocity > -self.maxSpeed then
        self.xVelocity = self.xVelocity - self.acceleration* dt
      end
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
    
    ------------------------
    --     ANIMATION      --
    ------------------------
        
    -- cycles animations 1/60 = 0.016
    if self.currentAnimation == oldAnimation then
      if self.dt > 0.1 then
        self.frame = self.frame + 1
        self.frame = self.frame % (#self.currentAnimation - 1)
        self.dt = 0
      else
        self.dt = self.dt + dt
      end
    else
      self.frame = 1
      self.dt = 0
    end
    
    -- I hate Lua and its arrays indexed to 1
    if self.frame == 0 then
      self.frame = 1
    end
    
    self.image = self.currentAnimation[self.frame]
    
    -- Quad:flip is deprecated
    -- if self.isLeft then
    --   self.image = self.image:flip(true, false)
    -- end
    
end

function player:draw()
    love.graphics.draw(self.sheet, self.image, self.x, self.y)
end

return player
