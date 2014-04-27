function love.load()
	require("entities")
	require("explosion")
	--ents.Register()
--end
	ents.Startup()
	love.graphics.setBackgroundColor( 255, 255, 255)
	xCloud = 0
	imageCloud = love.graphics.newImage("textures/cloud.png")
	imageGround = love.graphics.newImage("textures/ground.png")
	imageEnemy_1 = love.graphics.newImage("textures/enemy1.png")
	imageEnemy_2 = love.graphics.newImage("textures/enemy2.png")
	imageMouse = love.graphics.newImage("textures/Fadenkreuz.png")
	love.mouse.setVisible(false)
	score = 0

	for I=1, 5 do
		ents.Create( "zepp", -math.random(100, 300), 128, true)
	end
	ents.Create( "tank", 0, 512, false)
end

function love.draw()
	-- sky
	love.graphics.setColor(198, 241, 255, 255)
	love.graphics.rectangle("fill", 0, 0, 800, 300)
	-- Cloud
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(imageCloud, xCloud - 256, 128, 0, 1, 1, 0, 0)

	drawBGExplosions()
	ents:drawBG()
	
	-- gras
	love.graphics.setColor(103, 164, 21, 255)
	love.graphics.rectangle("fill", 0, 300, 800, 300)
	
	--more gras
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(imageGround, (800-1024)/2, 300-64, 0, 1, 1, 0, 0)

	ents:draw()
	drawFGExplosions()

	love.graphics.setColor( 25, 25, 25, 255)
	love.graphics.print("Score: "..score, 16, 16, 0, 1, 1)

	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(imageMouse, love.mouse.getX(), love.mouse.getY(), 0, 0.5, 0.5, 256, 256, 0, 0)
end

function love.update(dt)
	--require("lovebird").update()
	xCloud = xCloud + 32*dt
	if xCloud >= 800 + 128 then
		xCloud = 0
	end
	updateExplosions(dt)
	ents:update(dt)
end

function love.focus(bool)
end

function love.keypressed(k)
  if k == "q" or k == "escape" then--quit
    love.event.quit()
  elseif k == "f5" then--restart
  	ents.DestroyAll()
  	love.filesystem.load("main.lua")()

    love.load()

  end
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
	if button == "l" then
		ents.shoot( x, y )
	end
end

function love.mousereleased(x, y, button)
end

function love.quit()
end

function insideBox( px, py, x, y, wx, wy)
	if px > x and px < x + wx then
		if py > y and py < y + wy then
			return true
		end
	end
	return false
end

function addScore(n)
	score = score + tonumber(n)
end

function takeScore(n)
	score = score - tonumber(n)
	if score <= 0 then
		score = 0
	end
end