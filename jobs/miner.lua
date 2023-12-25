local inventory = require("lib.inventory")
inventory.Refuel()


local log4cc = require("lib.log4cc")
local movement = require("lib.movement")
local rotation = require("lib.rotation")
local utils = require("lib.utils")
local resources = require("lib.resources")
local locations = require("lib.locations")


function FindNewPath(StartRange, DesiredAlt)
    local px = math.random(-StartRange, StartRange)
    local pz = math.random(-StartRange, StartRange)
    log4cc.info("Finding new path start: \n\t" .. utils.CoordString(px, pz, DesiredAlt))
    x, y, z = movement.GetXYZ()
    movement.MineToXYZHuman(x + px, DesiredAlt, z + pz)
end

function movement.MineAdjacentOres()
    local success, data = turtle.inspectUp()
    local sx, sy, sz = movement.GetXYZ()
    local startRot = rotation.GetOrientation()
    local reDig = false
    while success and resources.OreIDs[data.name] do
        turtle.digUp()
        turtle.up()
        success, data = turtle.inspectUp()
        reDig = true
    end
    if reDig then
        movement.MineToXYZHuman(sx, sy, sz)
        rotation.RotateTowards(startRot)
    end

    success, data = turtle.inspectDown()
    reDig = false
    startRot = rotation.GetOrientation()
    while success and resources.OreIDs[data.name] do
        turtle.digDown()
        turtle.down()
        success, data = turtle.inspectDown()
        reDig = true
    end
    if reDig then
        movement.MineToXYZHuman(sx, sy, sz)
        rotation.RotateTowards(startRot)
    end
end

function MineBranchSegment(Orientation)
    log4cc.info("Mining New Branch Segment")
    rotation.RotateTowards(Orientation)
    local sx, sy, sz = movement.GetXYZ()

    log4cc.info("\t Digging Phase")
    for i = 1, 20 do
        movement.DigMove()
        movement.MineAdjacentOres()
    end

    log4cc.info("\t Returning")
    movement.MineToXYZHuman(sx, sy, sz)
    rotation.RotateTowards(Orientation)

    log4cc.info("Extending for new branch")
    rotation.TurnRight()
    for i = 1, 4 do
        movement.DigMove()
    end
    rotation.RotateTowards(Orientation)
    inventory.ManageInventory()
end

function MineBranches(endRatio)
    log4cc.info("Beginning to mine branches.")
    local StartOrientation = rotation.GetOrientation()
    while turtle.getFuelLevel() >= (turtle.getFuelLimit() * endRatio) do
        MineBranchSegment(StartOrientation)
        if inventory.IsFull() then
            return
        end
    end
    log4cc.info("Fuel low. Ending branch mining.")
end

-- Main execution
local args = {...}
local targetResource = args[1] or "diamond"
local explorationRange = tonumber(args[2]) or 10
local minFuelRatio = tonumber(args[3]) or 0.1

log4cc.info("Beginning Mining Operation for " .. targetResource)
FindNewPath(explorationRange, resources.GetAltitude(targetResource))
MineBranches(minFuelRatio)
movement.ReturnHome()
