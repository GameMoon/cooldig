--jobbra elore
function makeColumn()
    turnRight()
    tryForward()
    tryForward()
    turnLeft()
    tryForward()
end
--balra hatra
function reverseColumn()
    tryBack()
    turnLeft()
    tryForward()
    tryForward()
    turnRight()
end
--egy sorral hatra
function makeRow()
    tryBack()
    tryBack()
    turnRight()
    tryForward()
    turnLeft()
end
--egy sorral elore
function reverseRow()
    turnLeft()
    tryForward()
    turnRight()
    tryForward()
    tryForward()
end

function mineHere()
  print("I shall Mine here...")
  oneDown()
end


function doIT(patternSize)
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
