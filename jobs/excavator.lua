local movement = require("lib.movement")
local utils = require("lib.utils")
local inventory = require("lib.inventory")

local args = { ... }

local xRange = tonumber(args[1]) or 10
local yRange = tonumber(args[2]) or 2
local zRange = tonumber(args[1]) or 10

for i = 1, yRange do
    local planePos = movement.GetPos()
    for j = 1, math.ceil(zRange / 2) do
        local zPos = movement.GetPos()
        movement.MineToPosition(zPos + vector.new(xRange, 0, 0))
        movement.MineToPosition(zPos + vector.new(xRange, 0, utils.Sign(zRange)))
        movement.MineToPosition(zPos + vector.new(0, 0, utils.Sign(zRange) * 2))
        inventory.ManageInventory()
    end
    movement.MineToPosition(planePos + vector.new(0, -1, 0))
end
