local ent = ents.Derive("base")

function ent:load(x, y)
	self:setPos(x, y)
	self.image_barrel = love.graphics.newImage("textures/barrel.png")
	self.image_tank = love.graphics.newImage("textures/tank.png")
	self.image_smoke = love.graphics.newImage("textures/smoke.png")
	self.speed = 16
	self.smokes = {}
	self.size = 0.25
	self.barrel_ang = 0
	self.distance = math.random(100,300)

	self.delta = 0

	self.exploding = false
	self.explosion = 0

	self.health = 20
	self.maxhealth = self.health
end

function ent:setPos( x, y)
	self.x = x
	self.y = y
end

function ent:getBarrelRad()
	return self.barrel_ang * math.pi*0.1-math.pi*0.1
end

function ent:getBarrelPos()
	return self.x, self.y + 16*self.size
end

function ent:draw()
	if self.exploding then
		--love.graphics.setColor(255,255,255,255*(1-self.explosion))
		--love.graphics.circle("fill", self.x, self.y, self.explosion*512, 64)

		love.graphics.setColor(255,255,255,255*(1.5-self.explosion))
		local bx, by = self:getBarrelPos()
		love.graphics.draw(self.image_barrel, bx, by, self:getBarrelRad(), self.size*0.75, self.size*0.75, 0, 16)

		love.graphics.setColor(255,255,255,255*(1.5-self.explosion))
		love.graphics.draw(self.image_tank, self.x, self.y, 0, self.size, self.size, 256, 128)

		return
	end

	love.graphics.setColor(255,255,255,255)
	local bx, by = self:getBarrelPos()
	love.graphics.draw(self.image_barrel, bx, by, self:getBarrelRad(), self.size*0.75, self.size*0.75, 0, 16)

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.image_tank, self.x, self.y, 0, self.size, self.size, 256, 128)

	for k, fire in pairs(self.fires) do
		love.graphics.draw(fire.fire, 0, 0,0)
	end
end

function ent:update(dt)
	if self.exploding then
		if self.explosion == 0 then
			startBGExplosion( self.x , self.y, 1)
		end
		self.explosion = self.explosion + dt
		if self.explosion >= 1.5 then
			ents.Destroy(self.id)
		end
		return
	end

	if self.x <= self.distance then
		self.x = self.x + self.speed*dt
		self.delta = self.delta + dt

		if self.delta >= 0.5 then
			ent:Smoke( -200*self.size, 80*self.size, 0.5, math.random(4, 16))
			self.delta = 0
		end
	elseif self.x > self.distance and self.x <= self.distance + 50 then
		self.x = self.x + self.speed*4*(1-(self.x/(self.distance + 50)))*dt + 4*dt
	else
	    self.delta = self.delta + dt
	    if self.delta >= 1 then
	    	self.delta = 0
	    	ent:Fire()
	    end
	end

	for i, fire in pairs(self.fires) do
		fire.fire:start()
		fire.x = self.x + fire.x - fire.sx
		fire.y = fire.y + self.y - fire.sy-- + calc(self.ang, fire.ax)
		fire.sx = self.x
		fire.sy = self.y
		fire.fire:moveTo(fire.x,fire.y)
		fire.fire:update(dt)
	end

	self.barrel_ang = math.sin(love.timer.getTime())
end

function ent:Fire()
	local a = ent:getBarrelRad()
	local x, y = ent:getBarrelPos()
	local bullet = ents.Create("bullet", x + math.cos(a)*200*self.size, y + math.sin(a)*200*self.size, false)
	bullet:setVelocity(math.cos(a)*400, math.sin(a)*400)
end

function ent:Damage(n)
	if n <= 0 or self.exploding then return end
	ent:spawnFire(math.random(-128, 128)*self.size, math.random(0, 128)*self.size)
	self.health = self.health - n
	addScore(1)
	if self.health <= 0 then
		self.health = 0
		ent:Explode()
		addScore(3)
	end
end

function ent:Explode()
	self.exploding = true
end

function ent:Die()
	ent:clearFire()
	ents.Create( "tank", -256, 512, false)
end

function ent:Smoke( x, y, s, speed)
	if not x then x = 0 end
	if not y then y = 0 end
	if not s then s = 1 end
	if not speed then speed = 64 end
	table.insert( self.smokes, {time = 3, x = self.x + x, y = self.y + y, s = s, speed = speed})
end

return ent