local Class = require("Core/LIB/Class")    -- get class system
local Emitter = Class:derive("Emitter")  -- create class - emitters 
-----------------------------------------------------------------------------
--[[ Emitters version 3.0 ( initial set up and run down )
-----------------------------------------------------------------------------
The emitter library is designed to emit particles from model vector positions 
as well as from stand alone world positions.

-- version 1:
loads and creates a model at the vertex... 
custom naming of particles 
objects buffer list and tracking of all particles 


version 2.9:
added parameters for the object 
added remove remove into the system
added the objects movement api -- now can call a object push event

version 3 
added grow 
added shrink 
added color arbitration 
added fader 

update 8.0 
small bug fixes 

update 10.0 update:
major rework
persistence maintained by giving the created object an API to control partical functions instead of this EMitter class 
Emitter now is just a caster 
-----------------------------------------------------------------------------
]]
function Emitter:new(object_name,vert_location,cords_,self_,scene,hatch_,movement_)
	
self.self_ 			= self_ 					-- object  ( vertex_points from mod file ) table
self.cords_ 		= cords_					-- object world cords 
self.hatch_ 		= hatch_ 					-- link the hatchery functions, create the new object
self.objects_ 		= {}						-- all emitter objects hatchery references 
self.my_scene 		= scene   					-- the scene name the object exists in 
self.id_numer 		= 0		    				-- unique number to assign to the emitter obj
self.object_name 	= object_name				-- non unique object name 
self.vert_location 	= vert_location 			-- object vertex stack location 

end 






-- creates the object attaches a emitter controller to the object... 
function Emitter:emit_(R)
	-- R = the rotation/angle of the ejection 
	local U_ID = tostring(self.object_name.."_"..self.vert_location.."_"..self.self_.emitter__.object.."_"..self.id_numer)
	if  self.hatch_:model_exists(self.self_.emitter__.object) then
		---------------------------------------
		--/ randomization initial start 
		---------------------------------------
		math.random() math.random() math.random()
		if self.self_.emitter__.speed_min and self.self_.emitter__.speed then
			self.self_.emitter__.speed = math.random(self.self_.emitter__.speed_min,self.self_.emitter__.speed)
		end
		self.id_numer = self.id_numer +1
		-- // randomize rotation 8.0 update 
		local rand_rot = 0
		local R_ = 0
		if self.self_.emitter__.rand_rot == true then
			rand_rot = math.random(0,360)
			R_ = 0
		else
			R_ = self.cords_.R
		end 



		-------------------------------------------------------
		--// create object 
		-------------------------------------------------------
		local obj = self.hatch_.Scenes_:add_object(
			self.my_scene,
			U_ID, 
			self.self_.emitter__.object,

			{	X = self.self_.X,
				Y = self.self_.Y,
				Z = self.self_.Z+.01,
				R = R_ + rand_rot,
				Particle_params = {self.self_.emitter__,self} --// create the particle script for that object 
			}

		)-- insert the object name into our emitter list 


		table.insert(self.objects_,1, 
		{
			U_ID,
			obj_ = obj,
			R= R
		} )


		-- eventually you need to clear the name # cachet 
		if self.id_numer > 500 then 
			self.id_numer = 0
		end  



	--// model does not exist 
	else

			if self.self_.emitter__.speed_min and self.self_.emitter__.speed then
			self.self_.emitter__.speed = math.random(self.self_.emitter__.speed_min,self.self_.emitter__.speed)
			end
			-- // randomize rotation 8.0 update 
			local rand_rot = 0
			local R_ = 0
			if self.self_.emitter__.rand_rot == true then
				rand_rot = math.random(0,360)
				R_ = 0
			else
				R_ = self.cords_.R
			end 
			self.id_numer = self.id_numer+1


			
			--// load model 
			self.hatch_:load(self.self_.emitter__.file_) 
			-------------------------------------------------------
			--// create object 
			-------------------------------------------------------
			local obj = self.hatch_.Scenes_:add_object(
				
				self.my_scene,
				U_ID, 	
				self.self_.emitter__.object,								

				{X = self.self_.X,
				Y = self.self_.Y,
				Z = self.self_.Z-.01,
				R = R_ + rand_rot,
				Particle_params =  {self.self_.emitter__,self} 					--// create the particle script for that object 
				 }							
			)	-- insert the object name into our emitter list 


			--// particle tracking 
			table.insert(self.objects_,1, 
			{
				U_ID,
				obj_ = obj,
				R = R,
			} )

		end
end--//EOF





function Emitter:remove_(name)
	for i = 1, #self.objects_ do 
		if self.objects_[i][1] == name then
			table.remove(self.objects_,i)
			break
		end 
	end 
end --// EOF





-- emitter functionality controller 
function Emitter:update_()
	for i = 1, #self.objects_ do  
		if self.objects_[i] then 
		self.objects_[i].obj_.Movement_:push(
				math.random( -- applying random ejection
				--object rotation + particle objects rotation + the range deviation angle  
				(  self.cords_.R + self.objects_[i].R - self.self_.emitter__.range 	), -- min 
				(  self.cords_.R + self.objects_[i].R + self.self_.emitter__.range 	)  -- max
				),
			self.self_.emitter__.speed,
			math.random(-(self.self_.emitter__.rotation),self.self_.emitter__.rotation) -- rotation 
			)

			
		end
	end 
end

return Emitter

























