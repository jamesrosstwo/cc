local log4cc = require("lib.log4cc")
local resources = {}


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
}

resources.ValuableMaterials = {
    "minecraft:raw_iron",
    "minecraft:raw_copper",
    "minecraft:raw_gold",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:lapis_lazuli",
    "minecraft:redstone",
    "minecraft:coal",
    "minecraft:quartz",
    "minecraft:ancient_debris",
}

resources.Altitudes = {
    diamond = -59,
    iron = 16,
    coal = 40
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
