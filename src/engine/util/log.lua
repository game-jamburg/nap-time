Logger = class("Logger")

function Logger:initialize()
    self.messages = {}
    self.onMessage = nil
    self.levels = {"VERBOSE", "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"}
    self.printLevel = self:getLevelNumber("INFO")
    self.prefix = nil
    -- self.fileLevel = self:getLevelNumber("INFO")
end

function Logger:write(level, ...)
    local time = string.format("%.03f", Time.Global)
    table.insert(self.messages, {time, level, stringify(...)})

    if self.printLevel <= self:getLevelNumber(level) then
        if self.prefix then
            print(time, self.prefix .. level, ...)
        else
            print(time, level, ...)
        end
    end
end

function Logger:getLevelNumber(level)
    return table.indexOf(self.levels, level)
end

function Logger:verbose(...)
    self:write("VERBOSE", ...)
end

function Logger:debug(...)
    self:write("DEBUG", ...)
end

function Logger:info(...)
    self:write("INFO", ...)
end

function Logger:warning(...)
    self:write("WARNING", ...)
end

function Logger:error(...)
    self:write("ERROR", ...)
end

Log = Logger:new()
