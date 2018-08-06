pause = {}

pauseSound = love.audio.newSource('/assets/sfx/pause.wav', 'static')

function pause:enter(from)
    self.from = from -- save previous state
    music:pause()
    pauseSound:play()
end

function pause:draw()
    local pauseImg = love.graphics.newImage('/assets/images/pause.png')
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()

    -- Pause overlay
    love.graphics.setColor(0,0,0, 0.5) -- semi-transparent
    love.graphics.rectangle('fill', 0,0, w,h) -- shadow
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(pauseImg, w/6, h/6)
end

function pause:keypressed(key)
    if key == 'p' then
        music:play() -- resumes music, do not restart it
        return Gamestate.pop() -- return to previous state
    end
end

return pause
