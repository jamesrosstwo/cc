local script_dir = debug.getinfo(1).source:match("@(.*/)")
package.path = package.path .. ";" .. script_dir .. "lib/?.lua"

local log4cc = require("lib.log4cc")
local movement = require("lib.movement")
local locations = require("lib.locations")
local inventory = require("lib.inventory")

log4cc.config.file.enabled = true
log4cc.config.file.fileName = "log.txt"
log4cc.config.remote.enabled = true

log4cc.info("Organizing chests")
movement.ReturnHome()
local chestOffset = vector.new(0, 1, 0)
local startLoc = locations.chestsStart + chestOffset

function DumpItems()
    inventory.Refuel()
    for slot = 1, 16 do
        local itemDetails = turtle.getItemDetail(slot)
        
        -- Check if there is an item in the slot
        if itemDetails then
            local itemName = itemDetails.name

            -- Check if the item is not a fuel slot (modify this as needed)
            if not isFuelSlot(itemName) then
                -- Calculate the index of the chest based on the first three letters of the item name
                local firstLetters = itemName:sub(1, 3) 
                local chestIndex = (firstLetters:byte() % numChests) + 1 

                movement.MineToPosition(locations.chests[chestIndex])
                turtle.select(slot)
                turtle.dropDown()
            end
        end
    end
end


movement.MineToPosition(startLoc)
while true do
    movement.MineToPosition(locations.dumpChest + vector.new(-1, 1, 0))
    inventory.SuckAll(turtle.suckDown)
    inventory.ManageInventory()
    DumpItems()
end



