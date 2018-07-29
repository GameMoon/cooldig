

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
local depth = 0
local unloaded = 0
local collected = 0

local xPos,zPos = 0,0
local xDir,zDir = 0,1

function printPos()
    local dbgfuel = turtle.getFuelLevel()
    print("xPos","\t","zPos","\t","xDir","\t","zDir","\t","fuel")
    print(xPos,"\t\t\t\t",zPos,"\t\t\t\t",xDir,"\t\t\t\t",zDir,"\t\t\t\t",dbgfuel)
end

local goTo -- Filled in further down
local refuel -- Filled in further down

dofile("cooldig/pattern.lua")
dofile("cooldig/movement.lua")

function unload( _bKeepOneFuelStack )
	print( "debug:unload" )
	turnRight()
	print( "Unloading items..." )
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount > 0 then
			turtle.select(n)			
			local bDrop = true
			if _bKeepOneFuelStack and turtle.refuel(0) then
				bDrop = false
				_bKeepOneFuelStack = false
			end			
			if bDrop then
				turtle.drop()
				unloaded = unloaded + nCount
			end
		end
	end
	collected = 0
	turtle.select(1)
	turnLeft()
end

function returnSupplies()
	print( "debug:returnSupplies" )
	local x,y,z,xd,zd = xPos,depth,zPos,xDir,zDir
	print( "Returning to surface..." )
	goTo( 0,0,0,0,-1 )
	
	local fuelNeeded = 2*(x+y+z)+1
	if not refuel( fuelNeeded ) then
		unload( true )
		print( "Waiting for fuel" )
		while not refuel( fuelNeeded ) do
			os.pullEvent( "turtle_inventory" )
		end
	else
		unload( true )	
	end
	
	print( "Resuming mining..." )
	goTo( x,y,z,xd,zd )
end

function collect()
	print( "debug:collect" )	
	local bFull = true
	local nTotalItems = 0
	for n=1,16 do
		local nCount = turtle.getItemCount(n)
		if nCount == 0 then
			bFull = false
		end
		nTotalItems = nTotalItems + nCount
	end
	
	if nTotalItems > collected then
		collected = nTotalItems
		if math.fmod(collected + unloaded, 50) == 0 then
			print( "Mined "..(collected + unloaded).." items." )
		end
	end
	
	if bFull then
		print( "No empty slots left." )
		return false
	end
	return true
end

function refuel( ammount )
	print( "debug:refuel" )
	local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" then
		return true
	end
	
    local needed = ammount or (xPos + zPos + depth + 2)
    print(" calculated fuel: "..needed)
	if turtle.getFuelLevel() < needed then
		local fueled = false
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
				turtle.select(n)
				if turtle.refuel(1) then
					while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < needed do
						turtle.refuel(1)
					end
					if turtle.getFuelLevel() >= needed then
						turtle.select(1)
						print( "I Just refueled..." )
						return true
					end
				end
			end
		end
		turtle.select(1)
		return false
	end
	
	return true
end

function oneDown()
	print( "debug:oneDown" )
    local distdown =0

    while tryDown() do
        for n=1,4 do
            mine()
            turnRight()
        end	
        distdown=distdown+1
    end

    while distdown>0 do
        tryUp()
        distdown=distdown-1
    end
end

function tryDig()
printPos()
	print( "debug:tryDig" )
		if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
    while turtle.detect() do
        if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
    end
end

function mine()
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
	print( "debug:mine" )
    local forbiddenBlocks = {
        "minecraft:stone",
        "minecraft:gravel",
        "minecraft:sand",
        "minecraft:dirt",
        "minecraft:grass_block",
        "minecraft:grass",
        "minecraft:cobblestone",
        "minecraft:bedrock"
    }
    success,data = turtle.inspect()
    blockName = data.name
    isForbidden = false
    table.foreach(forbiddenBlocks,
        function(key,value)
            if value == blockName then
                isForbidden = true
                return
            end
        end
    )
   
    if isForbidden == false then
        tryDig()
    end
    return not isForbidden
end


if not refuel() then
	print( "Out of Fuel" )
	return
end

print( "Excavating..." )
doIT(size)
print( "Returning to start..." )
-- Return to where we started
turnLeft()
unload( false )
turnRight()
print( "Mined "..(collected + unloaded).." items total." )
