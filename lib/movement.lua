local log4cc = require("lib.log4cc")
local inventory = require("lib.inventory")
local rotation = require("lib.rotation")
local locations = require("lib.locations")
local utils    = require("lib.utils")
local movement = {}

function movement.MineToX(TargetX, digHuman)
    local x, y, z = movement.GetXYZ()
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
        movement.DigMove(digHuman)
        x, y, z = movement.GetXYZ()
    end

    log4cc.debug("Arrived at x=" .. TargetX)
end

function movement.MineToZ(TargetZ, digHuman)
    local x, y, z = movement.GetXYZ()
    log4cc.debug("Currently at z=" .. z)
    log4cc.debug("Going to target z=" .. TargetZ)

    if z == TargetZ then
        log4cc.debug("Arrived at z=" .. TargetZ)
        return
    end

    local desiredOrientation = utils.Sign(TargetZ - z) + 3
    rotation.RotateTowards(desiredOrientation)

    while utils.Sign(TargetZ - z) ~= 0 do
        movement.DigMove(digHuman)
        x, y, z = movement.GetXYZ()
    end
    log4cc.debug("Arrived at z=" .. TargetZ)
end

function movement.DigStairDown(TargetY, shouldPlace)
    if shouldPlace == nil then
        shouldPlace = true
    end
    log4cc.info("Digging stair down")
    x, y, z = movement.GetXYZ()
    while y > TargetY do
        movement.DigMove(false)
        turtle.digDown()
        turtle.down()
        if shouldPlace then
            inventory.PlaceDown()
        end
        rotation.TurnRight()
        x, y, z = movement.GetXYZ()
    end
end

function movement.DigStairUp(TargetY, shouldPlace)
    if shouldPlace == nil then
        shouldPlace = true
    end
    log4cc.info("Digging stair up")
    x, y, z = movement.GetXYZ()
    while y < TargetY do
        movement.DigMove(false)
        turtle.up()
        turtle.digUp()
        if shouldPlace then
            inventory.PlaceDown()
        end
        rotation.TurnLeft()
        x, y, z = movement.GetXYZ()
    end
end

function movement.MineToY(TargetY)
    local x, y, z = movement.GetXYZ()
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

function movement.MineToXYZHuman(TargetX, TargetY, TargetZ)
    log4cc.info("Mining to position " .. utils.CoordString(TargetX, TargetY, TargetZ))
    local x, y, z = movement.GetXYZ()
    rotation.RotateTowards((y % 4) + 1)
    movement.MineToY(TargetY)
    movement.MineToX(TargetX, true)
    movement.MineToZ(TargetZ, true)
    -- Standardize rotation in order to have uniform stairs
end

function movement.MineToPositionHuman(pos)
    movement.MineToXYZHuman(pos.x, pos.y, pos.z)
end

function movement.GetXYZ()
    local x, y, z = gps.locate(5, false)
    if not x then
        log4cc.debug("Failed to get my location!")
    else
        return math.floor(x), math.floor(y), math.floor(z)
    end
end

function movement.GetPos()
    local x, y, z = movement.GetXYZ()
    return vector.new(x, y, z)
end

function movement.DigMove(shouldPlace, digHuman)
    if digHuman == nil then
        digHuman = true
    end

    if shouldPlace == nil then
        shouldPlace = true
    end

    inventory.Refuel()
    if turtle.detect() then
        turtle.dig()
    end

    turtle.forward()

    if digHuman and turtle.detectUp() then
        turtle.digUp()
    end
    
    if shouldPlace then
        inventory.PlaceDown()
    end
end

function movement.ReturnHome()
    log4cc.info("Returning Home")
    local x, y, z = movement.GetXYZ()
    local chuteBase = vectors.new(locations.chuteTop.x, y, locations.chuteTop.z)
    movement.MineToPositionHuman(chuteBase)
    movement.MineToPositionHuman(locations.chuteTop)
    log4cc.info("Dumping items")
    movement.MineToPositionHuman(locations.dumpChest + vector.new(0, 1, 0))
    inventory.EmptyInventory(turtle.dropDown)
    movement.MineToPositionHuman(locations.home)
    rotation.RotateTowards(3) -- +x
end

return movement