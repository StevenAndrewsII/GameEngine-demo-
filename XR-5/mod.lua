
local model = {
-- model file format example... 2020 tech demo 
-- Steven Andrews II
-- version 6.34
--[[
All features so far:
-- flexible file system and formatting (beta)
-- Animation support ( early alpha !)
-- Segmented body 
-- minimal part information needed, copy paste, edit and run !
]]






--------------------------------------------------------------------------
-- object class type
type = "XR-5",
-- model coordinates in free space... 
--(center of model and point of reference for bellow images)
world_cords = {
X = 0,
Y = 0,
Z = 0,
R = 0,
vis_ = true,
},


--------------------------------------------------------------------------
color_ = {
ALPHA 	= 1,
RED_	= 1,
GREEN_	= 1,
BLUE_ 	= 1,
},

--// update 8.0 
sound = { -- all sounds for this model (file,name id,type)
{"Assets/sound/guns/pistol/9mm.wav", "9mm", "static" }-- firing 
-- reload
-- draw
},


--------------------------------------------------------------------------

vertex_points  = {  



	
-----------------------------------------------------------------------------------
--// landing gear 
-----------------------------------------------------------------------------------


{ --// VT1		
	point_name = "LG_", 								-- name of the point 
	X 		= 0, 												-- engine oriented
	Y 		= 0, 												-- engine oriented 
	Z 		= 0,
	RAD 	= -500, 											-- distance from center
	ROT 	= 0,		
	attached_objects ={ {"LG_1","XR5_landing_gear",enabled = true,true,file = "Assets/models/XR-5/gear_mod.lua", stack_insert = "m308"}, },	
},

{
 --// VT1		
	point_name = "LG_2", 								-- name of the point 
	X 		= 0, 												-- engine oriented
	Y 		= 0, 												-- engine oriented 
	Z 		= 0,
	RAD 	=-500, 											-- distance from center
	ROT 	= 0,		
	attached_objects ={ {"LG_p2","XR5_landing_gear2",enabled = true,true,file = "Assets/models/XR-5/gear_mod2.lua", stack_insert = "flame"}, },	
},



	







	{ --// VT1		
	point_name = "shell_ejector", 								-- name of the point 
	X 		= 0, 												-- engine oriented
	Y 		= 0, 												-- engine oriented 
	Z 		= 0,
	RAD 	= 1500, 											-- distance from center
	ROT 	= 180,												-- object rotation 	

		emitter__ = { 	-- an attached emitter					-- emitter constructor 
			object 			= "dust",							-- emitter object name
			file_ 			= "Assets/effects/dust_tan/mod.lua",	
			angle 			= 0,								-- emission angle
			speed	 		= 70,								-- emission speed
			life	 		= 180,								-- life of the object
			fade 			= true,								-- fade out over life time
			range           = .3,								-- the range that objects will be spawned in 
			emition_number  = 1,								-- number of objects to emit per call
			rotation 		= 20,								-- the amount and speed/ 60 fps
			shrink = true,										-- grow the image 0 to 1 ( doesn't affect Z)
			rand_rot = true,
		}, 
	},--// VT1

{ --// VT1		
	point_name = "bullet", 				-- name of the point 
	X 		= 0, 										-- engine oriented
	Y 		= 0, 										-- engine oriented 
	Z 		= 0,
	RAD 	= 650, 									-- distance from center
	ROT 	= 40,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "9mm_projectile",							-- emitter object
		file_ 			= "Assets/effects/projectile/mod.lua",	
		speed	 		= 220,								-- emission speed
		speed_min	 	= 190,								-- random speed between min and speed // does not have to exist 
		life	 		= 100,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = .01,
		angle = -40,	--// offset angle/ ejection angle 
		life_rolloff = 2,						-- the range that objects will be spawned in 
		--state = false,							-- the state of the vertex
		emition_number  = 1,						-- number of objects to emit per call
		rotation 		= 0,					-- the amount and speed/ 60 fps
		rand_rot = false,

	}, 


	},--// VT1

	{ --// VT1		
	point_name = "bullet2", 				-- name of the point 
	X 		= 0, 										-- engine oriented
	Y 		= 0, 										-- engine oriented 
	Z 		= 0,
	RAD 	= 650, 									-- distance from center
	ROT 	= -40,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "9mm_projectile",							-- emitter object
		file_ 			= "Assets/effects/projectile/mod.lua",	
		speed	 		= 220,								-- emission speed
		speed_min	 	= 190,								-- random speed between min and speed // does not have to exist 
		life	 		= 100,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = .01,
		angle = 40,	--// offset angle/ ejection angle 
		life_rolloff = 2,						-- the range that objects will be spawned in 
		--state = false,							-- the state of the vertex
		emition_number  = 1,						-- number of objects to emit per call
		rotation 		= 0,					-- the amount and speed/ 60 fps
		rand_rot = false,

	}, 


	},--// VT1
},





--------------------------------------------------------------------------
body_parts = {

--------------------------------------------------------------------------

{ 
	


	reference 	= "m308",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= -895,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/M308.png" 
		}
 	},




{ 
	
	reference 	= "flame",
	vis_toggle = true,


	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 1550,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	color_ = {
		RED_	= 1,
		GREEN_	= 1,
		BLUE_ 	= 1,
		ALPHA   =.8
	},

	-- if animations table exists - frame auto references animation table set

	animation_set = {
		selected_animation = "off",
		on = {
		speed = 2.4,
		matrix = {
			{0,0,-10}, 		-- {frame ,offset_ from local x , Y}
			{2,0,-20,"shell_ejector"},
			{3,0,-50},
			{1,0,-100,"shell_ejector"},
			{2,0,-50},
			{0,0,-50,"shell_ejector"},
			},
		hook = {},
		},
		off = {
		speed = 2.4,
		matrix = {
			{0,0,-10}, 		-- {frame ,offset_ from local x , Y}
			{0,0,-10},
			},
		hook = {},
		}
	},--//animation 
	images 		= {
		"Assets/effects/A_jet.png",
		"Assets/effects/B_jet.png",
		"Assets/effects/C_jet.png",
		}
 	},











---------------------------------------------------------------------------
{ 
	
	reference 	= "engine",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 707,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/ENGINE.png" 
		}
 	},


---------------------------------------------------------------------------


{ 
	
	reference 	= "booster",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 1182,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/BOOSTER_ASYM.png" 
		}
 	},


---------------------------------------------------------------------------



{ 
	
	reference 	= "tail",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 1207,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/TAIL_FIN.png" 
		}
 	},


---------------------------------------------------------------------------

	{ 
	
	reference 	= "l_wing",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 1000,
	local_Y 	= -100,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/L_wing.png" 
		}
 	},

---------------------------------------------------------------------------
	{ 
	
	reference 	= "r_wing",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= -1000,
	local_Y 	= -100,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/R_wing.png" 
		}
 	},
---------------------------------------------------------------------------
	{ 
	
	reference 	= "CONE",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 12,
	local_Y 	= -1290,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/CONE.png" 
		}
 	},

---------------------------------------------------------------------------

	{ 
	
	reference 	= "body",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 3,
	local_Y 	= -66,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/COTPIT.png" 
		}
 	},
--------------------------------------------------------------------------
 		{ 
	
	reference 	= "canopy",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 2,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/CANOPY.png" 
		}
 	},




--------------------------------------------------------------------------

 		{ 
	
	reference 	= "canopy_strap",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 2,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set

	images 		= {
		"Assets/models/XR-5/STRAP.png" 
		}
 	},

-----------------------------------------------------------------------------------------
{ 	
	reference 	= "flash1",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= -400,
	local_Y 	= -700,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set
	animation_set = {
		selected_animation = "f0",


		f1 = {
			matrix = {
			{0,0,-5}, 		-- {frame ,offset_ from local x , Y}
			{1,0,0,random_frame = 0},
			{2,0,10,random_frame = 0},
			{3,0,70,random_frame = 0,"bullet", --[[sound_ = {1}]] },
			{4,0,90,random_spawn = 10,random_frame = 0}, -- muzzle flash variation 
			{4,0,0,random_spawn = 15,random_frame = 0},
			{0,0,0},
		
			
			},
			speed =8.5,
		},

		f0 = {
			matrix = {
			{0,0,0}, 		-- {frame ,offset_ from local x , Y}
			{0,0,0}, 		-- {frame ,offset_ from local x , Y}
			},
			speed =1,
		}, --//EOF 


	},--//animation

	images 		= {
		"Assets/models/WEAPONS_/Match_9/flash/A.png",
		"Assets/models/WEAPONS_/Match_9/flash/B.png",
		"Assets/models/WEAPONS_/Match_9/flash/C.png",
		"Assets/models/WEAPONS_/Match_9/flash/D.png",
		}
 	},--//images
--------------------------------------------------------------


{ 	
	reference 	= "flash2",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 400,
	local_Y 	= -700,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set
	animation_set = {
		selected_animation = "f0",


		f1 = {
			matrix = {
			{0,0,-5}, 		-- {frame ,offset_ from local x , Y}
			{1,0,0,random_frame = 0},
			{2,0,10,random_frame = 0},
			{3,0,70,random_frame = 0,"bullet2",--[[sound_ = {1}]] },
			{4,0,90,random_spawn = 10,random_frame = 0}, -- muzzle flash variation 
			{4,0,0,random_spawn = 15,random_frame = 0},
			{0,0,0},
		
			
			},
			speed =8.5,
		},

		f0 = {
			matrix = {
			{0,0,0}, 		-- {frame ,offset_ from local x , Y}
			{0,0,0}, 		-- {frame ,offset_ from local x , Y}
			},
			speed =1,
		}, --//EOF 


	},--//animation

	images 		= {
		"Assets/models/WEAPONS_/Match_9/flash/A.png",
		"Assets/models/WEAPONS_/Match_9/flash/B.png",
		"Assets/models/WEAPONS_/Match_9/flash/C.png",
		"Assets/models/WEAPONS_/Match_9/flash/D.png",
		}
 	},--//images




--------------------------------------------------------------------------
 	}-- EOF(BODY PARTS)
} -- EOD(model)

return model