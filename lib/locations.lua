local locations = {}

locations.home = vector.new(-168, -23, 237)
locations.chuteTop = vector.new(-168, -16, 237)
locations.chestsStart = vector.new(-154, -23, 240)
locations.numChests = 14
locations.dumpChest = vector.new(-154, -23, 242)

-- 7xn grid on xz plane with gaps on the x axis
function _GenerateChestPositions()
    local chestPositions = {}
    local x, y, z = locations.chestsStart.x, locations.chestsStart.y, locations.chestsStart.z
    
    for i = 1, locations.numChests do
        table.insert(chestPositions, vector.new(x, y, z))
        x = x - 2
        if x < locations.chestsStart.x - 12 then
            x = locations.chestsStart.x
            z = z - 1
        end
    end
    
    return chestPositions
end

locations.chests = _GenerateChestPositions()


return locations