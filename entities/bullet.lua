local ent = ents.Derive("base")

function ent:load( x, y)
	self:setPos(x, y)
	self.r = 2
	self.velocity = {x = 0, y = 0}
	self.inertia = 1
end

function ent:setInertia(n)
	self.inertia = n
end

function ent:update(dt)
	self.x = self.x + self.velocity.x*dt
	self.y = self.y + self.velocity.y*dt

	self.velocity.y = self.velocity.y + 128*self.inertia*dt

	if self.y > 600 or self.x > 800 then
		takeScore(1)
		ents.Destroy(self.id)
	end
end

function ent:setVelocity(x, y)
	self.velocity = {x=x, y=y}
end

function ent:getVelocity()
	return self.velocity.x, self.velocity.y
end

function ent:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.circle("fill", self.x, self.y, self.r, 8)
end

return ent