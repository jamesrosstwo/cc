local log4cc = require("log4cc")  -- Assuming log4cc is in the same folder

local inventory = {}

inventory.slotMap = {
    [1] = "minecraft:coal",
    [2] = "minecraft:coal",
    [3] = "minecraft:cobbled_deepslate",
    [4] = "minecraft:cobblestone"
}

function inventory.manageInventory()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            local data = turtle.getItemDetail(slot)
            local foundSlot = false

            for targetSlot, itemType in pairs(inventory.slotMap) do
                if data.name == itemType then
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


function inventory.refuel()
    for slot, itemType in pairs(inventory.slotMap) do
        if itemType == "minecraft:coal" then
            turtle.select(slot)
            while turtle.getItemCount(slot) > 0 and turtle.getFuelLevel() < (turtle.getFuelLimit() / 5) do
                if not turtle.refuel(1) then
                    log4cc.warn("Refueling slot " .. slot .. " filled with incorret item")
                    break
                end
            end
        end
    end
end


function inventory.placeDown()
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


return inventory
