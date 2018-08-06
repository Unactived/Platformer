io.stdout:setvbuf("no") -- Stops output buffering to directly flush stdout

Gamestate = require 'libs.hump.gamestate'

local mainMenu = require 'gamestates.mainMenu'
local level1 = require 'gamestates.level1'
local pause = require 'gamestates.pause'

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(level1)
end

function love.keypressed(key)
    if key == "escape" then
      love.event.push('quit')
    elseif key == "lctrl" then
      debug.debug()
    end
end
