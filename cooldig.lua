


local tArgs = { ... }
if #tArgs ~= 1 then
	print( "Usage: cooldig <gridsize>" )
	return
end

local size = tonumber( tArgs[1] )
if size < 1 then
	print( "Grid size must be positive" )
	return
end

print("version 0.1")







dofile("cooldig/movement.lua")
dofile("cooldig/otherfunctions.lua")
dofile("cooldig/pattern.lua")

-- if not refuel() then
-- 	print( "Out of Fuel" )
-- 	return
-- end



print( "Excavating..." )
doIT(size)
print( "Returning to start..." )
-- Return to where we started
turnLeft()
unload( false )
turnRight()
print( "Mined "..(collected + unloaded).." items total." )
