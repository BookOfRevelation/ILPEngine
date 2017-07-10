local M = {}

local Particle = {}
Particle.__index = Particle

local lg = love.graphics
local lk = love.keyboard
local floor = math.floor
local abs = math.abs

local nb = 0


-- constant data




-- end of constants data

function M.new(x, y, r, vx, vy)
	local o = {}
	setmetatable(o,Particle)
	o.x = x or 100
	o.y = y or 100
	o.radius = r or 10
	o.color = { math.random(0,255) ,  math.random(0,255) ,  math.random(0,255)}
	o.vx = vx or 0
	o.vy = vy or 0
	o.e = 1  --amortissement de la particule [0;1]  0 : amortissement total (pas de rebond) ; 1 : par d'amortissement (choc élastique)
	o.f = 1 --friction de la particule
	o.active = true
	o.id = nb
	nb = nb+1
	o.oldX = o.x - o.vx
	o.oldY = o.y - o.vy
	o.grounded = false
	
	



	return o
end


function Particle:rebondPart(p)   
--[[
      effectue un test de collision entre la particule courante et
      la particule p. S'il y a collision, les vitesses des particules sont
      recalculées en fonction des vitesses initiales.    
--]]
	
	if self.id == p.id or self.grounded == true then return end   -- p ~= self  ??
	local nx = self.x - p.x
	local ny = self.y - p.y
	local d  = math.sqrt(nx * nx + ny * ny)   -- distance entre deux particules
	if d <= self.radius*2  then
		nx = nx* (self.radius*2 -d) /d
		ny = ny* (self.radius*2 -d) /d
		self.x = self.x + nx 
		self.y = self.y + ny
		p.x = p.x - nx 
		p.y = p.y - ny 
		d = math.sqrt(nx * nx + ny * ny) -- on recalcule la distance
		nx = nx/d
		ny = ny/d
		vn = (self.vx - p.vx) * nx +(self.vy - p.vy) * ny
		if vn > 0.0 then
			return
		end
		vn = vn * -((self.e+p.e)/2)    --réduire la vitesse en fonction de la moyenne des ammortissements
		nx = nx * vn
		ny = ny * vn
		self.vx = self.vx + nx
		if not self.grounded then self.vy = self.vy + ny else self.vy = 0 end
		p.vx = p.vx -nx
		if not self.grounded then p.vy = p.vy - ny else p.vy = 0 end
	end		
	
		



end

function Particle:rebondPlan(p)

	if ((  (self.y+self.radius  >=  p.y )  and self.vy >=0)  -- si on tombe sur un plan --
		and  self.x > p.x and self.x < p.x + p.width
		and self.oldY+self.radius <= p.y)

	then
		 self.y = (p.y-self.radius) 
		
		local v = { x = self.vx, 
					y = self.vy
				  }
		 
		
		local pn = { x = p.nx , y = p.ny }
		
		local dotProduct = v.x*p.nx + v.y*p.ny
		pn.x = p.nx* (-2*dotProduct)
		pn.y = p.ny* (-2*dotProduct)
		
		
		self.vx = self.vx+pn.x  * -((self.e+p.e)/2)			
		if not self.grounded then self.vy = self.vy+pn.y   * ((p.e+self.e)/2) else self.vy=0 end
		
			
			
		
		self.vx = self.vx * ((self.f+p.f)/2)
	
		
		if math.abs(self.vy) < phys.bound_tolerance then self.vy = 0  self.grounded = true end
		if math.abs(self.vx) < phys.roll_tolerance then self.vx = 0 end

		
	end

end



function Particle:event()
	
	

	
end

function Particle:update(dt)
	
	if self.active then

		if self.oldX == self.x and self.oldY == self.y then self.grounded = true 
		else
			self.oldX = self.x		
			self.oldY = self.y
			self.grounded = false
		end
	end	
	-- physics
	self.vy = self.vy + phys.g*dt
	self.y = self.y + self.vy*dt
	self.x = self.x + self.vx*dt
	
	
	
	
end

function Particle:draw()
	
	lg.circle( "fill", self.x, self.y, self.radius, 18 )
	
end

return M

