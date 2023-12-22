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

resources.altitudes = {
    diamond = -59,
    iron = 16,
    coal = 40
}

function resources.GetAvailableResources()
    local names = {}
    for name in pairs(resources.altitudes) do
        table.insert(names, name)
    end
    return table.concat(names, ", ")
end

function resources.GetAltitude(targetResource)
    -- Validate input
    if not resources.altitudes[targetResource] then
        log4cc.info("Invalid resource name. Please enter one of the following: " .. resources.GetAvailableResources())
        return
    end

    return resources.altitudes[targetResource]
end

return resources
