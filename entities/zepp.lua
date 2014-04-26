local ent = ents.Derive("base")

function ent:load( x, y )
	self:setPos( x, y )
	self.image = love.graphics.newImage("textures/zepp.png")
	self.birth = love.timer.getTime() + math.random( 0, 128 )
	self.size = math.random( 4, 6 )
	self.size2 = self.size/20
	self.ang = 0
	self.falling = false
	self.health = 10
	self.maxhealt = self.health
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

	if self.x >= 1024 then
		ents.Destroy( self.id )
	end

	if self.falling then
		self.fixed_y = self.fixed_y + 32*dt
		self.ang = self.ang + math.pi*0.025*dt

		if self.y >= 300 then
			startExplosion( self.x + 512*self.size2, self.y + 128*self.size2, 1, "BG")
			self.falling = false
			ents.Destroy( self.id )
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
end

function calc(alpha, a)
	print((a*math.sin((alpha*(180/math.pi))))/math.sin(90))
	return (a*math.sin((alpha*(180/math.pi))))/math.sin(90)
end

function ent:Damage(n)
	if n <= 0 or (self.falling) then return end
	ent:spawnFire(math.random(0, 512)*self.size2, math.random(0, 128)*self.size2)
	self.health = self.health - n
	addScore(1)
	if self.health <= 0 then
		self.health = 0
		ent:Fall()
		addScore(3)
	end
end

function ent:Die()
	ent:clearFire()
	ents.Create( "zepp", -math.random(128, 256), 128, true)
end

function ent:Fall()
	self.falling = true
end

function ent:Smoke()
	table.insert( self.smokes,{time = 3, x = self.x, y = self.y})
end

function ent:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw( self.image, self.x, self.y, self.ang, self.size2, self.size2, 0, 0)

	for k, fire in pairs(self.fires) do
		love.graphics.draw(fire.fire, 0, 0,0)
	end
end

return ent