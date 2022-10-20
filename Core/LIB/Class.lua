
-- old class system

local Class = {}
Class.__index = Class
Class.attached = {} -- new 

--default implementation
function Class:new() end

--create a new Class type from our base class
function Class:derive(class_type)
    assert(class_type ~= nil, "parameter class_type must not be nil!")
    assert(type(class_type) == "string", "parameter class_type class must be string!")
    local cls = {}
    cls["__call"] = Class.__call 
    cls.type = class_type
    cls.__index = cls
    cls.super = self
    cls.attached = {}               -- new
    setmetatable(cls, self)

   local mt =  getmetatable(self) -- new (tree tracing when created, gets its above container)
   if mt then 
   table.insert( mt.attached, cls )
   end 
  
    return cls
end

--Check if the instance is a sub-class of the given type
function Class:is(class)
    assert(class ~= nil, "parameter class must not be nil!")
    assert(type(class) == "table", "parameter class must be of Type Class!")
    local mt = getmetatable(self)
    while mt do
        if mt == class then return true end
        mt = getmetatable(mt)
    end
    return false
end


function Class:tree_up(get_class_type)													--single trace option since: ver_ 1.3 (gets the parents of a object)
print ("start tree ")
	local get_ct = get_class_type or nil

	local function gen_(o) 																-- initial iterator set up (get self meta table)
		print("run")
        local __origen =   self   														-- the reference of self
		local __origen_index = getmetatable(  __origen  ) 								-- the reference above reference self
		local _ = o or { {  __origen.type  ,  __origen  ,  __origen_index  } }          -- accounts for first run /formatting ( type.self(index),parent(index) )
		 local org = _[#_][3].__index 													-- get the next index in line... fixed(ver_ .5)
		 local org_index = getmetatable( org ) 						                    -- get meta table data for org...					
		 local tbl_ = {org.type,org,org_index}                                          -- insert data into format
		table.insert(_,tbl_)
		if tbl_[3].type ~= nil then 													-- cycle function fixed (updated on ver_1.3) -- found end of the trace 
			if type(get_ct ) == "string" and get_ct == tbl_[1] then
			 	print("found object: "..tbl_[1])											-- debug
			 	return tbl_[2]															-- single trace out (added on ver_ 1.3)
			 else
				return gen_(_) 															-- recursion (send table back up until search is found)
			end
		else 
			return _ 																	-- finished/ return the out table (full trace out )
		end
	end -- EOF:gen_

local a = gen_()																		-- start iteration
	return a 																			-- out content 
end -- EOF:tree_up





function Class:is_type(class_type)
    assert(class_type ~= nil, "parameter class_type must not be nil!")
    assert(type(class_type) == "string", "parameter class_type class must be string!")
    local base = self
    while base do 									-- iterator 
        if base.type == class_type then
         return true                                -- true return means class match to type input. 
        end
        base = base.super							-- if the above if is not true then base gets updated with super... 
    end
    return false									-- false return means the class does not match the type
end

function Class:__call(...) -- returns an instance of a class... 
    local inst = setmetatable({}, self)
    inst:new(...)
    return inst
end

function Class:get_type() -- get the type of a class 
    return self.type
end

return Class