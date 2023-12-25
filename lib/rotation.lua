local rotation = {}
local log4cc = require("lib.log4cc")
local inventory = require("lib.inventory")


--[[orientation will be:
-x = 1
- z = 2
+ x = 3
+ z = 4
]]--
function rotation.GetAbsoluteOrientation()
    inventory.Refuel()
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
        return 3 -- +x
    elseif x2 < x1 then
        return 1 -- -x
    elseif z2 > z1 then
        return 4 -- +z
    elseif z2 < z1 then
        return 2 -- -z
    else
        log4cc.error("No change in position detected")
        return nil, "No change in position detected"
    end
end


rotation._orientation = nil  -- Initialize orientation
function rotation.GetOrientation()
    if rotation._orientation == nil then
        rotation._orientation = rotation.GetAbsoluteOrientation()
        log4cc.info("current orientation " .. rotation._orientation)
    end
    return rotation._orientation
end

function rotation.TurnRight()
    turtle.turnRight()
    rotation._orientation = rotation.GetOrientation() % 4 + 1
end

function rotation.TurnLeft()
    turtle.turnLeft()
    rotation._orientation = (rotation.GetOrientation() + 2) % 4 + 1
end

function rotation.RotateTowards(desiredOrientation)
    log4cc.info("Rotating towards " .. desiredOrientation)
    while rotation.GetOrientation() ~= desiredOrientation do
        log4cc.debug("Current rotation " .. rotation.GetOrientation())
        log4cc.debug("\tDesired=" .. desiredOrientation)
        log4cc.debug("\tDiff=" .. desiredOrientation - rotation.GetOrientation())
        rotation.TurnRight()
    end
    log4cc.debug("Achieved rotation")
end


return rotation
