local movement = require("lib.movement")
local utils = require("lib.utils")

local args = { ... }

local xRange = tonumber(args[1]) or 10
local yRange = tonumber(args[2]) or 2
local zRange = tonumber(args[1]) or 10

for i = 1, yRange do
    local planePos = movement.GetPos()
    for j = 1, math.ceil(zRange / 2) do
        local zPos = movement.GetPos()
        movement.MineToPositionHuman(zPos + vector.new(xRange, 0, 0))
        movement.MineToPositionHuman(zPos + vector.new(xRange, 0, utils.Sign(zRange)))
        movement.MineToPositionHuman(zPos + vector.new(0, 0, utils.Sign(zRange) * 2))
    end
    movement.MineToPositionHuman(planePos + vector.new(0, -1, 0))
end
