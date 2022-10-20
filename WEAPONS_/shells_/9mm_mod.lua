
local model = {
-- model file format example (emitter object).. 2020 tech demo 
-- Steven Andrews II
-- version 6.34
--[[
All features so far:
-- flexible file system and formatting (beta)
-- Animation support ( early alpha !)
-- Segmented body 
-- minimal part information needed, copy paste, edit and run !

Particle emitter example: most basic kind of object 
]]




-- object class type
type = "9mm",
-- model coordinates in free space... 
--(center of model and point of reference for bellow images)
world_cords = {
X = 0,
Y = 0,
Z = 0,
R = 0,
vis_ = false,
},

color_ = {	
ALPHA 	= 1,
RED_	= 1,
GREEN_	= 1,
BLUE_ 	= 1,
},

body_parts = {
-----------------------------------------------------------------------
 	{ 	
	reference 	= "body",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	images 		= {
		"Assets/models/WEAPONS_/shells_/9mm.png",
		}
 	},--//images
--------------------------------------------------------------
}
--------------------------------------------------------------
} -- EOD(model)

return model