local locations = {}

locations.home = vector.new(-168, -23, 237)
locations.chuteTop = vector.new(-168, -16, 237)
locations.chestsStart = vector.new(-154, -23, 240)
locations.numChests = 14

function _generateChestPositions()
    local chestPositions = {}
    local x, y, z = locations.chestsStart.x, locations.chestsStart.y, locations.chestsStart.z
    
    for i = 1, locations.numChests do
        table.insert(chestPositions, vector.new(x, y, z))
        x = x - 2  -- Move two blocks in the -x direction
        if x < locations.chestsStart.x - 12 then
            x = locations.chestsStart.x  -- Wrap around to the first chest
            z = z - 2  -- Move two blocks in the -z direction
        end
    end
    
    return chestPositions
end

locations.chests = _generateChestPositions()


return locations