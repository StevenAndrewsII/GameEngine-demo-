
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
type = "Match_9",

world_cords = {
X = 0,
Y = 0,
Z = 0,
R = 0,
vis_ = true,
vis_toggle = true, 
},


--// update 8.0 
sound = { -- all sounds for this model (file,name id,type)
{"Assets/sound/guns/pistol/9mm.wav", "9mm", "static" }-- firing 
-- reload
-- draw
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
				{"flash","f0",0},
				{"flash","f1",.5},						
			},
			--// UPDATE 8.0 - controller rumble 			
			rumble = {
				ramp = 0.001,
				max_amt_ = 0.15,
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
	RAD 	= 25, 									-- distance from center
	ROT 	= 90,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "9mm",							-- emitter object
		file_ 			= "Assets/models/WEAPONS_/shells_/9mm_mod.lua",	
		speed	 		= 20,								-- emission speed
		speed_min	 	= 15,								-- random speed between min and speed // does not have to exist 
		life	 		= 20,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = 18,						-- the range that objects will be spawned in 
		angle = 0,
		--state = false,							-- the state of the vertex
		emition_number  = 1,						-- number of objects to emit per call
		shrink = false,
		rotation 		= 10,					-- the amount and speed/ 60 fps
		rand_rot = true,
	}, 
	},--// VT1


	{ --// VT1		
	point_name = "flametest_2", 				-- name of the point 
	X 		= 0, 										-- engine oriented
	Y 		= 0, 										-- engine oriented 
	Z 		= 0,
	RAD 	= 25, 									-- distance from center
	ROT 	= 90,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "fire",							-- emitter object
		file_ 			= "Assets/effects/fire_flash/mod.lua",	
		speed	 		= 0,								-- emission speed
		speed_min	 	= 0,								-- random speed between min and speed // does not have to exist 
		life	 		= 25,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = 5,						-- the range that objects will be spawned in 
		angle = -90,
		--state = false,							-- the state of the vertex
		emition_number  = 1,						-- number of objects to emit per call
		shrink = false,
		grow = true,
		rotation 		= 0,					-- the amount and speed/ 60 fps
		rand_rot = true,
	}, 
	},--// VT1

	{ --// VT1		
	point_name = "flametest_3", 				-- name of the point 
	X 		= 0, 										-- engine oriented
	Y 		= 0, 										-- engine oriented 
	Z 		= 0,
	RAD 	= 25, 									-- distance from center
	ROT 	= 90,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "fire",							-- emitter object
		file_ 			= "Assets/effects/fire_flash/mod.lua",	
		speed	 		= 100,								-- emission speed
		speed_min	 	= 80,								-- random speed between min and speed // does not have to exist 
		life	 		= 25,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = 5,						-- the range that objects will be spawned in 
		angle = -90,
		--state = false,							-- the state of the vertex
		emition_number  = 1,						-- number of objects to emit per call
		shrink = false,
		grow = true,
		rotation 		= 0,					-- the amount and speed/ 60 fps
		rand_rot = true,
	}, 
	},--// VT1


-- // to do:
--[[ // add collision detection sub routines for selected particle emitters


	]] -- 

	

		{ --// VT1		
	point_name = "bullet", 				-- name of the point 
	X 		= 0, 										-- engine oriented
	Y 		= 0, 										-- engine oriented 
	Z 		= 0,
	RAD 	= 120, 									-- distance from center
	ROT 	= 0,									-- object rotation 	
	emitter__ = { 	-- an attached emitter								-- emitter constructor 
		object 			= "9mm_projectile",							-- emitter object
		file_ 			= "Assets/effects/projectile/mod.lua",	
		speed	 		= 220,								-- emission speed
		speed_min	 	= 190,								-- random speed between min and speed // does not have to exist 
		life	 		= 20,								-- life of the object
		fade 			= true,							-- fade out over life time
		range           = 2,
		angle = 0,	--// offset angle/ ejection angle 
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
--------------------------------------------------------------------------=

	{ 	
	reference 	= "body",
	vis_toggle  = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	-- if animations table exists - frame auto references animation table set
	animation_set = {
		selected_animation = "f0",

		f1 = {
			matrix = {
			{1,0,-2,arbitration = {.98,.95,.64,1}	}, 		-- {frame ,offset_ from local x / Y,vertex call, color arbitration call}
			{2,0,-4,arbitration = {.98,.95,.64,1}, "flametest_",	sound_ = {1}	},  -- added sound, {sound ref, stop playing at end of animation bool_}
			{3,0,-6,arbitration = {.98,.95,.64,1}},		 -- added color arbitration for animations ( applied to attached objects ? )
			{4,0,-8},
			{5,0,-10},
			{1,0,0},
			{1,0,0},
			 
			},
			speed =8.5,

		}, --//EOF 

		f0 = {
			matrix = {
			{1,0,0}, 		-- {frame ,offset_ from local x , Y}
			},
			speed =1,
		}, --//EOF 


	},--//animations

	images 		= {
		"Assets/models/WEAPONS_/Match_9/A.png",
		"Assets/models/WEAPONS_/Match_9/B.png",
		"Assets/models/WEAPONS_/Match_9/C.png",
		"Assets/models/WEAPONS_/Match_9/D.png",
		"Assets/models/WEAPONS_/Match_9/E.png",
		}
 	}, --//images
-----------------------------------------------------------------------
{ 
	reference 	= "head_rain",
	vis_toggle = true,


	visible 	= true,
	frame 		= 1,
	local_X 	= 0,
	local_Y 	= -28,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,


	animation_set = {
		selected_animation = "f2",

		f1 = { -- pistol reload
			matrix = {
			{1,0,0,random_frame = 0}, 		-- {frame ,offset_ from local x , Y}
			{1,0,0,random_frame = 0},
			{0,0,0,random_frame = 0},
			{2,0,0,random_frame = 0},
			{2,0,0,random_frame = 0},
			{2,0,0,random_frame = 1},
			{1,0,0,random_frame = 0},
			{1,0,0,random_frame = 2},
			{1,0,0,random_frame = 0},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 0},
			{2,0,0,random_frame = 0},
			{2,0,0,random_frame = 0},
			},
			speed =2,
			hooks = {} 		-- hooked events list
		},

		f2 = {
			matrix = {
			{0,0,0}, 		-- {frame ,offset_ from local x , Y}
			},
			speed =10,
			hooks = {} 		-- hooked events list
		},

	},--//animations




	images = {
		"Assets/models/WEAPONS_/Match_9/rain_A.png",
		"Assets/models/WEAPONS_/Match_9/rain_B.png",
		}
 	},

 	--------------------------
 	{ 	
	reference 	= "flash",
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= -230,
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
			{3,0,70,random_frame = 0,"bullet" },
			{4,0,90,random_spawn = 10,random_frame = 0}, -- muzzle flash variation 
			{4,0,0,random_spawn = 15,random_frame = 0},
			{0,0,0},
		
			
			},
			speed =8.5,
		},

		f0 = {
			matrix = {
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
}
--------------------------------------------------------------
} -- EOD(model)

return model