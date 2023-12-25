local log4cc = require("lib.log4cc")
local inventory = require("lib.inventory")


while true do
    inventory.Refuel()
    turtle.select(9)
    turtle.digDown()
    turtle.drop()
    os.sleep(2)
end



