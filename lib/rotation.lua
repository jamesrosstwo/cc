local rotation = {}
local log4cc = require("lib.log4cc")

function rotation.GetAbsoluteOrientation()
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

rotation.orientation = rotation.GetAbsoluteOrientation()  -- Initialize orientation

function rotation.GetOrientation()
    return rotation.orientation
end

function rotation.TurnRight()
    turtle.turnRight()
    rotation.orientation = (orientation + 1) % 4
end

function rotation.TurnLeft()
    turtle.turnLeft()
    rotation.orientation = (orientation + 3) % 4
end


function rotation.RotateTowards(desiredOrientation, currentOrientation)
    log4cc.info("Rotating towards " .. desiredOrientation)
    while currentOrientation ~= desiredOrientation do
        -- log4cc.info("Current rotation " .. rotation.GetOrientation())
        -- log4cc.info("\tDesired=" .. desiredOrientation)
        -- log4cc.info("\tDiff=" .. desiredOrientation - rotation.GetOrientation())
        rotation.TurnRight()
    end
    log4cc.info("Achieved rotation")
end


return rotation
