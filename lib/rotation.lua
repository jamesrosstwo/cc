local rotation = {}
local log4cc = require("log4cc")  -- Assuming log4cc is in the same folder

function rotation.getAbsoluteOrientation()
    log4cc.info("Getting absolute rotation")
    local loc1 = vector.new(gps.locate(2, false))
    if not turtle.forward() then
        for j = 1, 6 do
            if not turtle.forward() then
                turtle.dig()
            else
                break
            end
        end
    end
    local loc2 = vector.new(gps.locate(2, false))
    local heading = loc2 - loc1
    return math.floor((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
end

rotation.orientation = rotation.getAbsoluteOrientation()  -- Initialize orientation

function rotation.getOrientation()
    return rotation.orientation
end

function rotation.turnRight()
    turtle.turnRight()
    rotation.orientation = rotation.orientation % 4 + 1
end

function rotation.turnLeft()
    turtle.turnLeft()
    rotation.orientation = (rotation.orientation + 2) % 4 + 1
end

function rotation.rotateTowards(desiredOrientation, currentOrientation)
    log4cc.info("Rotating towards " .. desiredOrientation)
    while currentOrientation ~= desiredOrientation do
        -- log4cc.info("Current rotation " .. getOrientation())
        -- log4cc.info("\tDesired=" .. desiredOrientation)
        -- log4cc.info("\tDiff=" .. desiredOrientation - getOrientation())
        rotation.turnRight()
    end
    log4cc.info("Achieved rotation")
end


return rotation
