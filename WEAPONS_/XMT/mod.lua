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
type = "XMT",

world_cords = {
X = 0,
Y = 0,
Z = 0,
R = 0,
vis_ = true,
vis_toggle = true, 
},






-- // controller binding options and settings 
controller_bind = {


	controls = { -- control map list of IDs 

		--// id = fire
		{
			id = "fire",			-- unique id ( IDs are linked to parents and children by default.. )
			-- a table that contains animation binding// bool_ value for control state  
			animation_toggle = { 
				{"body","f0",0}, 	-- f0 is triggered when false 
				{"body","f1",.5},						
			},
			--// UPDATE 8.0 - controller rumble 			
			rumble = {
				ramp = 0.0005,
				max_amt_ = 0.03,
				state = .5,
			},
			--// UPDATE 8.0 - CAMERA SHAKE			
			camera_rumble = {
				state = .5,
				amount = 60, 
			},
		}, -- // EOT - fire 

	}, -- // list of control mappings for movement in animation 


	

}, -- // EOT : controller_bind





--------------------------------------------------------------------------
color_ = {
ALPHA 	= 1,
RED_	= 1,
GREEN_	= 1,
BLUE_ 	= 1,
},
-------------------------------------------------------------------------- Assets/effects/fire_flash/

vertex_points  = {  
	

	{ --// VT1		
	point_name = "flametest_", 				-- name of the point 
	X 		= 0, 										-- engine oriented
	Y 		= 0, 										-- engine oriented 
	Z 		= 0,
	RAD 	= 300, 									-- distance from center
	ROT 	= 0,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "fire",							-- emitter object
		file_ 			= "Assets/effects/fire_flash/mod.lua",	
		speed	 		= 120,								-- emission speed
		speed_min	 	= 60,								-- random speed between min and speed // does not have to exist 
		life	 		= 25,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = 8,						-- the range that objects will be spawned in 
		angle = 0,
		
		--state = false,							-- the state of the vertex
		emition_number  = 1,						-- number of objects to emit per call
		shrink = false,
		grow = true,
		rotation 		= 10,					-- the amount and speed/ 60 fps
		rand_rot = true,
	}, 
	},--// VT1


-- // to do:
--[[ // add collision detection sub routines for selected particle emitters


	]] -- 

	

		
},


--------------------------------------------------------------------------
body_parts = {
--------------------------------------------------------------------------=

	{ 	
	reference 	= "body",
	vis_toggle  = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= -15,
	local_Y 	= 90,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set
	animation_set = {
		selected_animation = "f0",

		f1 = {
			matrix = {
			{1,0,0,arbitration = {1,.95,.60,1}, "flametest_"	}, 		-- {frame ,offset_ from local x / Y,vertex call, color arbitration call}
			{2,0,0,arbitration = {.98,.75,.60,1}, "flametest_"	},  -- added sound, {sound ref, stop playing at end of animation bool_}
			{3,0,0,arbitration = {1,.90,.5,1}, "flametest_" },		 -- added color arbitration for animations ( applied to attached objects ? )
			{4,0,0, "flametest_"},
			{5,0,0,arbitration = {.98,.95,.60,1}, "flametest_"},
			{1,0,0, "flametest_"},
			{1,0,0, "flametest_"},
			 
			},
			speed =8.5,

		}, --//EOF 

		f0 = {
			matrix = {
			{2,0,0,random_frame = 1},
			{3,0,0,random_frame = 3},
			{4,0,0,random_frame = 2}, 
			{1,0,0,random_frame = 4},
			{3,0,0,random_frame = 2},
			{4,0,0,random_frame = 2}, 
			{1,0,0,random_frame = 4},
			{3,0,0,random_frame = 2},
			{4,0,0,random_frame = 3}, 
			{1,0,0,random_frame = 4},
			{3,0,0,random_frame = 3},
			{4,0,0,random_frame = 1}, 		-- {frame ,offset_ from local x , Y}
			},
			speed =2,
		}, --//EOF 


	},--//animations

	images 		= {
		"Assets/models/WEAPONS_/XMT/XMT.png",
		"Assets/models/WEAPONS_/XMT/XMT_1.png",
		"Assets/models/WEAPONS_/XMT/XMT_2.png",
		"Assets/models/WEAPONS_/XMT/XMT_3.png",
		"Assets/models/WEAPONS_/XMT/XMT_4.png",
		}
 	}, --//images
-----------------------------------------------------------------------









--------------------------------------------------------------
}
--------------------------------------------------------------
} -- EOD(model)

return model