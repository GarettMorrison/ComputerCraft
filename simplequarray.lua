X = 0
Y = 0
Z = 0
R = 0

local function turnRight()
	turtle.turnRight()
	R = R + 1
	if R > 3 then
		R = 0
	end	
end

local function turnLeft()
	turtle.turnLeft()
	R = R - 1
	if R < 0 then
		R = 3
	end
end

local function stepUp()
	moveCheck = turtle.up()
	if moveCheck then
		Y = Y + 1
	end
end

local function stepDown()
	moveCheck = turtle.down()
	if moveCheck then
		Y = Y - 1
	end
end

local function stepForward()
	moveCheck = turtle.forward()

	if moveCheck then
		if R == 0 then
			Z = Z + 1
		elseif R == 1 then
			X = X + 1
		elseif R == 2 then
			Z = Z - 1
		elseif R == 3 then
			X = X - 1
		end
	end
end

local function rotateTo(numIn)
	while R ~= numIn do
		if R - numIn == 1 or R - numIn == -3 then
			turnLeft()
		elseif R - numIn == -1 or R - numIn == 3 then
			turnRight()
		else 
			turnRight()
		end
	end
end

local function mineTowards(xIn, yIn, zIn)
	if xIn > X then
		rotateTo(1)
		non, data = turtle.inspect()
		if data.name ~= nil then
			if string.sub(data.name,1,13) ~= "computercraft" then
				turtle.dig()
				turtle.suck() 
			end
		end
		stepForward()
	elseif xIn < X then
		rotateTo(3)
		non, data = turtle.inspect()
		if data.name ~= nil then
			if string.sub(data.name,1,13) ~= "computercraft" then
				turtle.dig()
				turtle.suck() 
			end
		end
		stepForward()
	end

	if zIn > Z then
		rotateTo(0)
		non, data = turtle.inspect()
		if data.name ~= nil then
			if string.sub(data.name,1,13) ~= "computercraft" then
				turtle.dig()
				turtle.suck() 
			end
		end
		stepForward()
	elseif zIn < Z then
		rotateTo(2)
		non, data = turtle.inspect()
		if data.name ~= nil then
			if string.sub(data.name,1,13) ~= "computercraft" then
				turtle.dig()
				turtle.suck() 
			end
		end
		stepForward()
	end

	if yIn > Y then
		non, data = turtle.inspectUp()
		if data.name ~= nil then
			if string.sub(data.name,1,13) ~= "computercraft" then
				turtle.digUp()
				turtle.suckUp()
			end
		end
		stepUp()
	elseif yIn < Y then
		non, data = turtle.inspectDown()
		if data.name ~= nil then
			if string.sub(data.name,1,13) ~= "computercraft" then
				turtle.digDown()
				turtle.suckDown()
			end
		end
		stepDown()
	end
end

local function mineTo(xIn, yIn, zIn)
	while X ~= xIn or Y ~= yIn or Z ~= zIn do
			mineTowards(xIn, yIn, zIn)
	end
end

local function moveTowards(xIn, yIn, zIn)
	if xIn > X then
		rotateTo(1)
		stepForward()
	elseif xIn < X then
		rotateTo(3)
		stepForward()
	end

	if zIn > Z then
		rotateTo(0)
		stepForward()
	elseif zIn < Z then
		rotateTo(2)
		stepForward()
	end

	if yIn > Y then
		stepUp()
	elseif yIn < Y then
		stepDown()
	end
end

local function navigateTo(xIn, yIn, zIn)
	while X ~= xIn or Y ~= yIn or Z ~= zIn do
		moveTowards(xIn, yIn, zIn)
	end
end



local function tripleMine()
	--mine forward block
	if turtle.detect() then turtle.dig() end
	stepForward()

	--Mine up, or remove lava
	if turtle.detectUp() then
		turtle.digUp()
		turtle.suckUp()
	else
		non, data = turtle.inspectUp()
		if data.name == "minecraft:lava" then
			stepUp()
			stepDown()
		end
	end

	--Mine down, or remove lava
	if turtle.detectDown() then
		turtle.digDown()
		turtle.suckDown()
	else
		non, data = turtle.inspectDown()
		if data.name == "minecraft:lava" then
			stepDown()
			stepUp()
		end
	end
end

local function dumpInventory()	
	for i=1,16,1 do
		turtle.select(i)
		while turtle.getItemCount() > 0 do
			turtle.dropDown()
		end
	end
end

local function dumpItem(input)	
	for i=1,16,1 do
		turtle.select(i)
		while (turtle.getItemCount() > 0 and turtle.getItemDetail().name == input) do
			turtle.drop()
		end
	end
end

-----------------------------------------------------------------------------------------------------------------
while true do
	rotateTo(2)
	print("Dumping cobble")
	dumpItem("minecraft:cobblestone") --Dump cobble
	print("Dumping inv")
	dumpInventory()

	if turtle.getFuelLevel() < 600 then --Make Sure fueled
		print("Refueling")
		rotateTo(3)
		turtle.select(16)
		turtle.suck(64)
		turtle.refuel(64)
	end
	
	rotateTo(0)
	while turtle.detect() ~= true do stepForward() end
	print("Found lane")

	tripleMine() --Mine section
	turnLeft()
	while X > -40 do tripleMine() end

	print("Returning")
	navigateTo(0,1,Z) --Return
	navigateTo(0,1,0)

	navigateTo(0,0,0)
end

navigateTo(0,1,-20)


