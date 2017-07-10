local M = {}

local Plan = {}
Plan.__index = Plan

local lg = love.graphics

local nb = 0

-- constant data

local moveSpeed = 0


-- end of constants data

function M.new(x, y, w, h, nx,ny, moveX, moveY, speedFactor, smooth)  --n : vecteur normal   --moveX-Y : déplacement en X-Y  --speedFactor : facteur de vitesse par rapport à la vitesse de base
	local o = {}
	setmetatable(o,Plan)
	
	o.color = { math.random(0,255) ,  math.random(0,255) ,  math.random(0,255)}
	o.x = x or 0
	o.y = y or 0
	o.width = w or 0
	o.height = h or 0
	o.e = 1  --amortissement du plan [0;1]  0 : amortissement total (pas de rebond) ; 1 : par d'amortissement (choc élastique)
	o.f = 1 --friction du plan
	o.active = true
	o.id = nb
	o.nx = 0 or nx  --vecteur normal au plan. Par défaut , vecteur vertical.
	o.ny = 1 or ny
	o.moveX = moveX or 0
	o.moveY = moveY or 0
	o.speedFactor = speedFactor or 1
	o.smooth = smooth or false
	
	o.toGroundedMove = {  0 ,  0 }  -- to know how it has moved % the particle on it
	o.seed = false  -- has it a particle grounded on it ?
	
	o.actualMovX = 0
	o.actualMovY = 0
	
	nb = nb+1
	



	return o
end






function Plan:event()
	
end

function Plan:update(dt)
		

	if self.moveX ~= 0 or self.moveY ~=0 then
		local distance =  dt*self.speedFactor*moveSpeed
		
		if self.actualMovX < self.moveX and self.active then 
		
			self.x =  self.x + distance			
			self.actualMovX = self.actualMovX+distance
			
			if self.seed then self.toGroundedMove = {  self.toGroundedMove[1] + distance , self.toGroundedMove[2] + distance } end
			
		elseif self.actualMovX >= 0 then	
		
			self.active = false
			self.x =  self.x - distance
			self.actualMovX = self.actualMovX-distance
			
		else
			self.active = true
		end
	
	end

	
end

function Plan:draw()

	
		lg.rectangle( "fill", self.x, self.y, self.width, self.height )
	
end

return M

