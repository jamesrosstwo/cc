local log4cc = require "lib.log4cc"

log4cc.config.file.enabled = true
log4cc.config.file.fileName = "log.txt" -- save log into log.txt
log4cc.config.remote.enabled = true

function FindNewPath(StartRange, DesiredAlt)
    local px = math.random(-StartRange, StartRange)
    local pz = math.random(-StartRange, StartRange)
    log4cc.info("Finding new path start: \n\t" .. CoordString(px, pz, DesiredAlt))
    x, y, z = GetPos()
    MineToPosition(x + px, DesiredAlt, z + pz)
end

function ReturnHome()
    log4cc.info("Returning Home")
    MineToPosition(ChuteTopLocation.x, ChuteTopLocation.y, ChuteTopLocation.z)
    RotateTowards(3) -- +x
    while not turtle.detectDown() do
        turtle.down()
    end
end

function LeaveHome()
    log4cc.info("Leaving Home")
    MineToPosition(ChuteTopLocation.x, ChuteTopLocation.y, ChuteTopLocation.z)
end

function MineBranchSegment(Orientation)
    log4cc.info("Mining New Branch Segment")
    RotateTowards(Orientation)
    local sx, sy, sz = GetPos()

    log4cc.info("\t Digging Phase")
    for i = 1, 20 do
        DigMove()
    end

    log4cc.info("\t Returning")
    MineToPosition(sx, sy, sz)
    RotateTowards(Orientation)

    log4cc.info("Extending for new branch")
    turnRight()
    for i = 1, 4 do
        DigMove()
    end
    RotateTowards(Orientation)
end

function MineBranches()
    log4cc.info("Beginning to mine branches.")
    local StartOrientation = getOrientation()
    while turtle.getFuelLevel() >= (turtle.getFuelLimit() / 10) do
        MineBranchSegment(StartOrientation)
    end
    log4cc.info("Fuel low. Ending branch mining.")
end


-- Main execution
local args = {...}
local targetResource = args[1]
local explorationRange = tonumber(args[2]) or 10

-- Validate input
if not resourceAlts[targetResource] then
    log4cc.info("Invalid resource name. Please enter one of the following: " .. getAvailableResources())
    return
end


log4cc.info("Beginning Mining Operation for " .. targetResource)
LeaveHome()
FindNewPath(explorationRange, resourceAlts[targetResource])
MineBranches()
ReturnHome()
