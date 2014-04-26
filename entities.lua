ents = {}
ents.objects = {}
ents.objpath = "texturen"
local register = {}
local id = 0

function ents.Startup()
	--register["box"] = love.filesystem.load( ents.objpath .. "box.lua" )
	register["zepp"] = love.filesystem.load( ents.objpath .. "zepp.lua" )
	register["tank"] = love.filesystem.load( ents.objpath .. "tank.lua" )
	register["bullet"] = love.filesystem.load( ents.objpath .. "bullet.lua" )
end

function ents.Derive(name)
	return love.filesystem.load( ents.objpath .. name .. ".lua" )()
end



function ents.Create( name, x, y, BG)
	if not x then
		x = 0
	end

	if not y then
		y = 0
	end

	if not BG then
		BG = false
	end

	if register[name] then
		id = id + 1
		local ent =  register[name]()
		ent:load()
		ent.type = name
		ent:setPos(x, y)
		ent.id = id
		ent.BG = BG
		ents.objects[id] = ent
		return ents.objects[id]
	else
		print("ERROR: Entity ".. name .. " does not exist!")
		return false
	end
end

function ents.Destroy( id )
	if ents.objects[id] then
		if ents.objects[id].Die then
			ents.objects[id]:Die()
		end
		ents.objects[id] = nil
	end
end

function ents.DestroyAll()
	ents.objects = {}
	id = 0
	register = {}
end

function ents:update(dt)
	for i, ent in pairs(ents.objects) do
		if ent.update then
			ent:update(dt)
		end
	end
end

function ents:draw()
	for i, ent in pairs(ents.objects) do
		if not ent.BG then
			if ent.draw then
				ent:draw()
			end
		end
	end
end

function ents:drawBG()
	for i, ent in pairs(ents.objects) do
		if ent.BG then
			if ent.draw then
				ent:draw()
			end
		end
	end
end

function ents.shoot( x, y )
	local ent1, ent2
	for i, ent in pairs(ents.objects) do
		if ent.Die then
			if ent.type == "zepp" then
				local hit = insideBox(x, y, ent.x, ent.y, 512*(ent.size/20), 128*(ent.size/20))
				if hit then
					print("Hit!")
					ent1 = ent
				end
			elseif ent.type == "tank" then
				local hit = insideBox(x,y, ent.x-128*ent.size, ent.y, 256*ent.size, 128*ent.size)
				if hit then
					ent2 = ent
				end
			end
		end
	end
	if ent1 then
		ent1:Damage(2)
	end
	if ent2 then
		ent2:Damage(2)
	end
end