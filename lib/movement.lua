local log4cc = require("lib.log4cc")
local inventory = require("lib.inventory")
local rotation = require("lib.rotation")
local locations = require("lib.locations")
local utils    = require("lib.utils")
local movement = {}

function movement.MineToX(TargetX)
    local x, y, z = movement.GetPos()
    log4cc.debug("Currently at x=" .. x)
    log4cc.debug("Going to target x=" .. TargetX)

    if x == TargetX then
        log4cc.debug("Arrived at x=" .. TargetX)
        return
    end

    local desiredOrientation = utils.Sign(TargetX - x) + 2
    if desiredOrientation == 2 then
        log4cc.debug("Arrived at x=" .. TargetX)
        return -- we are already at the correct X
    end
    rotation.RotateTowards(desiredOrientation)

    while utils.Sign(TargetX - x) ~= 0 do
        movement.DigMove()
        x, y, z = movement.GetPos()
    end

    log4cc.debug("Arrived at x=" .. TargetX)
end

function movement.MineToZ(TargetZ)
    local x, y, z = movement.GetPos()
    log4cc.debug("Currently at z=" .. z)
    log4cc.debug("Going to target z=" .. TargetZ)

    if z == TargetZ then
        log4cc.debug("Arrived at z=" .. TargetZ)
        return
    end

    local desiredOrientation = utils.Sign(TargetZ - z) + 3
    rotation.RotateTowards(desiredOrientation)

    while utils.Sign(TargetZ - z) ~= 0 do
        movement.DigMove()
        x, y, z = movement.GetPos()
    end
    log4cc.debug("Arrived at z=" .. TargetZ)
end

function movement.DigStairDown(TargetY, shouldPlace)
    if shouldPlace == nil then
        shouldPlace = true
    end
    log4cc.info("Digging stair down")
    x, y, z = movement.GetPos()
    while y > TargetY do
        movement.DigMove(false)
        turtle.digDown()
        turtle.down()
        if shouldPlace then
            inventory.PlaceDown()
        end
        rotation.TurnRight()
        x, y, z = movement.GetPos()
    end
end

function movement.DigStairUp(TargetY, shouldPlace)
    if shouldPlace == nil then
        shouldPlace = true
    end
    log4cc.info("Digging stair up")
    x, y, z = movement.GetPos()
    while y < TargetY do
        movement.DigMove(false)
        turtle.up()
        turtle.digUp()
        if shouldPlace then
            inventory.PlaceDown()
        end
        rotation.TurnLeft()
        x, y, z = movement.GetPos()
    end
end

function movement.MineToY(TargetY)
    local x, y, z = movement.GetPos()
    log4cc.debug("Currently at y=" .. y)
    log4cc.debug("Going to target y=" .. TargetY)

    if y == TargetY then
        log4cc.debug("Arrived at y=" .. TargetY)
        return
    end

    StairDig = y > TargetY and movement.DigStairDown or movement.DigStairUp
    StairDig(TargetY)

    log4cc.debug("Arrived at y=" .. TargetY)
end

function movement.MineToXYZ(TargetX, TargetY, TargetZ)
    log4cc.info("Mining to position " .. utils.CoordString(TargetX, TargetY, TargetZ))
    -- Standardize rotation in order to have uniform stairs
    local x, y, z = movement.GetPos()
    movement.MineToX(TargetX)
    movement.MineToZ(TargetZ)
    rotation.RotateTowards(y % 4)
    movement.MineToY(TargetY)
end

function movement.MineToPosition(pos)
    movement.MineToXYZ(pos.x, pos.y, pos.z)
end

function movement.GetPos()
    local x, y, z = gps.locate(5, false)
    if not x then
        log4cc.debug("Failed to get my location!")
    else
        return math.floor(x), math.floor(y), math.floor(z)
    end
end

function movement.DigMove(shouldPlace)
    if shouldPlace == nil then
        shouldPlace = true
    end

    inventory.Refuel()
    if turtle.detect() then
        turtle.dig()
    end

    turtle.forward()

    if turtle.detectUp() then
        turtle.digUp()
    end
    
    if shouldPlace then
        inventory.PlaceDown()
    end
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