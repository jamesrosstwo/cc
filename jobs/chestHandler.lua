local log4cc = require("lib.log4cc")
local movement = require("lib.movement")
local rotation = require("lib.rotation")
local utils = require("lib.utils")
local resources = require("resources")
local locations = require("locations")

log4cc.config.file.enabled = true
log4cc.config.file.fileName = "log.txt"
log4cc.config.remote.enabled = true

log4cc.info("Organizing chests")
movement.ReturnHome()
