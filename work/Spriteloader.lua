sprite = {}
sprite.objects = {}

function sprite.calculateSprite(path, file)
	local name = string.sub(file, 1, string.len(file)-4)
	local ending = string.sub(file, string.len(file)-3,string.len(file))
	if ending ~= ".png" then
		print("[SPRITE]: "..file.." is not a valid Image file! It will be ignored")
		return "Ignore"
	elseif sprite.objects[name] then
    	print("[SPRITE]: "..tostring(file).." is already calculated! Please check your files")
    	return "Known"
    else
    	print("[SPRITE]: Succesfully calculated Hitbox for "..file)
    	return "Sum",sprite.calcHitbox(path)
	end
end

function sprite.calcHitbox(path)
	local box = loadSprite(path)
	local boxShoot = {}
	local boxFire = {}
	for i,v in pairs(box.map) do
		boxShoot[i] = {}
		for j=1,string.len(v) do
			if tostring(string.sub(v,j,j)) == "1" then
				boxShoot[i][j] = true
				table.insert(boxFire, {x=i,y=j,state=true})
			else
			    boxShoot[i][j] = false
			end
		end
	end
	return boxShoot, boxFire, {w=box.width,h=box.height}
end

function loadSprite(s)
   local s = love.image.newImageData(s)
   local w,h = s:getWidth(),s:getHeight()  -- gets image width and height
   local batch = {} -- Converts the sprite into a sort of binary table...0 matches pixels with transparency
      for y = 0,h-1 do batch[y+1] = ''
         for x = 0,w-1 do
         local _,_,_,a = s:getPixel(x,y)
         batch[y+1] = ((a == 0) and batch[y+1]..' ' or batch[y+1]..'1')
         end
      end
      return { -- Returns a custom structure
               map = batch,  -- the 'binary' sprite
               width = w,  -- width
               height = h, -- height  
            }
end

function thread()

end

            	--[[for i, file in pairs(love.filesystem.getDirectoryItems(reg.objpath)) do
		local name = string.sub(file, 1, string.len(file)-4)
		local ending = string.sub(file, string.len(file)-3,string.len(file))
		if ending ~= ".png" then
			print("[REGISTER]: "..file.." is not a valid lua file! It will be ignored")
		elseif register[name] then
			print("[REGISTER]: "..tostring(file).." is already registered! Please rename the file")
		else
		    --register[name] = love.filesystem.load(ents.objpath .. "/" .. tostring(file) )
		    print("[REGISTER]: Succesfully registered "..name)
		    local boxShoot, boxFire = calcHitbox(ents.objpath.."/"..name..".png")
		    f = love.filesystem.newFile(name..".txt")
		    f:open("w")
		    f:write("boxShoot: \r\n")
            for k,v in pairs(boxShoot) do
            	for j,x in pairs(v) do
            		if x then 
            			f:write("1")
            		else
            		    f:write(" ")
            		end
            	end
            	f:write("\r\n")
            end
            f:write("\r\n")
            f:write("boxFire: \r\n")
            for k,v in pairs(boxFire) do
            	f:write(tostring(v.x).." : "..tostring(v.y).." : "..tostring(v.state))
            	f:write("\r\n")
            end
            f:close()
		end
	end

function calcHitbox(path)
	local boxShoot = {}
	local box = loadSprite(path)
	for i,v in pairs(box.map) do
		boxShoot[i] = {}
		for j=1,string.len(v) do
			if tostring(string.sub(v,j,j)) == "1" then
				boxShoot[i][j] = true
			else
			    boxShoot[i][j] = false
			end
		end
	end
	local boxTemp = {}
	for i,v in pairs(boxShoot) do
		boxTemp[i] = {}
		for j,x in pairs(v) do
			boxTemp[i][j] = {x=i,y=j,state=x}
		end
	end
	for i,v in pairs(boxShoot) do
		for j,x in pairs(v) do
			if tostring(x) == "false" then
				boxTemp[i][j] = nil
			end
		end
	end
	for i,v in pairs(boxTemp) do
		if v == nil then
			table.remove(boxTemp, i)
		end
	end
	local boxFire = {}
	for i,v in pairs(boxTemp) do
		for j,x in pairs(v) do
			table.insert(boxFire, x)
		end
	end
	return boxShoot, boxFire
end

function loadSprite(s)
   local s = love.image.newImageData(s)
   local w,h = s:getWidth(),s:getHeight()  -- gets image width and height
   local batch = {} -- Converts the sprite into a sort of binary table...0 matches pixels with transparency
      for y = 0,h-1 do batch[y+1] = ''
         for x = 0,w-1 do
         local _,_,_,a = s:getPixel(x,y)
         batch[y+1] = ((a == 0) and batch[y+1]..' ' or batch[y+1]..'1')
         end
      end
      return { -- Returns a custom structure
               map = batch,  -- the 'binary' sprite
               x = 0, y = 0,   -- screen coordinates 
               width = w,  -- width
               height = h, -- height
               img = love.graphics.newImage(s),   -- userdata sprite image     
            }

end]]