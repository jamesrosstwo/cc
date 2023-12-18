local resources = {}

resources.resourceAlts = {
    diamond = -59,
    iron = 16,
    coal = 60
}

function resources.getAvailableResources()
    local names = {}
    for name in pairs(resources.resourceAlts) do
        table.insert(names, name)
    end
    return table.concat(names, ", ")
end

return resources
