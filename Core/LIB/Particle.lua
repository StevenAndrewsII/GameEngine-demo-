local Class = require("Core/LIB/Class")    	-- get class system
local Particle = Class:derive("Particle") 	-- create the class 
--// load required  LIB & classes 

---------------------------------------------------------------
--[[	//	PARTICLE CONTROLLER SCRIPT Version 2   // 

Description and log: 

removed particle controller systems to its own individual script 
the script exists only for the individual particle.

--]]
---------------------------------------------------------------



function Particle:new(start_params_,ref_,self_name,hatch_,scene_T,EMITTER_)


	--// set up reference data 
	self.self_name 			=		self_name		--//	particle 
	self.hatch_ 			=		hatch_			--// 	hatch functions direct ref 
	self.SM_ 				= 		scene_T[1]		--//	scene manager ref and current scene 
	self.Scene_				= 		scene_T[2]
	self.ref_				= 		ref_  			--// 	the actual particle 
	self.E_ 				= 		EMITTER_		--// 	casters emitter call back 

	--// useful control info 
	self.start_params_ 		= 		start_params_ 	--//	passed from casters emitter 

	--// core timers and variables 
	self.timer				=	0 

end --// EOF





function Particle:update_()


			if self.timer < self.start_params_.life then 
			
				self.timer = self.timer + 1




				if 	 self.start_params_.grow then
					self.ref_.world_cords.Z_offset = ( -self.timer/ self.start_params_.life/2 )+1
				end 
				-- shrink on Z axis ( does not affect draw order ) over time
				if 	 self.start_params_.shrink then

					self.ref_.world_cords.Z_offset = (	self.timer/ self.start_params_.life )+1
				end 
				-- fade over time based on life span (need to add a way to pars data to this bank for easy color arbitration)
				if 	 self.start_params_.fade then
					--self.ref_.color_.RED_    = (	-self.objects_[i].timer/ self.start_params_.life 	)+1
					--self.ref_.color_.GREEN_  = (	-self.objects_[i].timer/ self.start_params_.life 	)+1
					--self.ref_.color_.BLUE_   = (	-self.objects_[i].timer/ self.start_params_.life 	)+1
					--print("(	-self.objects_[i].timer/ self.start_params_.life)+1"..self.objects_[i].timer/ self.start_params_.life)
					self.ref_.color_.ALPHA   =   -(self.timer/ self.start_params_.life) +1

				end

				--// later fun functions 
				if type( self.start_params_.blink) == "table" then 
					-- // add color shift 
				end

				if type( self.start_params_.blink) == "table" then  -- blink table with params 
					-- // add color blink 
				end






			elseif  self.timer >= self.start_params_.life then 
				-- remove the objects from the scene manager and emitter list  after the life span is up
				self.E_:remove_(self.self_name)
				local result_ = self.SM_:remove_object(self.Scene_,self.self_name)  
			end 



end --// EOF




--// END OF FILE 
return Particle