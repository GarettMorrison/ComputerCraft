while true do
	non, data = turtle.inspectDown()
	if data.name ~= nil and data.name == "minecraft:sand" then
		turtle.digDown()
		turtle.suckDown()
		turtle.down()
	else
		turtle.forward()
	end


	non, data = turtle.inspect()
	if data.name ~= nil and data.name == "minecraft:sand" then
		turtle.dig()
		turtle.suck()
		os.sleep(0.5)
		turtle.forward()
	elseif data.name ~= nil then
		turtle.up()
	end
end
