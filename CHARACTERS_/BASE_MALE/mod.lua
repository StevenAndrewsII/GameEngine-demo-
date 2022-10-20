
local model = {
-- model file format example... 2020 tech demo 
-- Steven Andrews II
-- version 10.6 ( updated in 10-6 )



-- object class type
type = "player",
-- model coordinates in free space... 
--(center of model and point of reference for bellow images)




Inventory = {

weapon_slots 		= 3,
consumable_slots 	= 10,

weapons = {
	"XMT",
	"pistol",
},




},







-- controls 

--// 8.0 not used yet 
moduel_toggle = {
	ModelController_ 	= true,
	Movement_ 			= true,
	Rigging_ 			= true,
	--// modules to tie into by default to the object on creation 
},


--// update 8.0 controller binding structure 

controller_bind = {

	AI_Controller 			= false, -- // AI controller bind for 10.0 update 
	controller_dat 			= { },  --// unused so far 
	controls = {

		

		{
			id 				= "fire",
			--// vertex call/push
			vertex_trigger 	= "hand", 	    
			con_bind_id 	= "triggerright",
			button_axis 	= "axis",
			subtype 		= "trigger_",

			
		
			
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 







		{
			id 				= "use",	    
			con_bind_id 	= "x",
			button_axis 	= "button",





		},



		{
			id 				= "swap",	    
			con_bind_id 	= "y",
			button_axis 	= "button",


			

		},



	
	

		---(  reload  )-------------------------------------------

		{
			id 				= "reload",	    
			con_bind_id 	= "b",
			button_axis 	= "button",
			single_action 	= true, --// single opp 

			-- out dated 
			
			--[[
			animation_toggle = { 
				--// pistol animations 
				{"torso",	"f1",	true  }, 							-- f0 is triggered when its false 
				{"torso",	"f2",	false },					
			},
			--]]

			--[


				animation_toggle = { 
				--// animation grouping demo  (classes )

				group_ = {
					selection = "Flame_",

					pistol_ = {
						{"torso",	"f1",	true  }, 							-- f0 is triggered when its false 
						{"torso",	"f2",	false },	
					},

					SMG_ = {
						{"torso",	"f3",	true  }, 							-- f0 is triggered when its false 
						{"torso",	"f2",	false },	
					},

					Rifle_ = {
						{"torso",	"f4",	true  }, 							-- f0 is triggered when its false 
						{"torso",	"f2",	false },
					},

					Flame_ = {
						{"torso",	"f3",	true  }, 							-- f0 is triggered when its false 
						{"torso",	"f3",	false },
					}

				},				
			},


			--]]



			-- if true/exists then 
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 

		---(  movement forward  )----------------------------------

		{
			id 				= "stick_left",
			--vertex_trigger 	= "hand", 	    
			con_bind_id 	= "lefty",
			button_axis 	= "axis",
			subtype 		= "left_" ,
			--dead_zone = .5,

			animation_toggle = { 
				{"legs","f1",-1, state = false,	move = {speed = 15	}	, animationSetWait_skip = true}, 							-- f0 is triggered when its false 
				{"legs",	"f2",	0	, state = false ,animationSetWait_skip = true},
				{"legs","f3",.9, state = false,		move = {speed = -8}		, animationSetWait_skip = true },			
			},
			-- if true/exists then 
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 

		---(  strafe  )------------------------------------------
		{
			id 				= "stick_leftx",
			--vertex_trigger 	= "hand", 	    
			con_bind_id 	= "leftx",
			button_axis 	= "axis",
			subtype 		= "left_" ,

			animation_toggle = { 
				{"legs",	"f3",	-.7 	, state = false,	move = {speed = -8,	R = 90	}	,animationSetWait_skip = true}, 							-- f0 is triggered when its false 
				--{"legs",	"f2",	0	,state = false, animationSetWait_skip = true},
				{"legs",	"f3",	.7		,state = false,	move = {speed = 8,	R = 90	}	,animationSetWait_skip = true},					
			},
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 

				---(  Rotate  )-------------------------------------------

		{
			id 				= "stick_rightX",
				    
			con_bind_id 	= "rightx",
			button_axis 	= "axis",
			subtype 		= "right_" ,

			--// rotation settings 
			neg_rotate 		= -1,
			pos_rotate 		= 1,
			rotate_speed 	= 5,
			rotation_amt 	= 5,
			rotate_deadZone = 0.20,
			
 
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 


		{
			id 				= "dpup_zoom",
				    
			con_bind_id 	= "dpup",
			button_axis 	= "button",
			

			--// zoom toggle  
			
			zoom_speed	 	= 5,
			zoom_ = true,
			-- add min ( lock to locked camera Z)
			
			
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 

		{
			id 				= "dpdown_zoom",
				    
			con_bind_id 	= "dpdown",
			button_axis 	= "button",
			

			--// zoom toggle  
			
			zoom_speed	 	= -5,
			zoom_ = true,
			
			
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 





		--(  sprint  )--------------------------------------------
		{
			id 				= "sprint",    
			con_bind_id 	= "leftstick",
			button_axis 	= "button",


			animation_toggle = { 
				{		"legs", 							-- layer
						"f4", 								-- animation set 
						true,								-- activation state 
				 		state = false,						-- default false 
				 		move = {speed = 10	},				-- movement binding 
				  		animationSetWait_skip = true,		-- skip any current animation set on the end frame 
				   		--// hold for 
				   		hold_for = {
				   			{	con_bind_id 	= "lefty",
								button_axis 	= "axis",
								subtype 		= "left_" ,}
						,value = -1}			
				 }, 									
			},

			
		}, -- bind EOT // VERTEX TRIGGER EXAMPLE 

	--------------------------------------------------
	}, -- // list of control mappings for movement in animation 


	

}, -- // EOT : controller_bind


world_cords = {
X = 0,				-- leave at 0 
Y = 0,  			-- leave at 0 
Z = 0,  			-- leave at 0 
size = 5,
R = 45,				-- the rotation vector 
vis_ = true,		-- full object visibility // manipulated by culling
--vis_toggle = true,  -- bypass state //ex: if culling says its visible then you can force it invisible

},


color_ = {
ALPHA 	= 1,
RED_	= 1,
GREEN_	= 1,
BLUE_ 	= 1,
},




-- expressed in rotation degrees 
-- since all objects are turned about a center

--//



vertex_points  = {  
	{ -- points to which an object may be spawned or used as a reference 		
	point_name = "hand", 						-- name of the point 
	X = 0, 										-- engine oriented
	Y = 0, 										-- engine oriented 
	Z = 0,										-- engine oriented
	RAD = 350, 									-- distance from center
	ROT = 3.35,									-- object off set rotation about center point - 3.35deg =in hand for hand gun 
	--attached_objects ={ {"Match_9","Match_9",enabled = true,true,file = "Assets/models/WEAPONS_/Match_9/mod.lua"}, }, 	-- object attachment to vertex_points// object_name // attached_bool // activity status
	--// attached weapon handler 

	},
},







-- All parts and images for each part... 
-- All parts must be in order from first drawn to last in descending order..
body_parts = {
--------------------------------------------------------------------------=

	{ 
	reference 	= "legs",
	-- do not edit, computer aided 
	vis_toggle = true,
	visible 	= true,
	frame 		= 1,        -- now refers to animation / if field exists (must not be 0)
	local_X 	= 0,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,
	-----------------------------
	--  Grey jump suit  = f1
	animation_set = {
		--  Grey jump suit  = f1
		selected_animation = "f2",


		f4 = { -- sprint
			matrix = {
			{1,0,0}, 		-- {frame,x,y,z,r,{RGBA} or nil} new 
			{2,0,0},
			{3,0,0},
			{4,0,0},
			{3,0,0},
			{2,0,0},
			{1,0,0},
			},
			speed =1.2,
			hooks = {} 		-- hooked events list
		},





		f1 = {
			matrix = {
			{1,0,0}, 		-- {frame,x,y,z,r,{RGBA} or nil} new 
			{2,0,0},
			{3,0,0},
			{4,0,0},
			{3,0,0},
			{2,0,0},
			{1,0,0},
			},
			speed =1,
			hooks = {} 		-- hooked events list
		},

		f2 = {
			matrix = {
			{1,0,0}, 		-- {frame,x,y,z,r,{RGBA} or nil} new 
			},
			speed =1,
			hooks = {} 		-- hooked events list
		},

		f3 = {
			matrix = {
			{1,0,0}, 		-- {frame,x,y,z,r,{RGBA} or nil} new 
			{2,0,0},
			{3,0,0},
			{4,0,0},
			{3,0,0},
			{2,0,0},
			{2,0,0},
			{1,0,0},
			},
			speed =.9,
			hooks = {} 		-- hooked events list
		},

	},

	images 		= {
		"Assets/models/CHARACTERS_/BASE_MALE/legs/A.png",
		"Assets/models/CHARACTERS_/BASE_MALE/legs/B.png",
		"Assets/models/CHARACTERS_/BASE_MALE/legs/C.png",
		"Assets/models/CHARACTERS_/BASE_MALE/legs/D.png" 
		}
 	},
---------------------------------------------------------------------------


 	{ 

	reference = "back_pack",
	vis_toggle = false,


	visible 	= true,
	frame 		= 1, 
	local_X 	= -5,
	local_Y 	= 110,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,
	images = {"Assets/models/CHARACTERS_/BASE_MALE/backpacks/MK1-O2.png"}
 	},


--------------------------------------------------------------------------
 	{ 

 	
	reference 	= "torso",
	vis_toggle = true,


	visible 	= true,
	frame 		= 1,
	local_X 	= 0,
	local_Y 	= -145,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,

	--// this marks the spot in rendering to attach an object 
	--AO_position = true, 

	animation_set = {
		selected_animation = "f2",

		f1 = { -- pistol reload
			matrix = {
			{1,0,0}, 		-- {frame ,offset_ from local x , Y}
			{2,0,0},
			{3,0,0},
			{4,0,0},
			{5,0,0},
			{5,0,0},
			{5,0,0},
			{4,0,0},
			{3,0,0},
			{2,0,0},
			{1,0,0},
			{1,0,0},
			{1,0,0},
			{1,0,0},
			{1,0,0},
			{1,0,0},
			},
			speed =1.8,
			hooks = {} 		-- hooked events list
		},

		f2 = { --// holding weapon ready
			matrix = {
			{1,0,0}, 		-- {frame ,offset_ from local x , Y}
			},
			speed =10,
			hooks = {} 		-- hooked events list
		},

		f3 = {
			matrix = {
			{6,90,-50}, 		-- {frame ,offset_ from local x , Y}
			{6,90,-50},
			{6,90,-50},
			},
			speed =10,
			hooks = {} 		-- hooked events list
		},


	},--//animations




	images = {
		"Assets/models/CHARACTERS_/BASE_MALE/body/pistol_grip_led_A.png",
		"Assets/models/CHARACTERS_/BASE_MALE/body/pistol_grip_led_B.png",
		"Assets/models/CHARACTERS_/BASE_MALE/body/pistol_grip_led_C.png",
		"Assets/models/CHARACTERS_/BASE_MALE/body/pistol_grip_led_D.png",
		"Assets/models/CHARACTERS_/BASE_MALE/body/pistol_grip_led_E.png",
		"Assets/models/CHARACTERS_/BASE_MALE/body/heavy_grip_A.png"

		}
 	},
-------------------------------------------------------------------------
--------------------------------------------------------------------------
 	{ 
	reference 	= "torso_rain",
	vis_toggle = false,


	visible 	= true,
	frame 		= 1,
	local_X 	= 0,
	local_Y 	= -136,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,


	animation_set = {
		selected_animation = "f2",

		f1 = { -- pistol reload
			matrix = {
			{1,0,0,random_frame = 2}, 		-- {frame ,offset_ from local x , Y}
			{1,0,0,random_frame = 0},
			{0,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{1,0,0,random_frame = 0},
			{1,0,0,random_frame = 2},
			{1,0,0,random_frame = 0},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
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
		"Assets/models/CHARACTERS_/BASE_MALE/body/rain_layer_A.png",
		"Assets/models/CHARACTERS_/BASE_MALE/body/rain_layer_A2.png",
		}
 	},
-------------------------------------------------------------------------



 	{ 

	reference = "head",
	vis_toggle = true,


	visible 	= true,
	frame 		= 1, 
	local_X 	= 0,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,
	images = {"Assets/models/CHARACTERS_/BASE_MALE/heads/A.png"}
 	},

------------------------------------------------------------------------

 	{ 

	reference = "helmet",
	vis_toggle = false,


	visible 	= true,
	frame 		= 1, 
	local_X 	= 0,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,
	images = {"Assets/models/CHARACTERS_/BASE_MALE/helmet/A.png"}
 	},
 	--------------------------------------
{ 
	reference 	= "head_rain",
	vis_toggle = false,


	visible 	= true,
	frame 		= 1,
	local_X 	= 0,
	local_Y 	= 0,
	local_ROT 	= 0,
	width 		= 0,
	height 		= 0,


	animation_set = {
		selected_animation = "f2",

		f1 = { -- pistol reload
			matrix = {
			{1,0,0,random_frame = 2}, 		-- {frame ,offset_ from local x , Y}
			{1,0,0,random_frame = 0},
			{0,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{1,0,0,random_frame = 0},
			{1,0,0,random_frame = 2},
			{1,0,0,random_frame = 0},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
			{2,0,0,random_frame = 1},
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
		"Assets/models/CHARACTERS_/BASE_MALE/heads/rain_layer_A.png",
		"Assets/models/CHARACTERS_/BASE_MALE/heads/rain_layer_B.png",
		}
 	},

 	--------------------------






}



} -- EOD(model)

return model