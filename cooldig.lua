local path = "/"..fs.getDir( shell.getRunningProgram() )
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

term.clear()
term.setCursorPos( 1,1 )
print( "version 1.0.1" )
shell.run( path.."cooldata/main "..size )