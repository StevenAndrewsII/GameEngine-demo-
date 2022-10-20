
model = {

-- object class type
type = "XR5_landing_gear",
-- model coordinates in free space... 
--(center of model and point of reference for bellow images)
world_cords = { -- // default everything 
X = 0,		
Y = 0,
Z = 0,
R = 0,
vis_ = true, -- // default 
},
















body_parts = {




{ 	--/ part 
	reference 	= "TIRE",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 630,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,




	animation_set = {
		selected_animation = "f1",

		f1 = {
			matrix = {


			{1,0,0}


			},
			speed =1,
			hooks = {} 		-- hooked events list
		},

	},

	images 		= {
		"Assets/models/XR-5/TIRE.png",
		}
 }, --// end of part 














{ 	
	reference 	= "body",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 222,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,




animation_set = {
		selected_animation = "f1",

		f1 = {
			matrix = {


			{1,0,0}


			},
			speed =1,
			hooks = {} 		-- hooked events list
		},

	},

	images 		= {
		"Assets/models/XR-5/LANDING_GEAR.png",

		}
 	},





--------------------------------------------------------------
} -- end of body parts group
--------------------------------------------------------------
} -- EOD(model)

return model