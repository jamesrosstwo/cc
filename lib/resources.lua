local log4cc = require("lib.log4cc")
local resources = {}

resources.altitudes = {
    diamond = -59,
    iron = 16,
    coal = 60
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
