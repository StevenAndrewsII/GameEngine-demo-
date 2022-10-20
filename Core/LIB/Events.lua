
local Class = require("Core/LIB/Class")
local Events = Class:derive("Events") -- create the class events
--[[
Version 1.5(2018 build repo)
-- Steven Andrews II

-- Is in working order, may need added functions... 
]]




---indexed location of the callback in the table stack 
local function index_of(evt_tbl, callback)
    if(evt_tbl == nil or callback == nil) then return -1 end
    for i = 1, #evt_tbl do
        if evt_tbl[i] == callback then return i end
    end
    return -1
end




 -- creates an instance with new events in it 
function Events:new(event_must_exist)  --(if false you can skip the add function)
    self.handlers = {}
    self.event_must_exist = (event_must_exist == nil) or event_must_exist
end--EOF


-- add an event 
function Events:add(evt_name)
    assert(self.handlers[evt_name] == nil, "Event " .. evt_name .. " already exists!")
    self.handlers[evt_name] = {}
end--EOF


--Remove an event type from our table
function Events:remove(evt_name)
	assert(self.handlers[evt_name] ~= nil, "Event " .. evt_name .. " does not exists!")
    self.handlers[evt_name] = nil
end--EOF

-- hook functions to an event to be triggered 
function Events:hook(evt_name, callback)
    assert(type(callback) == "function", "callback parameter must be a function!")

    if self.event_must_exist then
        assert(self.handlers[evt_name] ~= nil, "Event of type " .. evt_name .. " does not exist!")
    elseif(self.handlers[evt_name] == nil) then
        self:add(evt_name)
    end

    
    assert(index_of(self.handlers[evt_name], callback) == -1, "callback has already been registered!") -- re registration check

    local tbl = self.handlers[evt_name]
    tbl[#tbl + 1] = callback
end--EOF


function Events:unhook(evt_name, callback)
    assert(type(callback) == "function", "callback parameter must be a function!")
    if self.handlers[evt_name] == nil then return end
    local index = index_of(self.handlers[evt_name], callback)
    if index > -1 then
        table.remove(self.handlers[evt_name], index)
    end
end

-- clears a specified event from its attached functions (does not delete event,just removes attached functions)
function Events:clear(evt_name)
    if evt_name == nil then
        for k,v in pairs(self.handlers) do
            self.handlers[k] = {}
        end
        elseif self.handlers[evt_name] ~= nil then
            self.handlers[evt_name] = {}
    end
end--EOF


-- trigger an event and its attached functions. invokes all attached functions. gets run times of functions 
function Events:invoke(evt_name, ...)

   -- print("evt_name"..evt_name)
    
    if self.handlers[evt_name] == nil then return end
	    local tbl = self.handlers[evt_name]
	    local out_ = {}
	    local S = love.timer.getTime()
	    

	    for k,v in pairs (tbl) do  -- iterate over all functions 
	    	local s_ = love.timer.getTime()
	    	local tmp_ = v(...)   -- call the function and pass the unsigned data to the function. V = value which is the function location. (returns data from function)
	    	local e_ = love.timer.getTime()
	    	out_[#out_+1] = {k,(e_ - s_),tmp_}
	    	
   		end

    local E = love.timer.getTime()
    return out_,(E-S),S,E     --- returns the data from a function triggered by invoke and returns the time it took to run/complete, and the start time. 
end--EOF








------------------------------------
--[[ experimental:

events are function(s) tied to event table. invoke calls the tied functions and gives run time data as secondary output

* a listener is placed into a function and gives run time data back, ( can also tie events and functions )

]]
------------------------------------
-- returns the function information when triggered... 
function Events:listener_add(listener_name)

end

function Events:listener_remove(listener_name)

end

function Events:listener_hook(listener_name)

end

function Events:listener_unhook(listener_name)

end

function Events:listener_clear(listener_name)

end

-- 60 fps controller link 
function Events:listener_update()

end



return Events