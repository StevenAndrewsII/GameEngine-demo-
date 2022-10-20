local Class = require("Core/LIB/Class")							-- load class 
local Camera = Class:derive("Camera")							-- get class system
local Events = require("Core/LIB/Events")
-----------------------------------------------------------------------------------
--[[ Camera: revision 5.0
-----------------------------------------------------------------------------------
*Camera translates world vector positions used in game calculations to a drawable 
state by translating the vectors for zoom. 

*Zoom is not a real vectoring dynamic and does not affect game play,
this system is designed to be a sub system of the hatch rendering method

]]
-----------------------------------------------------------------------------------

function Camera:new()

	-- created for usege of cut scenes with custom lua file interface  (see 8.0 update to do list )
	-- event module hook up 
	self.Events_ = Events() --create camera events 
	-- add camera move event 
	self.Events_:add("move")   -- create event type
	-- add zoom event  
	self.Events_:add("zoom") -- create event type
	-- add event 
	self.Events_:add("lock")   -- create event type
	 -- add event 
	self.Events_:add("orbit")   -- create event type ( under development )
	self.Events_:add("snap")   -- create event type

	-- normal starting zoom settings by default
	self.settings = {	
	zoom_reference		=	2500,			-- wold height 
	zoom_limit			=	0,		 		-- world limit 								 
	zoom_speed			=	8,				-- speed of zoom default 
	shake_amount 		= 	0,				-- default screen shake 
	}


	-- zooming arguments 
	self.current_zoom 		= 1500			--// current camera Z height 
	self.zoom_ 				= 200 			--// target location to zoom too ( used in auto zoom )
	self.zoom_toggle 		= 0				--// auto zoom 

	--// testing leave alone 
	self.camera_offset 		= 2				--// camera rendering. 2 is 2x times scaling 
	self.camera_rotation 	= 45			--// testing only ( broken and depreciated )




	-- camera center 
	self.X = love.graphics.getWidth( )/2 	-- never change this 
	self.Y = love.graphics.getHeight( )/2	-- never change this 
		


	

	-- passed on creation from super
	self.hatch_ = nil 



	--// 8.0 lock target object 
	self.lock_toggle = 0
	self.lock_object_ref = nil 

	--// Z locking bool
	self.Z_lock = false 
	

	--// 8.0
	self.follow_toggle = 0
	-- self.follow_object_ref = nil 		// depreciated //  ( lock_object_ref is just used istead )
	self.follow_x = 0 
	self.follow_y = 0
	self.follow_target_x = 0 
	self.follow_target_y = 0
	self.follow_speed = 10
	self.follow_deadzone = 80 

	--// 8.0
	self.shake_toggle = 0 
	self.shake_amount = nil
	self.shake_x = 0
	self.shake_y = 0
	self.shake_z = 0

	--// 8.0 
	self.move_x = 0 
	self.move_y = 0 

end

---------------------------------------------
--[[ camera_translation (Back end)
---------------------------------------------
Version 3.8:
Working camera vector translation method.

* now triangulates vectors and translates
 them to their new coordinates
* camera movement and effects now work  

adding camera rotation... issue ( translation does not work )

-- rotation vector translation must be done first  ( not working )
-- vector for Z 
-- return camera translation 
-- fixed camera shake 

-- back end update issues... : camera rotation needs to only affect the end result of the draw. not 2D cords  
]]
---------------------------------------------
---------------------------------------------

function Camera:rotation(X,Y,hype_,A)-- XY & hype_ are pre_translated for zoom, R = camera rotation is input to vector around the point 
	
	
	local hype_rescale 			= ( hype_ )	

	local angleA =  self.camera_rotation 				-- angle at center of triangle (r)
	local angleB = 90												
	local angleC = 180 -90-angleA									
	-- apply the translated hypotenuse to the angles, returns translated x and y cord
	local vecx,vecy = (hype_rescale*math.sin(math.rad(angleA))/math.sin(math.rad(angleB))),(hype_rescale*math.sin(math.rad(angleC))/math.sin(math.rad(angleB))) -- law of sins 		

	if X > self.X  then
		rot_trans_X 			=  ( self.X + vecx )  
	else
		rot_trans_X 			=  ( self.X - vecx )	
	end
	if Y > self.Y  then
		rot_trans_Y 			=  ( self.Y + vecy )	
	else
		rot_trans_Y 			=  ( self.Y - vecy ) 	
	end
	print("rot_trans_X"..rot_trans_X)
	return rot_trans_X,rot_trans_Y -- returns the translated x and y for rotation around camera center vector... 
end




function Camera:camera_vectoring(X,Y,Z,k) -- object x,y world positions  -- Z = object Z -- R = camera world rotation 
	-- Z axis set up and initial start conditions 

	local Z_    				= Z 
	
	--// offset 8.0 update 
	local X 					= X -self.move_x - self.follow_x - self.shake_x 
	local Y 					= Y -self.move_y - self.follow_y - self.shake_y


	-- get distances
	local distx,disty 			= math.abs( (self.X - X) ) , math.abs( (self.Y - Y )	)
	-----------------------------------------------------------
	-- handle the 0 issue, 0 throws positions into hell LOL 
	-----------------------------------------------------------
	if distx == 0 then
		distx = .001
	end	
	if disty == 0 then
		disty = .001
	end	


	------------------------------------------------------------------------------------
	-- calculate the camera zoom, get the hypotenuse, apply zoom scale to hypotenuse
	------------------------------------------------------------------------------------
	local hyp 					= math.sqrt(	distx * distx + disty * disty	)
	local object_Z_converted 	= Z_ / self.settings.zoom_reference
	local Camera_Zconverted 	= ( self.current_zoom ) / ( self.settings.zoom_reference )


    local wrld_Z 				= ( ( object_Z_converted/self.camera_offset) / Camera_Zconverted )

    --( ( object_Z_converted / Camera_Zconverted - object_Z_converted  ) ) / self.camera_offset-- working 2 == stand off 
	local hype_rescale 			= ( hyp * wrld_Z )							
	----------------------------
	-- calculate translate 
	----------------------------
	local angleA 				= math.deg( math.acos( disty / hyp )  )  				-- angle at center of triangle
	local angleB 				= 90												-- right angle triangle, always has 1, 90
	local angleC 				= 180 - 90 - angleA									-- missing side (y/hyp_)
	-- apply the translated hypotenuse to the angles.
	local vecx,vecy = ( hype_rescale * math.sin( math.rad( angleA ) ) / math.sin( math.rad( angleB ) ) ) , ( hype_rescale * math.sin( math.rad( angleC ) ) / math.sin( math.rad( angleB ) ) ) -- law of sins 
	
	-- out data set up
	local translation_x 		= 0
	local translation_y 		= 0
	-- apply translation against real position and camera position, vectors around camera focal.
	if X > self.X  then
		translation_x 			=  ( self.X + vecx ) 
	else
		translation_x 			=  ( self.X - vecx )	
	end
	if Y > self.Y  then
		translation_y 			=  ( self.Y + vecy )	
	else
		translation_y 			=  ( self.Y - vecy ) 	
	end
	-- return fully translated x and y positions and world zoom for scaling in draw 
	
	return translation_x , translation_y , wrld_Z 


end
------------------------------------------------------------------------------------------------------------





function Camera:zoom(Z)
	if self.zoom_toggle == 0 then
		self.zoom_ = Z or self.zoom_
		self.zoom_toggle = 1
	end
	if self.zoom_toggle == 2 then
		self.zoom_toggle = 0
		return true 
	else
		return false
	end
end -- EOF







function Camera:zoom_manual(speed_)
	if self.lock_object_ref then 
		if self.settings.zoom_reference >= self.current_zoom and self.lock_object_ref.world_cords.Z <= self.current_zoom  then
			self.current_zoom = self.current_zoom-speed_
		end
		if self.lock_object_ref.world_cords.Z  >= self.current_zoom then
		self.current_zoom  = self.lock_object_ref.world_cords.Z+11 
		end 
	else -- // default opp if there is no object locked ( should not happen )
		if self.settings.zoom_reference >= self.current_zoom and self.zoom_limit <= self.current_zoom  then
			self.current_zoom = self.current_zoom-speed_
		end
		if self.zoom_limit >= self.current_zoom then
		self.current_zoom  = self.zoom_limit +1
		end 
	end
end  -- EOF 







---------------------------------------------------------------------
--[[ move camera: version 8 ]]
---------------------------------------------------------------------


-- update the settings of the camera 
function Camera:settings(params) 
	if type(params) == "table" then 
		for k,v in pairs(params) do
			self.settings[k] = v
		end
	end
end
--// update 8.0 
function Camera:unlock()
	if self.lock_toggle ~= 0  then
	self.lock_object_ref = nil
	self.lock_toggle = 0
	self.Z_lock = false
		return true 
	else 
		return false 
	end
end


--// update 8.0 
function Camera:lockon( O_,Z_lock_bool )
	-- clear previous events from system event list 

	if Z_lock_bool == false and Z_lock_bool ~= nil then 
	self.Z_lock =  false 
	else
	self.Z_lock =  true
	end 


	if self.lock_toggle == 0 then 
	self.lock_object_ref = O_ 
	self.lock_toggle = 1
		return true 
	else 
		return false
	end

end
--// update 8.0 
function Camera:follow( O_,Z_lock_bool )
	if Z_lock_bool == false and Z_lock_bool ~= nil then 
	self.Z_lock =  false 
	else
	self.Z_lock =  true
	end 
	if self.follow_toggle == 0 then 
		self.lock_object_ref = O_
		self.follow_toggle = 1
		return true 
	else 
		return false
	end 
end

function Camera:followStop(  )
	if self.follow_toggle == 1 then 
		self.lock_object_ref = nil
		self.follow_toggle = 0
		return true 
	else 
		return false
	end 
end
--// update 8.0
--// camera shake (at Z_ of bound obj)
function Camera:shake(shake_amount,Z_)
	if self.shake_toggle == 0 then 
	self.shake_amount = shake_amount or nil
	self.shake_z = Z_ or 0
	self.shake_toggle = 1
		return true 
	else 
		return false
	end
end

function Camera:shakeStop()
	if self.shake_toggle == 1 then 
	self.shake_x = 0 
	self.shake_y = 0 
	self.shake_z = 0 
	self.shake_toggle = 0
		return true 
	else 
		return false
	end
end







function Camera:update_()
	-- keep screen center X and Y updated ( WINDOW RESIZING 8.0 )
	self.X = love.graphics.getWidth( )/2 	
	self.Y = love.graphics.getHeight( )/2	




	if self.settings.zoom_reference < self.current_zoom  then 
		self.current_zoom = self.settings.zoom_reference
	end 

	if self.settings.zoom_limit > self.current_zoom  then 
		self.current_zoom = self.settings.zoom_limit +1
	end 







	if self.shake_toggle == 1 then 
		local shake_ = self.shake_amount or self.settings.shake_amount
		local Camera_Z	= ( self.current_zoom ) / ( self.settings.zoom_reference )
   		
		self.shake_x =  math.random(-shake_,shake_)*(self.shake_z /self.settings.zoom_reference)--*((self.shake_z /self.settings.zoom_reference)--/Camera_Z - (self.shake_z /self.settings.zoom_reference)) / self.camera_offset
		self.shake_y = 	math.random(-shake_,shake_)*(self.shake_z /self.settings.zoom_reference)--*((self.shake_z /self.settings.zoom_reference)--/Camera_Z - (self.shake_z /self.settings.zoom_reference)) / self.camera_offset
	else
		self.shake_x = 0
		self.shake_y = 0
	end

	

	

	--// camera lock
	if self.lock_toggle == 1 and self.lock_object_ref and self.follow_toggle == 0  then 
		if self.lock_object_ref.translated_x and self.lock_object_ref.translated_y then 
		self.move_x = (self.lock_object_ref.world_cords.X - self.lock_object_ref.translated_x)
		self.move_y = (self.lock_object_ref.world_cords.Y - self.lock_object_ref.translated_y)
			--// debug 
			--print(self.move_x,self.move_y)
			if self.Z_lock then 
				self.current_zoom = self.lock_object_ref.world_cords.Z --// add additional offset option 
			end
		end
	end 

	--// follow ( update 8.0 )
	if self.follow_toggle == 1 and  (self.lock_object_ref) and self.lock_toggle == 0 then 
		if self.lock_object_ref.translated_x and self.lock_object_ref.translated_y then 

			--// 	Z axis factored X and Y distance 
			--// (  real vectors and translated vectors  )
			self.follow_target_x = (self.lock_object_ref.world_cords.X - self.lock_object_ref.translated_x)
			self.follow_target_y = (self.lock_object_ref.world_cords.Y - self.lock_object_ref.translated_y)
		
			--// X axis
			if self.follow_x < self.follow_target_x - self.follow_speed -self.follow_deadzone and self.follow_x < self.follow_target_x + self.follow_speed +self.follow_deadzone then
				self.follow_x 		= self.follow_x + self.follow_speed 
			end 
			if self.follow_x > self.follow_target_x + self.follow_speed +self.follow_deadzone and self.follow_x > self.follow_target_x - self.follow_speed -self.follow_deadzone then
				self.follow_x 		= self.follow_x - self.follow_speed 
			end
			--// Y axis
			if self.follow_y < self.follow_target_y - self.follow_speed -self.follow_deadzone and self.follow_y < self.follow_target_y + self.follow_speed +self.follow_deadzone then
				self.follow_y 		= self.follow_y + self.follow_speed 
			end 
			if self.follow_y > self.follow_target_y + self.follow_speed +self.follow_deadzone and  self.follow_y > self.follow_target_y - self.follow_speed -self.follow_deadzone then
				self.follow_y 		= self.follow_y - self.follow_speed 
			end
			if self.Z_lock then 
				self.current_zoom = self.lock_object_ref.world_cords.Z --// add additional offset option 
			end

		end
	end 


 	--// auto zoom controlling  (  update 1.5  )
	if self.settings.zoom_reference >= self.current_zoom and self.settings.zoom_limit <= self.current_zoom  then
		
		if self.zoom_toggle == 1 then 
			if self.current_zoom < self.zoom_ then
				self.current_zoom = self.current_zoom+self.settings.zoom_speed
				else
				self.current_zoom = self.current_zoom-self.settings.zoom_speed
			end 
			-- orientation and state flop 
			if self.current_zoom <= self.zoom_ + self.settings.zoom_speed and
			   self.current_zoom >= self.zoom_ - self.settings.zoom_speed then
			   self.zoom_toggle = 2
			end
		end
	end

end --// EOF (update_)




return Camera