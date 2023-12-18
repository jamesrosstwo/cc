local script_dir = debug.getinfo(1).source:match("@(.*/)")
package.path = package.path .. ";" .. script_dir .. "lib/?.lua"


local log4cc = require("lib.log4cc")
local movement = require("lib.movement")
local rotation = require("lib.rotation")
local utils = require("lib.utils")
local resources = require("lib.resources")
local locations = require("lib.locations")
local inventory = require("lib.inventory")

log4cc.config.file.enabled = true
log4cc.config.file.fileName = "log.txt"
log4cc.config.remote.enabled = true

function FindNewPath(StartRange, DesiredAlt)
    local px = math.random(-StartRange, StartRange)
    local pz = math.random(-StartRange, StartRange)
    log4cc.info("Finding new path start: \n\t" .. utils.CoordString(px, pz, DesiredAlt))
    x, y, z = movement.GetPos()
    movement.MineToXYZ(x + px, DesiredAlt, z + pz)
end

function MineBranchSegment(Orientation)
    log4cc.info("Mining New Branch Segment")
    movement.RotateTowards(Orientation)
    local sx, sy, sz = movement.GetPos()

    log4cc.info("\t Digging Phase")
    for i = 1, 20 do
        movement.DigMove()
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
end

function MineBranches()
    log4cc.info("Beginning to mine branches.")
    local StartOrientation = rotation.GetOrientation()
    while turtle.getFuelLevel() >= (turtle.getFuelLimit() / 10) do
        MineBranchSegment(StartOrientation)
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
local targetResource = args[1]
local explorationRange = tonumber(args[2]) or 10

log4cc.info("Beginning Mining Operation for " .. targetResource)
movement.LeaveHome()
FindNewPath(explorationRange, resources.GetAltitude(targetResource))
MineBranches()
Dump()
movement.ReturnHome()
