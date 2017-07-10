function love.conf(t)
	t.title = "Collide Module" 
	t.author = "Bastien Oudot"
	t.identity = ""
	t.screen.width = 640
	t.screen.height = 480
	t.screen.vsync = false
	t.modules.joystick = false
	t.modules.audio = false
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = true
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = false
	t.modules.sound = true
	t.modules.physics = false
end
