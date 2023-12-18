local log4cc = require "lib.log4cc"
local movement = require("lib.movement")
local rotation = require("lib.rotation")
local utils = require("lib.utils")
local resources = require("resources")

log4cc.config.file.enabled = true
log4cc.config.file.fileName = "log.txt"
log4cc.config.remote.enabled = true

function FindNewPath(StartRange, DesiredAlt)
    local px = math.random(-StartRange, StartRange)
    local pz = math.random(-StartRange, StartRange)
    log4cc.info("Finding new path start: \n\t" .. utils.CoordString(px, pz, DesiredAlt))
    x, y, z = movement.GetPos()
    movement.MineToPosition(x + px, DesiredAlt, z + pz)
end

function ReturnHome()
    log4cc.info("Returning Home")
    movement.MineToPosition(ChuteTopLocation.x, ChuteTopLocation.y, ChuteTopLocation.z)
    rotation.RotateTowards(3) -- +x
    while not turtle.detectDown() do
        turtle.down()
    end
end

function LeaveHome()
    log4cc.info("Leaving Home")
    movement.MineToPosition(ChuteTopLocation.x, ChuteTopLocation.y, ChuteTopLocation.z)
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
    movement.MineToPosition(sx, sy, sz)
    rotation.RotateTowards(Orientation)

    log4cc.info("Extending for new branch")
    rotation.turnRight()
    for i = 1, 4 do
        movement.DigMove()
    end
    rotation.RotateTowards(Orientation)
end

function MineBranches()
    log4cc.info("Beginning to mine branches.")
    local StartOrientation = rotation.getOrientation()
    while turtle.getFuelLevel() >= (turtle.getFuelLimit() / 10) do
        MineBranchSegment(StartOrientation)
    end
    log4cc.info("Fuel low. Ending branch mining.")
end


-- Main execution
local args = {...}
local targetResource = args[1]
local explorationRange = tonumber(args[2]) or 10

log4cc.info("Beginning Mining Operation for " .. targetResource)
LeaveHome()
FindNewPath(explorationRange, resources.getAltitude(targetResource))
MineBranches()
ReturnHome()
