X = 0
Y = 0
Z = -3
R = 0

baseY = 0

lastX = 0
lastY = 0
lastZ = 0
lastR = 0

slotX = 0
slotZ = 0

baseY = 0

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
	return moveCheck
end

local function stepDown()
	moveCheck = turtle.down()
	if moveCheck then
		Y = Y - 1
	end
	return moveCheck
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
	return moveCheck
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

turn = 1
while true do 
	if not turtle.detectDown() then
		turtle.stepDown()
	end
	if not stepForward() then
		if not stepUp() then
			if turn == 1 then
				turnRight()
				turn = 2
			else 
				turnLeft()
				turn = 1
			end
		end
	end
	turtle.attack()
end
