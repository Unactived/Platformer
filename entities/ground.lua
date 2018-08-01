local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local Ground = Class{
    __includes = Entity -- inheritance
}

function Ground:init(world, x, y, w, h)
    Entity.init(self, world, x, y, w, h)

    self.world:add(self, self:getRect())
end

function Ground:draw()
    love.graphics.rectangle('fill', self:getRect())
end

return Ground
