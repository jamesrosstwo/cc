local log4cc = require("lib.log4cc")
local inventory = require("lib.inventory")
local rotation = require("lib.rotation")
local locations = require("lib.locations")
local utils    = require("lib.utils")
local movement = {}

function movement.MineToX(TargetX)
    local x, y, z = movement.GetPos()
    log4cc.info("Currently at x=" .. x)
    log4cc.info("Going to target x=" .. TargetX)

    if x == TargetX then
        log4cc.info("Arrived at x=" .. TargetX)
        return
    end

    local desiredOrientation = utils.sign(TargetX - x) + 2
    if desiredOrientation == 2 then
        log4cc.info("Arrived at x=" .. TargetX)
        return -- we are already at the correct X
    end
    rotation.RotateTowards(desiredOrientation)

    while utils.sign(TargetX - x) ~= 0 do
        movement.DigMove()
        x, y, z = movement.GetPos()
    end

    log4cc.info("Arrived at x=" .. TargetX)
end

function movement.MineToZ(TargetZ)
    local x, y, z = movement.GetPos()
    log4cc.info("Currently at z=" .. z)
    log4cc.info("Going to target z=" .. TargetZ)

    if z == TargetZ then
        log4cc.info("Arrived at z=" .. TargetZ)
        return
    end

    local desiredOrientation = utils.sign(TargetZ - z) + 3
    rotation.RotateTowards(desiredOrientation)

    while utils.sign(TargetZ - z) ~= 0 do
        movement.DigMove()
        x, y, z = movement.GetPos()
    end
    log4cc.info("Arrived at z=" .. TargetZ)
end

function movement.MineToY(TargetY)
    local x, y, z = movement.GetPos()
    log4cc.info("Currently at y=" .. y)
    log4cc.info("Going to target y=" .. TargetY)

    if y == TargetY then
        log4cc.info("Arrived at y=" .. TargetY)
        return
    end

    while utils.sign(y - TargetY) ~= 0 do
        local MineFn = y > TargetY and turtle.digDown or turtle.digUp
        local DetectFn = y > TargetY and turtle.detectDown or turtle.detectUp
        local MoveFn = y > TargetY and turtle.down or turtle.up

        inventory.Refuel()
        if DetectFn() then
            MineFn()
        end
        MoveFn()
        x, y, z = movement.GetPos()
    end
    log4cc.info("Arrived at y=" .. TargetY)
end

function movement.MineToXYZ(TargetX, TargetY, TargetZ)
    log4cc.info("Mining to position " .. utils.CoordString(TargetX, TargetY, TargetZ))
    movement.MineToY(TargetY)
    movement.MineToX(TargetX)
    movement.MineToZ(TargetZ)
end

function movement.MineToPosition(pos)
    movement.MineToXYZ(pos.x, pos.y, pos.z)
end

function movement.GetPos()
    local x, y, z = gps.locate(5, false)
    if not x then
        log4cc.info("Failed to get my location!")
    else
        return math.floor(x), math.floor(y), math.floor(z)
    end
end

function movement.DigMove()
    inventory.Refuel()
    if turtle.detect() then
        turtle.dig()
    end

    turtle.forward()

    if turtle.detectUp() then
        turtle.digUp()
    end
    
    inventory.placeDown()

end

function movement.ReturnHome()
    log4cc.info("Returning Home")
    movement.MineToPosition(locations.chuteTop)
    rotation.RotateTowards(3) -- +x
    while not turtle.detectDown() do
        turtle.down()
    end
end

function movement.LeaveHome()
    log4cc.info("Leaving Home")
    movement.MineToPosition(locations.chuteTop)
end

return movement