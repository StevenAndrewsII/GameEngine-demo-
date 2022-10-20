
local Class = require("Core/LIB/Class")
local Events = require("Core/LIB/Events")
local Scenes = require("Core/LIB/Scene")
-- local World_manager = require("Core/LIB/World_manager")

--love._openConsole()
---------------------------------------------------------------------------------
--[[ order of operations for game stuff from here on !
---------------------------------------------------------------------------------

update 10: 
--// organization of scripts 
--// bug fixes 
--// render 2.0 upgrade 
--// new models and features for animations 
--// every bug found has been figed 
		--[ Error report:
		///// FIXED LIST + extra add ons  ///////

		-> Animator: random key frame matrix override 
		[ just flat out was not working and causing glitching in animations and color switching ]

		-> binding controller to any other object than player caused the player to not know what frame to use/ animations broke 

		-> controller sticks 0 and nil error handling and circumvention 

		-> color alpha channel override for color arbitration:  issues from (emitter and animator )

		-> sprite and animation issues 

		-> world movement ( sway now actually looks good )

		-> animator plug in added: 2.5D object axis rotation ( 3d spin effect: yes its a draw opp )

		/////  NEW BUGS AND ISSUES ( to be fixed ) ///////

		1 - >	attached objects are being updated to position...
				this causes the weapon models to lag behind controller input 
				[ i put a fix in that works... its just a patch not a full fix ] --> this fix can be used 

				** move patch work to movment moduel ( Movement_ should talk to rigging )


		--]





--]]
----------------------------------------------------------------------------------



function love.load()
	math.randomseed(os.time())
end -- eof

limits = love.graphics.getSystemLimits( )
for k,v in pairs(limits) do
	print(k,v)
end



------------------------------------
--// set up scenes
SM = Scenes()
--// create a scene 
SM:add("demo") -- scene 
SM:add("menu_demo") -- scene 
------------------------------------

-- load a model file into the hatchery for the group of Scenes to use
SM:load("demo", "Assets/models/XR-5/mod.lua" ) 

--// test landing gear 
--SM:load("demo", "Assets/models/XR-5/gear_mod.lua" ) 

SM:load("demo", "Assets/models/CHARACTERS_/BASE_MALE/mod.lua" ) 
SM:load("demo", "Assets/models/ORGANIC_/SHRUB_1/mod.lua" )
SM:load("demo", "Assets/models/WEAPONS_/XMT/mod.lua" )
--SM:load("demo", "Assets/models/WEAPONS_/Match_9/mod.lua" ) 		
SM:load("demo", "Assets/models/DETECTIVE_MC30/mod.lua" )		
SM:load("demo", "Assets/models/Avilon MK3/mod.lua" )		    
--SM:load("demo", "Assets/models/SCURGE/mod.lua" )		   
SM:load("demo", "Assets/models/DROIDS/MON/mod.lua" )

SM:load("demo", "Assets/models/VEHICLES_/ForkLift_t1/mod.lua" )
SM:load("demo", "Assets/models/SET_ASSETS/CARGO/box_cargo_t1/mod.lua" )
SM:load("demo", "Assets/models/SET_ASSETS/CARGO/box_cargo_t2/mod.lua" )
SM:load("demo", "Assets/models/SET_ASSETS/BACKDROP/ground_chains_1/mod.lua" )
SM:load("demo", "Assets/DECAL_OVERLAY/GROUND/LANDING/LOT/LOTA/mod.lua" )
SM:load("demo", "Assets/DECAL_OVERLAY/GROUND/LANDING/GUIDES/LANDING_GUIDE_1/mod.lua" )
--//landing gear test 
--SM:add_object( "demo","landing_gear","XR5_landing_gear",{X = (love.graphics.getWidth( )/2),Y = love.graphics.getHeight( )/2, Z = 200 })

------------------------------------------
--// create test scene with objects  ( populate )
------------------------------------------

--// player 1 and weapons 
local p1 = SM:add_object( "demo","player_1","player",{X = (love.graphics.getWidth( )/2),Y = love.graphics.getHeight( )/2, Z = 201 }) 									
--local gun = SM:add_object( "demo","Match_9","Match_9",{X = love.graphics.getWidth( )/2+3000,Y = love.graphics.getHeight( )/2-3000,Z = 0})
local gun2 = SM:add_object( "demo","XMT","XMT",{X = love.graphics.getWidth( )/2+3000,Y = love.graphics.getHeight( )/2-3000,Z = 0})



--// space craft test 
SM:add_object( "demo","Avilon","Avilon",{X = love.graphics.getWidth( )/-5000 ,Y = love.graphics.getHeight( )/2+3000 , Z = 202}) 
local t_ = SM:add_object( "demo","MC-30","MC-30",{X = love.graphics.getWidth( )/2 - 2000,Y = love.graphics.getHeight( )/2 -800, Z = 202})
local o__ = SM:add_object( "demo","XR-5","XR-5",{X = love.graphics.getWidth( )/2 + 2000,Y = love.graphics.getHeight( )/2 -800, Z = 202})

--// droids and decor vehincles 
local mon_ = SM:add_object( "demo","MON","MON",{X = (love.graphics.getWidth( )/2-200),Y = love.graphics.getHeight( )/2-500, Z = 249 })
local fork = SM:add_object( "demo","fork_lift_1","fork_lift_t1",{R =340,X = (love.graphics.getWidth( )/2-200),Y = love.graphics.getHeight( )/2-2100, Z = 202 })

--// usable decor 
local crate1 = SM:add_object( "demo","box_cargo_t1","box_cargo_t1",{R = 35,X = (love.graphics.getWidth( )/2-700),Y = love.graphics.getHeight( )/2-2700, Z = 200 })
local crate2 = SM:add_object( "demo","box_cargo_t2","box_cargo_t2",{R = 60,X = (love.graphics.getWidth( )/2-500),Y = love.graphics.getHeight( )/2-3200, Z = 200 })

--// decor 
local chains1 = SM:add_object( "demo","ground_chains_1","ground_chains_1",{X = (love.graphics.getWidth( )/2+300),Y = love.graphics.getHeight( )/2-3100, Z = 200 })
local chains1 = SM:add_object( "demo","ground_chains_1-1","ground_chains_1",{R = 45, X = (love.graphics.getWidth( )/2+400),Y = love.graphics.getHeight( )/2-2600, Z = 200 })

--// floor decals 
local lotsign = SM:add_object( "demo","LANDING_LOT_SIGN_A1-1","LANDING_LOT_SIGN_A1",{ X = (love.graphics.getWidth( )/2+2000),Y = love.graphics.getHeight( )/2-3200, Z = 200.1 })
local lotguide_1 = SM:add_object( "demo","LANDING_GUIDE_1-1","LANDING_GUIDE_1",{ X = (love.graphics.getWidth( )/2-3000),Y = love.graphics.getHeight( )/2-3200, Z = 200.1 })


-------------------------------------------------
--// testing core features 
-------------------------------------------------
local test_lights = true 



--// manual test for gun attachment 
p1.Rigging_:attatch_obj("hand","XMT","XMT","torso") 





local to_hex = -65
local hex = string.format("%02x",to_hex, 0xFF)
print("hex = "..hex)


--// create loghts 
--// handles name that are duplicated 
--// handles no name input with default values 
--// random name generation version 3 

if test_lights then 

local light_1 = SM.Scenes["demo"].hatch_.LSM:create_light(love.graphics.getWidth( )/2-200,love.graphics.getWidth( )/2-500,250,{diffuse_ = {1,.5,0},strength_ = 10},"warm_light" )

local light_2 = SM.Scenes["demo"].hatch_.LSM:create_light(love.graphics.getWidth( )/2-2000,love.graphics.getWidth( )/2-700,250,{diffuse_ = {0,.5,1},strength_ = 50},"warm_light" )

local light_3 = SM.Scenes["demo"].hatch_.LSM:create_light(love.graphics.getWidth( )/2-5000,love.graphics.getWidth( )/2+3000,250,{diffuse_ = {0,1,0},strength_ = 20})
local light_4 = SM.Scenes["demo"].hatch_.LSM:create_light(love.graphics.getWidth( )/2-5000,love.graphics.getWidth( )/2+3000,250,{diffuse_ = {0,1,0},strength_ = 20})
local light_3 = SM.Scenes["demo"].hatch_.LSM:create_light(love.graphics.getWidth( )/2-5000,love.graphics.getWidth( )/2+3000,250,{diffuse_ = {0,1,0},strength_ = 20})


end 





SM:render_manager("demo",true)

SM:bind_controller(		"demo","player_1"		)
--// lock camera to an object 
SM:lock_camera(			"demo","player_1"	,false	)
--// follow an object 
--SM:follow_camera(		"demo","player_1"	,false	)




--p1.Rigging_:remove_obj("hand","XMT","XMT")
--p1.Rigging_:remove_vertex("hand")

SM:move_sway("demo","MON",90,1,-1,0,0)











--// auto low memory handler 
function love.lowmemory()
    collectgarbage()
end
--// rendering system 
function love.draw()
SM:render_scene(  ) -- added camera function (product of camera being directly attached to the scene )	
end
--// clock (game logic clocks )
local counter = 0 
local state______ = 0


function love.update(dt)

--[[ deletion emitter problem ]]
--[[
if counter > 5000  and state______ == 0 then 
	state______ = 1
	SM:remove_object("demo","player_1") 
else 
	counter = counter +1
end --]]

SM:HIGHupdate_(dt)
SM:update_(dt)
end




