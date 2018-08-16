local tArgs = { ... }
local size = tonumber( tArgs[1] )
local path = "/"..fs.getDir(shell.getRunningProgram())

dofile(path.."/movement.lua")
dofile(path.."/otherfunctions.lua")
dofile(path.."/pattern.lua")

if not refuel() then
	print( "Out of Fuel" )
	return
end

print( "Excavating..." )

doIT(size)
print( "Returning to start..." )
-- Return to where we started
unload( false )
print( "Mined "..(collected + unloaded).." items total." )
