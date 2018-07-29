
function tryForward()
printPos()
		print( "debug:tryForward" )
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
	
	while not turtle.forward() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end
	
	xPos = xPos + xDir
	zPos = zPos + zDir
	return true
end

function tryBack()
printPos()
		print( "debug:tryBack" )
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
    if turtle.back() == false then
    turnRight()
    turnRight()
    while not turtle.forward() do
		if turtle.detect() then
			if turtle.dig() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attack() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
    end
    turnRight()
    turnRight()
    end
	xPos = xPos - xDir
	zPos = zPos - zDir
    return true
end


function tryDown()
printPos()
	print( "debug:tryDown" )
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
	
	while not turtle.down() do
		if turtle.detectDown() then
			if turtle.digDown() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attackDown() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end

	depth = depth + 1
	return true
end

function tryUp()
printPos()
	print( "debug:tryUp" )
	if not refuel() then
		print( "Not enough Fuel" )
		returnSupplies()
	end
	
	while not turtle.up() do
		if turtle.detectUp() then
			if turtle.digUp() then
				if not collect() then
					returnSupplies()
				end
			else
				return false
			end
		elseif turtle.attackUp() then
			if not collect() then
				returnSupplies()
			end
		else
			sleep( 0.5 )
		end
	end
	depth = depth - 1
	return true
end

function turnLeft()
    printPos()
	turtle.turnLeft()
	xDir, zDir = -zDir, xDir
end

function turnRight()
    printPos()
	turtle.turnRight()
	xDir, zDir = zDir, -xDir
end

-- function goTo( x, y, z, xd, zd )
-- printPos()
-- 	print( "debug:goTo" )
-- 	while depth > y do
-- 		tryUp()
-- 	end

-- 	if xPos > x then
-- 		while xDir ~= -1 do
-- 			turnLeft()
-- 		end
-- 		while xPos > x do
-- 			tryForward()
-- 		end
-- 	elseif xPos < x then
-- 		while xDir ~= 1 do
-- 			turnLeft()
-- 		end
-- 		while xPos < x do
-- 			tryForward()
-- 		end
-- 	end
	
-- 	if zPos > z then
-- 		while zDir ~= -1 do
-- 			turnLeft()
-- 		end
-- 		while zPos > z do
-- 			tryForward()
-- 		end
-- 	elseif zPos < z then
-- 		while zDir ~= 1 do
-- 			turnLeft()
-- 		end
-- 		while zPos < z do
-- 			tryForward()
-- 		end	
-- 	end
	
-- 	while depth < y do
-- 		tryDown()
-- 	end
	
-- 	while zDir ~= zd or xDir ~= xd do
-- 		turnLeft()
-- 	end
-- end
function goTo( x, y, z, xd, zd )
	while depth > y do
		if turtle.up() then
			depth = depth - 1
		elseif turtle.digUp() or turtle.attackUp() then
			collect()
		else
			sleep( 0.5 )
		end
	end

	if xPos > x then
		while xDir ~= -1 do
			turnLeft()
		end
		while xPos > x do
			if turtle.forward() then
				xPos = xPos - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif xPos < x then
		while xDir ~= 1 do
			turnLeft()
		end
		while xPos < x do
			if turtle.forward() then
				xPos = xPos + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	end
	
	if zPos > z then
		while zDir ~= -1 do
			turnLeft()
		end
		while zPos > z do
			if turtle.forward() then
				zPos = zPos - 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end
	elseif zPos < z then
		while zDir ~= 1 do
			turnLeft()
		end
		while zPos < z do
			if turtle.forward() then
				zPos = zPos + 1
			elseif turtle.dig() or turtle.attack() then
				collect()
			else
				sleep( 0.5 )
			end
		end	
	end
	
	while depth < y do
		if turtle.down() then
			depth = depth + 1
		elseif turtle.digDown() or turtle.attackDown() then
			collect()
		else
			sleep( 0.5 )
		end
	end
	
	while zDir ~= zd or xDir ~= xd do
		turnLeft()
	end
end