ents = {}
ents.objects = {}
ents.objpath = "entities/"
register = {}
register.pics = {}
local id = 0
local state = false
local state2 = "next"
local state3 = nil
local info = 0
local number = 1
local numb = 0
local file = nil

function ents.Startup()
	--register["box"] = love.filesystem.load( ents.objpath .. "box.lua" )
	register["zepp"] = love.filesystem.load( ents.objpath .. "zepp.lua" )
	register["tank"] = love.filesystem.load( ents.objpath .. "tank.lua" )
	register["bullet"] = love.filesystem.load( ents.objpath .. "bullet.lua" )

	thread = love.thread.newThread("Spriteloader.lua")
	request = love.thread.getChannel("request")
	answer = love.thread.getChannel("answer")

	thread:start()
	files = love.filesystem.getDirectoryItems("texturen")
end

function ents.Derive(name, path)
	if path then
		return love.filesystem.load( ents.objpath..path.. name .. ".lua" )()
	else
		return love.filesystem.load( ents.objpath .. name .. ".lua" )()
	end
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
	if state == true then
		for i, ent in pairs(ents.objects) do
			if ent.update then
				ent:update(dt)
			end
		end
	else
		if state2 == "next" then
			if number > #files then
				state = true
				request:push("END")
				printMap = function(file, l)   -- a function for printing the 'binary' sprite
							f = love.filesystem.newFile(string.sub(file,1,string.len(file)-3).."txt")
               			    f:open("w")
               			   	print(string.sub(file,1,string.len(file)-3).."txt")
               			    f:write("boxShoot\r\n")
                           	for i,v in ipairs(register.pics[l].boxShoot) do
                           		for j,x in pairs(v) do
                           			if x then
                           				f:write("1")
                           			else
                           			    f:write(" ")
                           			end
                           		end
                                f:write("\r\n")
                           	end
                           	f:write("boxFire")
                           	for i,v in ipairs(register.pics[l].boxFire) do
                                f:write(v.."\r\n")
                           	end
                           	f:close()
                        end
                for i,v in pairs(files) do
                	--printMap(v, string.sub(v, 1, string.len(v)-4))
                end
				return
			end
			local tab = {"texturen/"..tostring(files[number]),tostring(files[number])}
	    	request:push(tab)
	    	state2 = "recieve"
	    	return
	    elseif state2 == "recieve" then
	        local v = answer:pop()
	        if tostring(v) == "nil" then
	        	return
	        end
	        if tostring(v) == "No File" then
	        	print("ERROR: NO File found")
	        	debug.debug ()
	        end
	        if tostring(v) == "Name" then
	        	state3 = "name"
	        	return
	        end
	        if tostring(v) == "boxShoot" then
	        	register.pics[tostring(file)].boxShoot = {}
	        	state3 = "number"
	        	return
	        end
	        if tostring(v) == "boxFire" then
	        	state3 = "boxFire"
	        	register.pics[tostring(file)].boxFire = {}
	        	return
	        end
	        if tostring(v) == "width" then
	        	state3 = "width"
	        	return
	        end
	         if tostring(v) == "height" then
	        	state3 = "height"
	        	return
	        end
	         if tostring(v) == "End" then
	        	state3 = "End"
	        	state2 = "next"
	        	number = number + 1
	        	return
	        end
	        if state3 == "name" and tostring(v) ~= "nil" then
	        	file = tostring(v)
	        	register.pics[tostring(file)] = {}
	        	return
	        end
	        if state3 == "number" then
	        	info = tonumber(v)
	        	state3 = "table"
	        	return
	        end
	        if state3 == "table" then
	        	register.pics[tostring(file)].boxShoot[info] = v
	        	state3 = "number"
	        	return
	        end
	        if state3 == "boxFire" then
	        	register.pics[tostring(file)].boxFire = v
	        	return
	        end
	        if state3 == "width" then
	        	register.pics[tostring(file)].width = tonumber(v)
	        	return
	        end
	        if state3 == "height" then
	        	register.pics[tostring(file)].height = tonumber(v)
	        	return
	        end
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
			if tostring(ent.type) == "zepp" then
				local hit = insideBox(x, y, ent.x, ent.y, ent.image:getWidth()*(ent.size/20), ent.image:getHeight()*(ent.size/20))
				if hit then
					if tostring(register.pics[ent.name].boxShoot[math.ceil((y-ent.y)/(ent.image:getHeight()*ent.size2)*(ent.image:getHeight()))][math.ceil((x-ent.x)/(ent.image:getWidth()*ent.size2)*(ent.image:getWidth()))]) == "true" then
						ent1 = ent
					end
				end
			elseif tostring(ent.type) == "tank" then
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