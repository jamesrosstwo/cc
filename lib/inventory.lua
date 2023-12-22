local log4cc = require("lib.log4cc")
local resources = require("lib.resources")
local inventory = {}

inventory.valuableSlot = "valuable"
inventory.anySlot = "any"

inventory.slotMap = {
    [1] = "minecraft:coal",
    [2] = "minecraft:cobbled_deepslate",
    [3] = "minecraft:cobblestone",
    [4] = inventory.valuableSlot,
    [5] = inventory.valuableSlot,
    [6] = inventory.valuableSlot,
    [7] = inventory.valuableSlot,
    [8] = inventory.valuableSlot,
    [9] = inventory.valuableSlot,
    [10] = inventory.valuableSlot,
    [11] = inventory.valuableSlot,
    [12] = inventory.valuableSlot,
    [13] = inventory.anySlot,
    [14] = inventory.anySlot,
    [15] = inventory.anySlot,
    [16] = inventory.anySlot
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
        turtle.select(slot)
        local currentSlotType = inventory.slotMap[slot]
        if turtle.getItemCount(slot) > 0 then
            local data = turtle.getItemDetail(slot)
            local foundSlot = false

            local itemType = data.name

            if resources.ValuableMaterials[itemType] then
                log4cc.info("Item type " .. itemType .. " is valuable")
                itemType = "valuable"
            end

            if itemType == currentSlotType then
                foundSlot = true
            end


            if not foundSlot then
                for targetSlot, targetSlotType in pairs(inventory.slotMap) do
                    log4cc.info("checking slot " .. slot .. ", " .. targetSlot .. ": " .. targetSlotType .. ", item " .. itemType)
                    if slot ~= targetSlot and (targetSlotType == inventory.anySlot or itemType == targetSlotType) then
                        if turtle.transferTo(targetSlot) then
                            foundSlot = true
                            break
                        end
                    end
                end
            end

            -- Drop items if they don't fit in their designated slots
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
