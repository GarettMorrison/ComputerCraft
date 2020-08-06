--Install using pastebin run

print("Installing simple turtle functions")

local quarry = fs.open("quarry", "w")
local str = http.get("https://raw.githubusercontent.com/GarettMorrison/ComputerCraft/master/simple/quarry.lua").readAll()
quarry.write(str)
quarry.close()

local sand = fs.open("sand", "w")
str = http.get("https://raw.githubusercontent.com/GarettMorrison/ComputerCraft/master/simple/sand.lua").readAll()
sand.write(str)
sand.close()

local fuel = fs.open("fuel", "w")
str = http.get("https://raw.githubusercontent.com/GarettMorrison/ComputerCraft/master/simple/refuel.lua").readAll()
fuel.write(str)
fuel.close()
