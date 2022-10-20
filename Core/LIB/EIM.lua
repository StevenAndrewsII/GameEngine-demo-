local Class = require("Core/LIB/Class")    -- get class system
local EIM = Class:derive("EIM")  -- create class - Equipment and inventory manager 




function EIM:new(hatch_)

-- // consumables and weapons + attachments 
self.inventory = {


}

--// equipment ( weapons )
self.Equipment = {


}

--// currently selected item to be in the hand 
self.selected_eqipment


-- module binding 
self.hatch_ = hatch_
end 



function EIM:add_inventory(item_id)
end --// EOF (add_inventory)
function EIM:remove_inventory(item_id)
end --// EOF (remove_inventory)

--// equip items data 
function EIM:equip(item_id)
end --// EOF (equip)
function EIM:unequip(item_id)
end --// EOF (unequip)


--// select and use 
function EIM:select_equipment(item_id)
end --// EOF (select_equipment)

function EIM:use_item(item_id)
end --// EOF (use_item)



--// 60 fps 
function EIM:update()
end --// EOF (update)




--// EOF
return EIM











