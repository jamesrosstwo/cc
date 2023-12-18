local log4cc = require("log4cc")
local inventory = require("inventory")
local movement = {}

function movement.MineToX(TargetX)
    local x, y, z = GetPos()
    log4cc.info("Currently at x=" .. x)
    log4cc.info("Going to target x=" .. TargetX)

    if x == TargetX then
        log4cc.info("Arrived at x=" .. TargetX)
        return
    end

    local desiredOrientation = sign(TargetX - x) + 2
    if desiredOrientation == 2 then
        log4cc.info("Arrived at x=" .. TargetX)
        return -- we are already at the correct X
    end
    RotateTowards(desiredOrientation)

    while sign(TargetX - x) ~= 0 do
        DigMove()
        x, y, z = GetPos()
    end

    log4cc.info("Arrived at x=" .. TargetX)
end

function movement.MineToZ(TargetZ)
    local x, y, z = GetPos()
    log4cc.info("Currently at z=" .. z)
    log4cc.info("Going to target z=" .. TargetZ)

    if z == TargetZ then
        log4cc.info("Arrived at z=" .. TargetZ)
        return
    end

    local desiredOrientation = sign(TargetZ - z) + 3
    RotateTowards(desiredOrientation)

    while sign(TargetZ - z) ~= 0 do
        DigMove()
        x, y, z = GetPos()
    end
    log4cc.info("Arrived at z=" .. TargetZ)
end

function movement.MineToY(TargetY)
    local x, y, z = GetPos()
    log4cc.info("Currently at y=" .. y)
    log4cc.info("Going to target y=" .. TargetY)

    if y == TargetY then
        log4cc.info("Arrived at y=" .. TargetY)
        return
    end

    while sign(y - TargetY) ~= 0 do
        local MineFn = y > TargetY and turtle.digDown or turtle.digUp
        local DetectFn = y > TargetY and turtle.detectDown or turtle.detectUp
        local MoveFn = y > TargetY and turtle.down or turtle.up

        Refuel()
        if DetectFn() then
            MineFn()
        end
        MoveFn()
        x, y, z = GetPos()
    end
    log4cc.info("Arrived at y=" .. TargetY)
end

function movement.MineToPosition(TargetX, TargetY, TargetZ)
    log4cc.info("Mining to position " .. CoordString(TargetX, TargetY, TargetZ))
    MineToY(TargetY)
    MineToX(TargetX)
    MineToZ(TargetZ)
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
    Refuel()
    if turtle.detect() then
        turtle.dig()
    end

    turtle.forward()

    if turtle.detectUp() then
        turtle.digUp()
    end
    
    inventory.placeDown()

end

return movement