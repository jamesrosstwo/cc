local log4cc = require("lib.log4cc")
local resources = require("lib.resources")
local inventory = {}

inventory.valuableSlot = "valuable"
inventory.anySlot = "any"

inventory.coalSlot = 1
inventory.cobbleSlot = 15
inventory.swapSlot = 16

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
    for slot = 2, 14 do
        if turtle.getItemCount(slot) > 0 then
            local data = turtle.getItemDetail(slot)
            local highestValueSlot = slot
            local highestValue = resources.GetItemValue(data.name)

            if data.name == "minecraft:cobblestone" then
                turtle.select(slot)
                if not turtle.transferTo(cobbleSlot) then
                    turtle.drop()
                end
            end

            for targetSlot = 2, 14 do
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
    for slot = 1, 16 do
        turtle.select(slot)
        while turtle.getFuelLevel() < (turtle.getFuelLimit() / 5) do
            if turtle.refuel() then
                inventory.ManageInventory()
            else
                break
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

function inventory.EmptyInventory(dropFn, threshold)
    if threshold == nil then
        threshold = 0
    end
    for slot = 1, 16 do
        local itemDetails = turtle.getItemDetail(slot)
        local val = resources.GetItemValue(itemDetails.name)
        if val <= threshold then
            turtle.select(slot)
            dropFn()
        end
    end
end

function inventory.SuckAll(suckFn)
    for slot = 1, 16 do
        if not slot == inventory.coalSlot or slot == inventory.swapSlot then
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
