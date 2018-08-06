function love.conf(t)
    t.window.title = "Platformer"
    t.window.icon = "/assets/icon.png"
    t.version = "11.1"
    t.window.width = 600
    t.window.height = 432
    t.window.fullscreentype = "exclusive"
    
    t.accelerometerjoystick = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false

    t.console = true -- Windows
end
