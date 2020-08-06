X = 0
Y = 0
Z = -3
R = 0

compType = 0
--1 is miner

--Miner Vals
baseY = 0

lastX = 0
lastY = 0
lastZ = 0
lastR = 0

slotX = 0
slotZ = 0

baseY = 0

--Woodcutter Values


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
			turtle.drop()
		end
	end
end

local function resetAtTop()
	print("Dumping inventory")
	navigateTo(0,0,-2)
	navigateTo(0,0,0)
	dumpInventory()

	if turtle.getFuelLevel() < 1000 then
		navigateTo(0,1,-2)
		navigateTo(0,0,-2)
		rotateTo(1)
		turtle.select(1)
		turtle.suck(16)
		turtle.refuel()
		navigateTo(0,0,0)
	end
end


while not turtle.getSelectedSlot() do:
	print("---")
end
turtle.refuel(64)
print("Fueled up")

while not turtle.getSelectedSlot() do:
	print("---")
end
print("Got it")

if turtle.getItemDetail().name == "minecraft:diamond_axe" then
	print("Am Woodcutter")
end

navigateTo(0,0,0)
print("Bootup successful")





-- while true do
-- 	rotateTo(1)
-- 	turtle.suck(1)
-- 	rotateTo(0)

-- 	while turtle.detectDown() == false do
-- 		stepDown()
-- 	end

-- 	if Y > -40 then --Digging new shaft, go to spot a few blocks above bedrock
-- 		print("New Shaft")
-- 		notBedrock = true
-- 		while notBedrock do
-- 			turtle.digDown()
-- 			turtle.suckDown()
-- 			stepDown()
-- 			non, data = turtle.inspectDown()
-- 			if data.name == "minecraft:bedrock" then
-- 				notBedrock = false
-- 			end
-- 		end

-- 		navigateTo(X,Y+4,Z)

-- 		turtle.select(1)
-- 		turtle.placeDown()

-- 		baseY = Y

-- 		print("Placed Selector")


-- 		--Mine out ring
-- 		print("Mining first layer")
-- 		for radius = 1, 4, 1 do
-- 			tripleMine()
-- 			rotateTo(1)
-- 			while X < radius do tripleMine() end
-- 			rotateTo(2)
-- 			while Z > -1*radius do tripleMine() end
-- 			rotateTo(3)
-- 			while X > -1*radius do tripleMine() end
-- 			rotateTo(0)
-- 			while Z < radius do tripleMine() end
-- 			rotateTo(1)
-- 			while X ~= 0 do tripleMine() end
-- 			rotateTo(0)
-- 		end

-- 		--Dig upshaft
-- 		navigateTo(0, baseY, -2)
-- 		while Y <= 1 do
-- 			turtle.digUp()
-- 			turtle.suckUp()
-- 			stepUp()
-- 		end

-- 		--Dump inventory

-- 		resetAtTop()

-- 		navigateTo(0, baseY +3, 0)


-- 		print("Mining second layer")
-- 		--Mine out ring
-- 		rotateTo(0)
-- 		for radius = 1, 4, 1 do
-- 			tripleMine()
-- 			rotateTo(1)
-- 			while X < radius do tripleMine() end
-- 			rotateTo(2)
-- 			while Z > -1*radius do tripleMine() end
-- 			rotateTo(3)
-- 			while X > -1*radius do tripleMine() end
-- 			rotateTo(0)
-- 			while Z < radius do tripleMine() end
-- 			rotateTo(1)
-- 			while X ~= 0 do tripleMine() end
-- 			rotateTo(0)
-- 		end


-- 		--Dump inventory
-- 		navigateTo(0,Y,-2)
-- 		navigateTo(0,0,-2)
-- 		resetAtTop()

-- 	else --Dig new section
-- 		print("Mining new Section")

-- 		baseY = Y

-- 		while turtle.detectDown() do
-- 			stepForward()
-- 		end

-- 		while slotX == 0 and slotZ == 0 do
-- 			radius = Z

-- 			if radius == 1 then
-- 				navigateTo(1,baseY,1)
-- 				navigateTo(1,baseY,0)
-- 				if turtle.detectDown() ~= true then
-- 					slotX = X
-- 					slotZ = Z
-- 					break
-- 				end
-- 				navigateTo(1,baseY,-1)
-- 				navigateTo(0,baseY,-1)
-- 				if turtle.detectDown() ~= true then
-- 					slotX = X
-- 					slotZ = Z
-- 					break
-- 				end
-- 				navigateTo(-1,baseY,-1)
-- 				navigateTo(-1,baseY,0)
-- 				if turtle.detectDown() ~= true then
-- 					slotX = X
-- 					slotZ = Z
-- 					break
-- 				end
-- 				navigateTo(-1,baseY,1)
-- 				navigateTo(0,baseY,1)
-- 				if turtle.detectDown() ~= true then
-- 					slotX = X
-- 					slotZ = Z
-- 					break
-- 				end
-- 				rotateTo(0)
-- 				stepForward()
-- 			else --Wider radius
-- 				noSkip = true
-- 				while Z > 0 and noSkip do
-- 					navigateTo(X+1,Y,Z-1)
-- 					if turtle.detectDown() ~= true then
-- 						slotX = X
-- 						slotZ = Z
-- 						noSkip = false
-- 						break
-- 					end
-- 				end
-- 				while X > 0 and noSkip do
-- 					navigateTo(X-1,Y,Z-1)
-- 					if turtle.detectDown() ~= true then
-- 						slotX = X
-- 						slotZ = Z
-- 						noSkip = false
-- 						break
-- 					end
-- 				end
-- 				while Z < 0 and noSkip do
-- 					navigateTo(X-1,Y,Z+1)
-- 					if turtle.detectDown() ~= true then
-- 						slotX = X
-- 						slotZ = Z
-- 						noSkip = false
-- 						break
-- 					end
-- 				end
-- 				while X < 0 and noSkip do
-- 					navigateTo(X+1,Y,Z+1)
-- 					if turtle.detectDown() ~= true then
-- 						slotX = X
-- 						slotZ = Z
-- 						noSkip = false
-- 						break
-- 					end
-- 				end
-- 			end	
-- 		end

-- 		--Goto slot
-- 		turtle.placeDown()

-- 		mineTo(slotX*9, baseY, slotZ*9)


-- 		print("Mining first layer")
-- 		xCenter = X 
-- 		zCenter = Z

-- 		rotateTo(0)
-- 		for radius = 1, 4, 1 do
-- 			tripleMine()
-- 			rotateTo(1)
-- 			while X < xCenter +radius do tripleMine() end
-- 			rotateTo(2)
-- 			while Z > zCenter -radius do tripleMine() end
-- 			rotateTo(3)
-- 			while X > xCenter -radius do tripleMine() end
-- 			rotateTo(0)
-- 			while Z < zCenter +radius do tripleMine() end
-- 			rotateTo(1)
-- 			while X ~= xCenter do tripleMine() end
-- 			rotateTo(0)
-- 		end

-- 		mineTo(0,baseY+1,-2)	--Go to entrance of upshaft
-- 		navigateTo(0,0,-2) --Go up shaft
		
-- 		resetAtTop()
		
-- 		navigateTo(0,baseY +1, 0)

-- 		mineTo(slotX*9, baseY, slotZ*9)
-- 		mineTo(slotX*9, baseY +3, slotZ*9)

-- 		print("Mining second layer")

-- 		rotateTo(0)
-- 		for radius = 1, 4, 1 do
-- 			tripleMine()
-- 			rotateTo(1)
-- 			while X < xCenter +radius do tripleMine() end
-- 			rotateTo(2)
-- 			while Z > zCenter -radius do tripleMine() end
-- 			rotateTo(3)
-- 			while X > xCenter -radius do tripleMine() end
-- 			rotateTo(0)
-- 			while Z < zCenter +radius do tripleMine() end
-- 			rotateTo(1)
-- 			while X ~= xCenter do tripleMine() end
-- 			rotateTo(0)
-- 		end

-- 		mineTo(0,baseY+1,-2)	--Go to entrance of upshaft
-- 		navigateTo(0,0,-2) --Go up shaft
		
-- 		resetAtTop()
-- 	end
-- 	print("Restarting Loop")
-- 	baseY = 0

-- 	lastX = 0
-- 	lastY = 0
-- 	lastZ = 0
-- 	lastR = 0

-- 	slotX = 0
-- 	slotZ = 0

-- 	baseY = 0
-- end