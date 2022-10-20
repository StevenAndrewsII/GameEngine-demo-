local Class = require("Core/LIB/Class")
local Inventory_manager = Class:derive("Inventory_manager") -- create the class 



function Inventory_manager:new(Hatch_,obj_)
	self.Hatch_ 		= Hatch_ 					--// Hatch_ 		/ref 
	self.obj_ 			= obj_[1]					--// objects data that inventory script is bound to		/ ref
	self.obj_name 		= obj_[2]					--// objects name 	/ ref
end --//EOF- Lib creation 




--// add an object or item inti the inventory system 
function Inventory_manager:add_inventory()
end 

--// destory an item 
function Inventory_manager:destroy_inventory()
end 

--// drop an item ( onto the ground )
function Inventory_manager:drop_inventory()
end 






--// tracks munitions systems 
function Inventory_manager:update()
end 



return Inventory_manager  