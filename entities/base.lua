local id = love.image.newImageData(32, 32)
--1b. fill that blank image data
for x = 0, 31 do
    for y = 0, 31 do
        local gradient = 1 - ((x-15)^2+(y-15)^2)/40
        id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
    end
end

local base = {}

base.x = 0
base.y = 0
base.health = 1
base.fires = {}

base.exFireIm = love.graphics.newImage(id)
base.exFire = love.graphics.newParticleSystem(base.exFireIm, 750)
base.exFire:setEmitterLifetime(1)
base.exFire:setParticleLifetime(0.4,0.6)
base.exFire:setDirection(-1.55)
base.exFire:setColors({255,255,0,255},{200,200,0,255},{255,0,0,255},{255,0,0,255},{50,50,50,255},{50,50,50,255},{20,20,20,255},{0,0,0,255})--{255,255,0,255},{255,0,0,255},{255,0,0,255},{0,0,0,255},{0,0,0,255})
base.exFire:setSpread(4)
base.exFire:setSizes(0.3)
base.exFire:setSpeed(10,50)
base.exFire:setTangentialAcceleration(0)
base.exFire:setRadialAcceleration(0)
base.exFire:setLinearAcceleration(0,-90,0,0)
base.exFire:setEmissionRate(500)
base.exFire:stop()

function base:setPos( x, y)
	base.x = x
	base.y = y
end

function base:getPos()
	return base.x, base.y
end

function base:load()
end

function base:spawnFire(x,y)
	if self.type == "zepp" then
		if register.pics[self.name].boxFire then
			local num = math.random(1,#register.pics[self.name].boxFire)
			local string = register.pics[self.name].boxFire[num]
			local t = {}
			for i in string.gmatch(string, '[^:]+') do
				table.insert(t, i)
				--print(i)
			end
			table.insert(base.fires,{fire = base.exFire:clone(), x=t[2]*self.size2, y=t[1]*self.size2, sx=0,sy=0, ax=t[2]*self.size2})
		else
		    table.insert(base.fires,{fire = base.exFire:clone(), x=x, y=y, sx=0,sy=0, ax=x})
		end
	else
		table.insert(base.fires,{fire = base.exFire:clone(), x=x, y=y, sx=0,sy=0, ax=x})
	end
end

function base:clearFire()
	for i,v in pairs(base.fires) do
		v = nil
	end
end

return base