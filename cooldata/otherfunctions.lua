depth = 0
unloaded = 0
collected = 0
xPos,zPos = 0,0
xDir,zDir = 0,1

function unload( _bKeepOneFuelStack )
    local numberofTurns = 0
    success,data = turtle.inspect()
    while data.name ~="minecraft:chest" and numberofTurns < 4 do
        turnRight()
        numberofTurns = numberofTurns + 1
        success,data = turtle.inspect()
		if numberofTurns == 4 then
			print("No chest found, press any key to continue...")
			read()
			numberofTurns = 0
			success,data = turtle.inspect()
		end
    end
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
    for i = 0,numberofTurns do
        turnLeft()
    end
end

function returnSupplies()
	local x,y,z,xd,zd = xPos,depth,zPos,xDir,zDir
	print( "Returning supplies..." )
	goTo( 0,0,0,0,-1 )
	local fuelNeeded = 2*(math.abs(x)+math.abs(y)+math.abs(z))+1
	if not refuel( fuelNeeded ) then
		unload( true )
		print( "Waiting for fuel" )
		while not refuel( fuelNeeded ) do
            os.pullEventRaw( "turtle_inventory" )
            sleep( 0.3 )
		end
	else
		unload( true )	
	end
	
	print( "Resuming mining..." )
	goTo( x,y,z,xd,zd )
end

function collect()
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

function calculateNeeded()
    return math.abs(xPos) + math.abs(zPos) + math.abs(depth) + 2
end

function neededFuel(ammount)
     if not ammount then
        return calculateNeeded()
    else 
        return ammount
    end
end

function refuel( ammount )
    local fuelLevel = turtle.getFuelLevel()
	if fuelLevel == "unlimited" then
		return true
	end
    local neededFuel = neededFuel(ammount)
	if fuelLevel < neededFuel then
		local fueled = false
		for n=1,16 do
			if turtle.getItemCount(n) > 0 then
                turtle.select(n)
				if turtle.refuel(1) then
					while turtle.getItemCount(n) > 0 and turtle.getFuelLevel() < neededFuel do
                        if not turtle.refuel(1) then
                            break
                        end
					end
					if turtle.getFuelLevel() >= neededFuel then
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
