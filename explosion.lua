local BGexplosions = {}
id = love.image.newImageData(32, 32)
for x = 0, 31 do
    for y = 0, 31 do
        local gradient = 1 - ((x-15)^2+(y-15)^2)/40
        id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
    end
end
local i = love.graphics.newImage(id)
exp = love.graphics.newParticleSystem(i, 1000)
exp:setEmitterLifetime(1.5)
exp:setParticleLifetime(2,2)
exp:setDirection(-1.55)
exp:setColors({255,255,0,255},{255,255,0,255},{255,0,0,255},{255,255,0,255},{255,0,0,255},{100,50,50,255},{50,50,50,255},{20,20,20,255})
exp:setSpread(1)
exp:setSizes(0.2,2)
exp:setSizeVariation(0.5)
exp:setSpeed(50,50)
exp:setTangentialAcceleration(0)
exp:setRadialAcceleration(0)
exp:setLinearAcceleration(0,-90,0,0)
exp:setEmissionRate(500)

function startBGExplosion(x, y, magn)
	local exp1 = exp:clone()
	exp1:setTangentialAcceleration(0,-20)
	exp1:setPosition(x-5, y)
	exp1:setColors({255,255,0,255},{255,0,0,255},{100,50,50,255},{50,50,50,255},{20,20,20,255})
	local exp2 = exp:clone()
	exp2:setPosition(x+5, y)
	exp2:setColors({255,255,0,255},{255,0,0,255},{100,50,50,255},{50,50,50,255},{20,20,20,255})
	local exp3 = exp:clone()
	exp3:setPosition(x, y)
	exp3:setColors({255,255,0,255},{255,255,0,255},{255,0,0,255},{255,255,0,255},{255,0,0,255},{100,50,50,255})
	exp2:setTangentialAcceleration(0,20)
	exp3:setParticleLifetime(1,1.5)
	table.insert(BGexplosions,{exp1,exp2,exp3, 0, magn, x, y})
end

function drawBGExplosions()
	for k, ex in pairs(BGexplosions) do
		love.graphics.draw(ex[1],0,0)
		love.graphics.draw(ex[2],0,0)
		love.graphics.draw(ex[3],0,0)
	end
end

function updateBGExplosions(dt)
	for k, ex in pairs(BGexplosions) do
		ex[1]:update(dt)
		ex[2]:update(dt)
		ex[3]:update(dt)
		ex[4] = ex[4] + dt
		if ex[4] >= 4 then
			table.remove(BGexplosions, k)
		end
	end
end

--[[
local image = love.graphics.newImage("textures/explosion.png")

function startBGExplosion(x, y, magn)
	table.insert( BGexplosions, {x = x, y = y, magn = magn, t = 0})
end

function drawBGExplosions()
	for k, ex in pairs(BGexplosions) do
		local sx = (ex.t/(4*ex.magn))
		local sy = (ex.t/(4*ex.magn))
		love.graphics.setColor(255, 255, 255, 255*(1-(ex.t/(4*ex.magn))))
		local ssx = 0.5 + (sx/2)
		local ssy = sy

		love.graphics.draw( image, ex.x - (256*ssx*0.5), ex.y - (256*ssy), 0, ssx, ssy, 0, 0)

		love.graphics.setColor(255, 255, 255, 180*(1-(ex.t/(4*ex.magn))))
		love.graphics.circle("fill", ex.x, ex.y, 2048*(ex.t/(4*ex.magn)), 32)
	end
end

function updateBGExplosions(dt)
	for k, ex in pairs(BGexplosions) do
		ex.t = ex.t + dt
		if ex.t > 4*ex.magn then
			table.remove(BGexplosions, k)
		end
	end
end]]