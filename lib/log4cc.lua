-- Log4cc - A log system for programs of CC: Tweaked
-- v0.0.1-alpha Released on 2022/2/7
-- Licensed under MIT https://gitlab.com/MineCommander/log4cc
local log4cc = {}

--- Main module body ---

log4cc.logLevel = {
    debug = 0,
    info = 1,
    warn = 2,
    error = 3
}

log4cc.config = { -- Default config - editable by user
    console = {
        enabled = true,
        format = "[{time}][{level}] {content}{newline}",
        level = log4cc.logLevel.info
    },
    file = {
        enabled = false,
        format = "[{time}][{level}] {content}{newline}",
        level = log4cc.logLevel.info,
        fileName = nil
    },
    remote = {
        enabled = false,
        format = "[{time}][{level}] {source}: {content}{newline}",
        level = log4cc.logLevel.info,
        targetID = {},
        encryption = nil -- not implemented
    }
}

local deviceInfo = string.format("#%d %s", os.getComputerID(), os.getComputerLabel())

local function formatMsg(format, content, level)
    format = string.gsub(format, "{time}", os.date("%T"))
    format = string.gsub(format, "{content}", content)
    format = string.gsub(format, "{source}", deviceInfo)
    format = string.gsub(format, "{newline}", "\n")
    local levelString = nil
    if level == log4cc.logLevel.debug then
        levelString = "Debug"
    elseif level == log4cc.logLevel.info then
        levelString = "Info"
    elseif level == log4cc.logLevel.warn then
        levelString = "Warn"
    elseif level == log4cc.logLevel.error then
        levelString = "Error"
    end
    format = string.gsub(format, "{level}", levelString)
    return format
end

local function log(msg, level)
    for sink, c in pairs(log4cc.config) do -- enumerates all methods of logging
        -- 'sink' is the name of method, 'c' is the config table
        if c.enabled and level >= c.level then -- whether this method is available
            if sink == "console" then
                write(formatMsg(c.format, msg, level))
            elseif sink == "file" then
                local fileHandle = fs.open(log4cc.config.file.fileName, "a")
                fileHandle.write(formatMsg(c.format, msg, level))
                fileHandle.close()
            elseif sink == "remote" then
                for i, target in ipairs(c.targetID) do
                    rednet.send(target, formatMsg(c.format, msg, level))
                end
            end
        end
    end
end

log4cc.debug = function(msg)
    log(msg, log4cc.logLevel.debug)
end

log4cc.info = function(msg)
    log(msg, log4cc.logLevel.info)
end

log4cc.warn = function(msg)
    log(msg, log4cc.logLevel.warn)
end

log4cc.error = function(msg)
    log(msg, log4cc.logLevel.error)
end

--- Module body end ---

return log4cc
