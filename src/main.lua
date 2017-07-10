local res = require("engine.resource") 
local particle = require("engine.particle")
local plan = require("engine.plan")

local lg = love.graphics
local wh = love.window.getHeight()
local ww = love.window.getWidth()

local debugMode = false
local floor = math.floor





-- main variables of this file


local particles = {}


local plans = {}
local ground = plan.new(0,wh-10,ww,100, 0)
ground.e = 0.450
ground.f = 0.110
plans[1] = ground






-- set the physics
phys = {}
phys.g = 500
phys.bound_tolerance = 1
phys.roll_tolerance = 1


	

--

function love.load()
	--lg.setDefaultImageFilter("nearest","nearest")	
	

end



function love.keypressed(key)
	-- quit the game
	if key == 'q'  then
		love.event.push("quit")
	end
	
	if key == 'f12' then
		debugMode = not debugMode
	end
	
	if key == ' ' then
		local p =  particle.new(math.random(0, ww),math.random(0, wh),math.random(15,25), math.random(0,100), math.random(0,100))	
		particles[#particles+1] = p
	end
	
	if key == 'c' then
		particles = {}
		plans = {ground}
	end
	if key == 'p' then
		local obstacle = plan.new(math.random(50,500),math.random(50,500), math.random(100,300),math.random(20,50),0,1,100,10,1)
		plans[#plans + 1] = obstacle
		obstacle.e = 0.8
		obstacle.f = 0.6
	end
	
	
end

function love.update(dt)


	for var=1, #particles do
	
		local p = particles[var]
		if p ~= nil then	
			p:event()
			
			-- manage collision				
				-------OTHERS PARTICLES------
				for i = 1 , #particles do
					local p2 = particles[i]
					p:rebondPart(p2)
					
				end
				-----------------------------
				
				---------GROUND-------------
				for j = 1 , #plans do
					local pl = plans[j]
					p:rebondPlan(pl)
				end
				-----------------------------
				
				p:update(dt)
				
			

			-- forget useless particles
			if p.x < 0 or p.x > ww or p.y > wh or p.y < 0 then p = nil end
			
		end
		
	end
	
	
	for var=1, #plans do	
		local p = plans[var]		
		p:update(dt)
	end
	
	
	

end
 
 
function love.draw()
	

	
	for var=1, #particles do	
		local p = particles[var]
		lg.setColor(p.color[1],p.color[2],p.color[3])
		p:draw()
	end
	
	for var=1, #plans do	
		local p = plans[var]
		lg.setColor(p.color[1],p.color[2],p.color[3])
		p:draw()
	end
                          
	
	if debugMode then                                   -- some informations about the game behaviour
		
		if #particles >= 1 then
				lg.print("Particule : ", 100,100)
				lg.print("x : " .. particles[1].x, 100,110)
				lg.print("y : " .. particles[1].y, 100,120)
				lg.print("vx : " .. particles[1].vx, 100,130)
				lg.print("vy : " .. particles[1].vy, 100,140)
		end
		
	end
	
		
	
	if #particles == 0 and #plans == 1 then
		lg.setColor(255,255,255)
		lg.print("espace : ajouter une particule", 100,100)
		lg.print("p : ajouter un plan", 100,116) 
		lg.print("c : effacer l'ecran", 100,132) 
		
	
	end
	
	
	
	

		
end



