local Class = require("Core/LIB/Class")
local Hatchery = require("Core/LIB/Hatchery")															-- get the Hatchery_
local Camera = require("Core/LIB/Camera")																-- get the camera system
local Scene = Class:derive("Scene")																		-- get class system
local Events = require("Core/LIB/Events")
local Controller 		= require("Core/LIB/Controller")

-----------------------------------------------------------------------------
--[[ Scene Manger (front end) version 2.5 --> version 3 comes in 9.0 ( world systems )
-----------------------------------------------------------------------------
-- updated architecture 
-- now creates a new hatchery for each new scene 
-- brought up the camera functions to the front end 
-- error and bug fixes within the new update ( all working as of June 11th )
-- added forward user interface with back end sub systems ( 2.7)

~~ created by: Steven Andrews II
]]
-----------------------------------------------------------------------------



function Scene:new(fps_params) 
	-- create the Hatchery_/ entity handler lib to each new scene object 
	-- scenes hold the objects for the scene and the camera. 	
self.Scenes = {} 							-- scene names and their objects names


--// update 8.0 // fps control 
local fpsp_ = {}
if type(fps_params) == "table" then 
	fpsp_ = fps_params --// set val 
end 
--// update frame rate settings ( 8.0 )
self.accum 				= 0 								-- accumulator leave at 0
self.interval 			= fpsp_.interval or ( 1/60)		-- 60 FPS (fixed interval step)
self.gb_colect			= 0 								-- garbage collection leave at 0
self.gb_frequency 		= fpsp_.gb_frequency or ( 350 )		-- how often to dump garbage 
self.maxFrame_skip	 	= fpsp_.maxFrame_skip or ( 6 )		-- max frame skip ( on release hold at 6 )


self.accum_H 				= 0 								-- accumulator leave at 0
self.interval_H 			= fpsp_.interval_H or ( 1/120 )		-- 60 FPS (fixed interval step)
self.maxFrame_skip_H	 	= fpsp_.maxFrame_skip_H or ( 6 )		-- max frame skip ( on release hold at 6 )
self.C = Controller()
self.C:select_controller(1)										--// must be here// on boot controller selection 

-- map system 

end

----------------------------------------------------------------------------------------------------------------------------------------------------
-- Scene binding 
----------------------------------------------------------------------------------------------------------------------------------------------------


function Scene:add(scene_name) 												
	assert(self.Scenes[scene_name] == nil, "Scene:add(): " .. scene_name .. " already exists!")
	-- holds all the scene items : order scene_name -> hatchery_ - > objects 
	self.Scenes[scene_name] = {}
	self.Scenes[scene_name].objects = {} 											-- all known objects contain ( all Scenes ) 
	self.Scenes[scene_name].hatch_  = Hatchery( Camera(),self, scene_name , self.C ) 		-- creates a hatchery for the new scene + adds camera 
	self.Scenes[scene_name].hatch_.Camera.hatch_ = self.Scenes[scene_name].hatch_ 	-- pass the hatch to the camera 
	self.Scenes[scene_name].state 	= false											-- scene render state 
end


-- need to beef this up for object deletion 

function Scene:bind_controller(scene_name,k)
	if self.Scenes[scene_name].hatch_.objects[k].controller_bind then 
		self.Scenes[scene_name].hatch_.C.controller_bound__ = k
	end
end




----------------------------------------------------------------------------------------------------------------------------------------------------
-- world building 
----------------------------------------------------------------------------------------------------------------------------------------------------












----------------------------------------------------------------------------------------------------------------------------------------------------
-- Hatchery binding
----------------------------------------------------------------------------------------------------------------------------------------------------

-- hatchery load model file 
function Scene:load(scene_name,file)
self.Scenes[scene_name].hatch_:load(file)
end



-- hatchery add object
function Scene:add_object(scene_name,object_name,object_type,spawn_vector_table)
		local obj = self.Scenes[scene_name].hatch_:create_object(scene_name, object_name, object_type, spawn_vector_table)
		self.Scenes[scene_name].objects[object_name] = {}	
		if obj then 
		return obj
		end					
end

-- hatchery remove object
function Scene:remove_object(scene_name,object_name) 		 												
		if self.Scenes[scene_name].objects[object_name] then 
			local result_ = self.Scenes[scene_name].hatch_:object_remove(object_name)
					if result_ then
					self.Scenes[scene_name][object_name] = nil 
					return result_
					else return false
					end	
		end 								
end

function Scene:get_object(scene_name,object_name) 		 												
		if self.Scenes[scene_name].objects[object_name] then 
		 return self.Scenes[scene_name].hatch_:object_exists(object_name,true)
		end 								
end






--// larger models made of several small individual models 
function Scene:load_composite(scene_name, o_list )
	-- body
end

----------------------------------------------------------------------------------------------------------------------------------------------------
-- Object movement bindings 
----------------------------------------------------------------------------------------------------------------------------------------------------

-- individual object manipulation 

function Scene:move_objectX(scene_name,object_name,x_speed)
	if self.Scenes[scene_name].objects[object_name] then 
		self.Scenes[scene_name].hatch_.objects[object_name].Movement_:move_X(x_speed)
	end
end
function Scene:move_objectY(scene_name,object_name,y_speed)
	if self.Scenes[scene_name].objects[object_name] then 
		self.Scenes[scene_name].hatch_.objects[object_name].Movement_:move_Y(y_speed)
	end
end
function Scene:move_objectZ(scene_name,object_name,z_speed)
	if self.Scenes[scene_name].objects[object_name] then 
		self.Scenes[scene_name].hatch_.objects[object_name].Movement_:move_Z(z_speed)
	end
end

function Scene:move_sway(scene_name,object_name,angle,speed,distance,dampening,duration)
	if self.Scenes[scene_name].objects[object_name] then 
		self.Scenes[scene_name].hatch_.objects[object_name].Movement_:sway(angle,speed,distance,dampening,duration) 
	end
end

function Scene:move_shake(scene_name,object_name,amount)
	if self.Scenes[scene_name].objects[object_name] then 
		self.Scenes[scene_name].hatch_.objects[object_name].Movement_:shake(amount)
	end
end


----------------------------------------------------------------------------------------------------------------------------------------------------
-- camera bindings
----------------------------------------------------------------------------------------------------------------------------------------------------


--// camera lock 2.0				(update 8.0)
function Scene:lock_camera(scene_name,object_name,bool_)
	--// pass object reference 
	local O_ = self.Scenes[scene_name].hatch_:object_exists(object_name,true) 
	self.Scenes[scene_name].hatch_.Camera:lockon(O_,bool_)
end
--// chase cam/ follow camera 2.0 	(update 8.0)
function Scene:follow_camera(scene_name,object_name,bool_)
	--// pass object reference 
	local O_ = self.Scenes[scene_name].hatch_:object_exists(object_name,true) 
	self.Scenes[scene_name].hatch_.Camera:follow(O_,bool_)
end
--// Camera Zoom 					(update 1.0)
function Scene:zoom_camera(scene_name,Z)
	self.Scenes[scene_name].hatch_.Camera:zoom(Z)
end




----------------------------------------------------------------------------------------------------------------------------------------------------
-- Render bindings 
-- add stack buffer 8.0
----------------------------------------------------------------------------------------------------------------------------------------------------



-- render manager, flip states 
function Scene:render_manager(scene_name,state)
	self.Scenes[scene_name].state = state 
end


-- push hatchery to render 
function Scene:render_scene()
	for k,v in pairs(self.Scenes) do
		if v.state == true then 
		v.hatch_:render()
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------
-- update binding // frame rate control per scene 
----------------------------------------------------------------------------------------------------------------------------------------------------

--// change settings 
function Scene:FPS_settings(settings_table)
	if type(settings_table) == "table" then 
		self.interval 		= settings_table.interval 		or self.interval 	-- 60 FPS (fixed interval step)
		self.gb_frequency 	= settings_table.gb_frequency	or self.gb_frequency	-- how often to dump garbage 
		self.maxFrame_skip 	= settings_table.maxFrame_skip  or self.maxFrame_skip	-- max frame skip 

		--// high frequency updater 
		self.interval_H 		= settings_table.interval_H		or self.interval_H 	-- 60 FPS (fixed interval step)
		self.gb_frequency_H 	= settings_table.gb_frequency_H	or self.gb_frequency_H	-- how often to dump garbage 
		self.maxFrame_skip_H 	= settings_table.maxFrame_skip_H  or self.maxFrame_skip_H	-- max frame skip 
		return true 
	else 
		return false 
	end
end 



function Scene:update_(dt)
	--// collect garbage ( free ram ) // not that efficient, keep calls to 350 for 60-fps
	if self.gb_colect >= self.gb_frequency  then 
		collectgarbage()
		self.gb_colect = 0 
	end 
	 	self.accum = self.accum + dt
	 	local skip = self.maxFrame_skip 
		while self.accum >= self.interval and skip > 0 do
		    skip = skip - 1
		    self.accum = self.accum - self.interval
			self.gb_colect  = self.gb_colect +1
			--// hatch_ update 
			for k,v in pairs(self.Scenes) do 
				if v.state == true then 
					v.hatch_:update_()
				end
			end
		end
end


function Scene:HIGHupdate_(dt)
	--// collect garbage ( free ram ) // not that efficient, keep calls to 350 for 60-fps
	 	self.accum_H = self.accum_H + dt
	 	local skip = self.maxFrame_skip_H
		while self.accum_H >= self.interval_H and skip > 0 do
		    skip = skip - 1
		    self.accum_H = self.accum_H - self.interval_H
			print(self.accum_H)
			--// hatch_ update 
			for k,v in pairs(self.Scenes) do 
				if v.state == true then 
					v.hatch_:HIGHupdate_()
				end
			end
		end
end



return Scene








