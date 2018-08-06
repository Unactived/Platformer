bump = require 'libs.bump.bump'
Gamestate = require 'libs.hump.gamestate'

local Entities = require 'entities.Entities'
local Entity = require 'entities.Entity'

local level1 = {}

music = love.audio.newSource('/assets/musics/senile.xm', 'stream')

local Player = require 'entities.player'
local Ground = require 'entities.ground'

player = nil
world = nil

function level1:enter()
    world = bump.newWorld(32) -- 32 tile size

    Entities:enter()
    player = Player(world, 14, 7)
    ground_0 = Ground(world, 100, 340, 240, 16)
    ground_1 = Ground(world, 0, 400, 640, 16)

    Entities:addMany({player, ground_0, ground_1})
    music:play()
end

function level1:keypressed(key)
    if key == 'p' then
        return Gamestate.push(pause)
    end
end

function level1:update(dt)
    Entities:update(dt)
end

function level1:draw()
    Entities:draw()
end

return level1
