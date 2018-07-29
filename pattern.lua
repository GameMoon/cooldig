
--jobbra elore
function makeColumn()
	print( "debug:makeColumn" )
    turnRight()
    tryForward()
    tryForward()
    turnLeft()
    tryForward()
end
--balra hatra
function reverseColumn()
	print( "debug:reverseColumn" )
    tryBack()
    turnLeft()
    tryForward()
    tryForward()
    turnRight()
end
--egy sorral hatra
function makeRow()
	print( "debug:makeRow" )
    tryBack()
    tryBack()
    turnRight()
    tryForward()
    turnLeft()
end
--egy sorral elore
function reverseRow()
	print( "debug:reverseRow" )
    turnLeft()
    tryForward()
    turnRight()
    tryForward()
    tryForward()
end


function mineHere()
	print( "debug:mineHere" )
  print("I shall Mine here...")
  oneDown()
end


function doIT(patternSize)
	print( "debug:doIT" )
    mineHere()
    for i=0,patternSize-1,1 do
        --Sor készítés
        for y=0,patternSize-2,1 do
            makeColumn()
            mineHere()
        end

        for x=0,patternSize-2,1 do
            reverseColumn()
        end

        if i < patternSize-1 then
            makeRow()
            mineHere()
        end
     end
    for i=0,patternSize-2,1 do
        reverseRow()
    end
   
end
