local script_dir = debug.getinfo(1).source:match("@(.*/)")
package.path = package.path .. ";" .. script_dir .. "lib/?.lua"

local log4cc = require("lib.log4cc")
local movement = require("lib.movement")
local locations = require("lib.locations")
local inventory = require("lib.inventory")

log4cc.config.file.enabled = true
log4cc.config.file.fileName = "log.txt"
log4cc.config.remote.enabled = true


while true do
    inventory.Refuel()
    turtle.select(9)
    turtle.digDown()
    turtle.drop()
    os.sleep(2)
end



