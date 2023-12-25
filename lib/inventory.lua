local log4cc = require("lib.log4cc")
local resources = require("lib.resources")
local inventory = {}

inventory.valuableSlot = "valuable"
inventory.anySlot = "any"

inventory.coalSlot = 1
inventory.swapSlot = 16

function inventory.GetItemValue(itemName)
    return resources.ItemValues[itemName] or 0
end

function inventory.SwapSlots(slotA, slotB, swapSlot)
    if swapSlot == nil then
        swapSlot = inventory.swapSlot
    end

    turtle.select(inventory.swapSlot)
    if turtle.getItemCount() > 0 then
        turtle.drop()
    end

    turtle.select(slotA)
    turtle.transferTo(inventory.swapSlot)
    turtle.select(slotB)
    turtle.transferTo(slotA)
    turtle.select(inventory.swapSlot)
    turtle.transferTo(slotB)
end

function inventory.ManageInventory()
    -- Reserve slot 1 for coal, and slot 16 for swapping
    for slot = 2, 15 do
        turtle.select(slot)
        if turtle.getItemCount(slot) > 0 then
            local data = turtle.getItemDetail(slot)
            local highestValueSlot = slot
            local highestValue = resources.GetItemValue(data.name)

            for targetSlot = 2, 15 do
                if targetSlot ~= slot then
                    local targetData = turtle.getItemDetail(targetSlot)
                    local targetValue = targetData and resources.GetItemValue(targetData.name) or 0

                    if targetValue > highestValue then
                        highestValue = targetValue
                        highestValueSlot = targetSlot
                    end
                end
            end

            if highestValueSlot ~= slot then
                inventory.SwapSlots(slot, highestValueSlot)
            end
        end
    end

    for slot = 13, 16 do
        turtle.select(slot)
        local data = turtle.getItemDetail(slot)
        if resources.GetItemValue(data.name) == 0 then
            turtle.drop()
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
