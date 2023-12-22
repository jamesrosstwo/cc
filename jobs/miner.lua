local script_dir = debug.getinfo(1).source:match("@(.*/)")
package.path = package.path .. ";" .. script_dir .. "lib/?.lua"

local log4cc = require("lib.log4cc")
local movement = require("lib.movement")
local rotation = require("lib.rotation")
local utils = require("lib.utils")
local resources = require("lib.resources")
local locations = require("lib.locations")
local inventory = require("lib.inventory")

function FindNewPath(StartRange, DesiredAlt)
    local px = math.random(-StartRange, StartRange)
    local pz = math.random(-StartRange, StartRange)
    log4cc.info("Finding new path start: \n\t" .. utils.CoordString(px, pz, DesiredAlt))
    x, y, z = movement.GetPos()
    movement.MineToXYZ(x + px, DesiredAlt, z + pz)
end

function MineBranchSegment(Orientation)
    log4cc.info("Mining New Branch Segment")
    rotation.RotateTowards(Orientation)
    local sx, sy, sz = movement.GetPos()

    log4cc.info("\t Digging Phase")
    for i = 1, 20 do
        movement.DigMove()
        local success, data = turtle.inspectUp()
        local sx, sy, sz = movement.GetPos()
        while success and resources.OreIDs[data.name] do
            turtle.digUp()
            turtle.up()
            success, data = turtle.inspectUp()
        end
        movement.MineToPosition(sx, sy, sz)

        success, data = turtle.inspectDown()
        while success and resources.OreIDs[data.name] do
            turtle.digDown()
            turtle.down()
            success, data = turtle.inspectDown()
        end
        movement.MineToPosition(sx, sy, sz)
    end

    log4cc.info("\t Returning")
    movement.MineToXYZ(sx, sy, sz)
    rotation.RotateTowards(Orientation)

    log4cc.info("Extending for new branch")
    rotation.TurnRight()
    for i = 1, 4 do
        movement.DigMove()
    end
    rotation.RotateTowards(Orientation)
    inventory.ManageInventory()
end

function MineBranches()
    log4cc.info("Beginning to mine branches.")
    local StartOrientation = rotation.GetOrientation()
    while turtle.getFuelLevel() >= (turtle.getFuelLimit() / 10) do
        MineBranchSegment(StartOrientation)
        if inventory.IsFull() then
            return
        end
    end
    log4cc.info("Fuel low. Ending branch mining.")
end

function Dump()
    log4cc.info("Dumping items")
    movement.MineToPosition(locations.dumpChest + vector.new(0, 1, 0))
    inventory.EmptyInventory(turtle.dropDown)
end


-- Main execution
local args = {...}
local targetResource = args[1] or "diamond"

local inHome = true
if args[2] ~= nil then
    inHome = args[2] == "true"
end

local explorationRange = tonumber(args[3]) or 10


log4cc.info("Beginning Mining Operation for " .. targetResource)
if inHome then
    movement.LeaveHome()
end
FindNewPath(explorationRange, resources.GetAltitude(targetResource))
MineBranches()
Dump()
movement.ReturnHome()
