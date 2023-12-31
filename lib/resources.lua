local log4cc = require("lib.log4cc")
local resources = {}

resources.coal = "minecraft:coal"

resources.OreIDs = {
    ["minecraft:gold_ore"] = true,
    ["minecraft:iron_ore"] = true,
    ["minecraft:coal_ore"] = true,
    ["minecraft:lapis_ore"] = true,
    ["minecraft:diamond_ore"] = true,
    ["minecraft:redstone_ore"] = true,
    ["minecraft:emerald_ore"] = true,
    ["minecraft:nether_gold_ore"] = true,
    ["minecraft:ancient_debris"] = true,
    ["minecraft:copper_ore"] = true,
    ["minecraft:deepslate_coal_ore"] = true,
    ["minecraft:deepslate_copper_ore"] = true,
    ["minecraft:deepslate_diamond_ore"] = true,
    ["minecraft:deepslate_emerald_ore"] = true,
    ["minecraft:deepslate_gold_ore"] = true,
    ["minecraft:deepslate_iron_ore"] = true,
    ["minecraft:deepslate_lapis_ore"] = true,
    ["minecraft:deepslate_redstone_ore"] = true,
    ["thermalfoundation:ore"] = true,
    ["ic2:resource"] = true,
    ["appliedenergistics2:material"] = true,
    ["mysticalagriculture:crafting"] = true,
}

resources.ItemValues = {
    ["minecraft:coal"] = 3,
    ["minecraft:iron_ore"] = 3,
    ["minecraft:redstone"] = 4,
    ["minecraft:quartz"] = 4,
    ["minecraft:lapis_lazuli"] = 5,
    ["thermalfoundation:ore"] = 5,
    ["minecraft:gold_ore"] = 6,
    ["ic2:resource"] = 6,
    ["appliedenergistics2:material"] = 6,
    ["mysticalagriculture:crafting"] = 6,
    ["minecraft:emerald"] = 9,
    ["minecraft:diamond"] = 10,
    ["minecraft:ancient_debris"] = 12
}


function resources.GetItemValue(itemName)
    return resources.ItemValues[itemName] or 0
end


resources.Altitudes = {
    diamond = 11,
    iron = 45,
    coal = 25
}

function resources.GetAvailableResources()
    local names = {}
    for name in pairs(resources.Altitudes) do
        table.insert(names, name)
    end
    return table.concat(names, ", ")
end

function resources.GetAltitude(targetResource)
    -- Validate input
    if not resources.Altitudes[targetResource] then
        log4cc.info("Invalid resource name. Please enter one of the following: " .. resources.GetAvailableResources())
        return
    end

    return resources.Altitudes[targetResource]
end

return resources
