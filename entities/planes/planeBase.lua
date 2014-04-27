local base = {}

function base:load()
end

function base:setPos( x, y )
	base.x = x
	base.y = y
end

function base:setSpeed(s)
	base.speed = s
end

function base:getSpeed()
	return base.speed
end

function base:getPos()
	return base.x, base.y
end

function base:setImage(imagePath)
	base.image = love.graphics.newImage(image)
end

function base:getImage()
	return base.image
end

return base