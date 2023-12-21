local rotation = {}
local log4cc = require("lib.log4cc")


--[[orientation will be:
-x = 1
- z = 2
+ x = 3
+ z = 4
]]--
function rotation.GetAbsoluteOrientation()
    local x1, y1, z1 = gps.locate()
    local blockDetected = turtle.detect()

    if blockDetected then
        turtle.select(16)
        turtle.dig()
    end

    turtle.forward()

    local x2, y2, z2 = gps.locate()
    turtle.back()

    if blockDetected then
        turtle.place()
    end

    if x2 > x1 then
        return 2 -- +x
    elseif x2 < x1 then
        return 0 -- -x
    elseif z2 > z1 then
        return 3 -- +z
    elseif z2 < z1 then
        return 1 -- -z
    else
        return nil, "No change in position detected"
    end
end


rotation._orientation = rotation.GetAbsoluteOrientation()  -- Initialize orientation
log4cc.info("current orientation " .. rotation._orientation)
function rotation.GetOrientation()
    return rotation._orientation
end

function rotation.TurnRight()
    turtle.turnRight()
    rotation._orientation = rotation._orientation % 4 + 1
end

function rotation.TurnLeft()
    turtle.turnLeft()
    rotation._orientation = (rotation._orientation + 2) % 4 + 1
end

function rotation.RotateTowards(desiredOrientation)
    log4cc.info("Rotating towards " .. desiredOrientation)
    while rotation.GetOrientation() ~= desiredOrientation do
        log4cc.info("Current rotation " .. rotation.GetOrientation())
        log4cc.info("\tDesired=" .. desiredOrientation)
        log4cc.info("\tDiff=" .. desiredOrientation - rotation.GetOrientation())
        rotation.TurnRight()
    end
    log4cc.info("Achieved rotation")
end


return rotation
