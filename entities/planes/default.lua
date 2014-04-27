local ent = ents.Derive("planeBase", "planes/")

function ent:load( x, y, imagePath)
	self:setPos( x, y )
	self:setImage(imagePath)
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	--self.birth = love.timer.getTime() + math.random( 0, 64 ) --# Haven't decided if i will use this
	self.size = 10
	self.multiSize = self.size/20
	self.ang = 0
	self.falling = false
	self.health = 10
	self.type = "default"
end

function ent:setPos( x, y )
	self.x = x
	self.y = y
	self.fixed_y = y
end

function ent:update(dt)
	local posy = math.sin(love.timer.getTime() - self.birth)*(self.size*3)
	local posx = (self.size*9)*dt
	self.y = self.fixed_y + posy
	self.x = self.x + posx

	if self.x >= love.window.getWidth() + self.width*self.size then
		ents.Destroy( self.id )
		takeScore(self.health)
	end

	if self.falling then
		self.fixed_y = self.fixed_y + 32*dt
		self.ang = self.ang + math.pi*0.050*dt

		if self.y >= optrions.dieHeight then
			startExplosion( self.x + 128*self.size2, self.y + 128*self.size2, 1, "BG")
			self.falling = false
			ents.Destroy( self.id )
		end
	end

	for i, fire in pairs(self.fires) do
		fire.fire:start()
		fire.x = self.x + fire.x - fire.sx
		fire.y = fire.y + self.y - fire.sy
		fire.sx = self.x
		fire.sy = self.y
		fire.fire:moveTo(fire.x,fire.y+calc(self.ang, fire.ax))
		fire.fire:update(dt)
	end
end

function ent:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw( self.image, self.x, self.y, self.ang, self.size2, self.size2, 0, 0)

	for k, fire in pairs(self.fires) do
		love.graphics.draw(fire.fire, 0, 0,0)
	end
end

function calc(alpha, a)
	return (math.tan(alpha)*a)
end

function ent:Damage(n)
	if n <= 0 or (self.falling) then return end
	--ent:spawnFire(math.random(0, 512)*self.size2, math.random(0, 128)*self.size2) --# Needs to be replaced with particle.spawnFire()
	self.health = self.health - n
	addScore(1)
	if self.health <= 0 then
		self.health = 0
		ent:Fall()
		addScore(self.health/2)
	end
end

function ent:Die()
	--ent:clearFire() --# Needs to be replaced with particle.clearFire()
	ents.Create( "default", -math.random(128, 256), 128, true) --# Needs to be replaced with spawnmanager stuff
end

function ent:Fall()
	self.falling = true
end

return ent