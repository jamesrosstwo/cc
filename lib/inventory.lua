local log4cc = require("lib.log4cc")
local resources = require("lib.resources")
local inventory = {}

inventory.slotMap = {
    [1] = "minecraft:coal",
    [2] = "minecraft:cobbled_deepslate",
    [3] = "minecraft:cobblestone",
    [4] = "valuable",
    [5] = "valuable",
    [6] = "valuable",
    [7] = "valuable",
    [8] = "valuable",
    [9] = "valuable",
    [10] = "valuable",
    [11] = "valuable"
}

function inventory.IsFuelSlot(itemName)
    local fuelItems = {
        "minecraft:coal",
    }
    
    for _, fuelItem in pairs(fuelItems) do
        if itemName == fuelItem then
            return true
        end
    end
    
    return false
end

function inventory.ManageInventory()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            local data = turtle.getItemDetail(slot)
            local foundSlot = false

            for targetSlot, itemType in pairs(inventory.slotMap) do

                if itemType == "valuable" and resources.ValuableMaterials[data.name] then
                    if turtle.getItemSpace(targetSlot) > 0 or slot == targetSlot then
                        turtle.select(slot)
                        turtle.transferTo(targetSlot)
                        foundSlot = true
                        break
                    end
                elseif data.name == itemType then
                    if turtle.getItemSpace(targetSlot) > 0 or slot == targetSlot then
                        turtle.select(slot)
                        turtle.transferTo(targetSlot)
                        foundSlot = true
                        break
                    end
                end
            end

            -- Drop items if they don't fit in their designated slot
            if not foundSlot then
                turtle.select(slot)
                turtle.drop()
            end
        end
    end
end


function inventory.Refuel()
    for slot, itemType in pairs(inventory.slotMap) do
        if itemType == "minecraft:coal" then
            turtle.select(slot)
            while turtle.getItemCount(slot) > 0 and turtle.getFuelLevel() < (turtle.getFuelLimit() / 5) do
                if not turtle.refuel(1) then
                    log4cc.warn("Refueling slot " .. slot .. " filled with incorret item")
                    inventory.ManageInventory()
                    break
                end
            end
        end
    end
end


function inventory.PlaceDown()
    if not turtle.detectDown() then
        local deepslateSlot = 3
        local cobblestoneSlot = 4

        local deepslateCount = turtle.getItemCount(deepslateSlot)
        local cobblestoneCount = turtle.getItemCount(cobblestoneSlot)

        if deepslateCount > 0 or cobblestoneCount > 0 then
            local slotToUse = (deepslateCount >= cobblestoneCount) and deepslateSlot or cobblestoneSlot
            turtle.select(slotToUse)
            return turtle.placeDown()
        end
    end

    return false
end

function inventory.EmptyInventory(dropFn)
    for slot = 1, 16 do
        local itemDetails = turtle.getItemDetail(slot)
        if itemDetails then
            local itemFound = false
            for targetSlot, itemType in pairs(inventory.slotMap) do
                if itemDetails.name == itemType then
                    itemFound = true
                    break
                end
            end
            if not itemFound then
                dropFn()
            end
        end
    end
end


function inventory.SuckAll(suckFn)
    for slot = 1, 16 do
        if not inventory.IsFuelSlot(inventory.slotMap[slot]) then
            suckFn()
        end
    end
end


function inventory.IsFull()
    for slot = 1, 16 do
        turtle.select(slot)
        if turtle.getItemCount() == 0 then
            return false
        end
    end
    return true
end


return inventory
