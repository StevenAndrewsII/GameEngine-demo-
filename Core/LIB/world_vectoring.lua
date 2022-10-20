local Class = require("Core/LIB/Class")
local Vectoring = Class:derive("Vectoring") -- create the class 
local ENGINE_LIB = require("Core/LIB/ENGINE_LIB")

--[[-----------------------------------------------------------------------------------------
Model vectoring API
---------------------------------------------------------------------------------------------
version 3.0: 

pros:
more functions/ full dedicated api
future proof architecture 
expandable 


con:
(no speed up / slow down benefits)


]]
---------------------------------------------------------------------------------------------




function Vectoring:new(Hatch_,S_D,obj_,name_)
	--// passed down 
	self.Hatch_ 	= Hatch_ 		--// hatch_ bind 
	self.Scenes_M 	= S_D[1]		--// scene manager functions 
	self.Scene 		= S_D[2]		--// current scene string 
	self.obj 		= obj_ 			--// object full ref 			(owner of the rig)
	self.name 		= name_			--// object name 				(owner of the rig)
end 




--// create vertex point
function Vectoring:create_vertex(point_name,radius,rotation,obj_table) 
	--// default the system ( just create the vert table [ no emitter or object ] )
	local O_= nil  
	if type(obj_table) == table then 
		O_ = obj_table
	end

	local setup =  { --// base table setup 
						point_name 			= point_name,				--// id 
						X 					= 0,						--// Cords are Engine oriented
						Y 					= 0,
						Z 					= 0, 
						RAD 				= radius,					--// point around model center 
						ROT 				= rotation,
						attached_objects 	= { O_ or nil }				--// list ( default empty )
					}
	--// Operator 
	if self.obj.vertex_points then 
		for i = 1,#self.obj.vertex_points do 
			if self.obj.vertex_points[i].point_name == point_name then 
				--//ERROR out // Duplicate ( point_name	)
				return false
			end
			if i >= #self.obj.vertex_points then 
				table.insert(
					self.obj.vertex_points,
					setup
				)
				--// no duplicate 
				return true 
			end
		end 
	else
		--// default operator  
		self.obj.vertex_points = { setup }
		return true
	end
end --// EOF


--// remove the entire vertex point 
function Vectoring:remove_vertex(point_name) 
	for i = 1,#self.obj.vertex_points do 
		if self.obj.vertex_points[i].point_name == point_name then 
				table.remove(self.obj.vertex_points,i)
			return true 
		end
		if i >= #self.obj.vertex_points then
			return false 
		end
	end 
end --// EOF



--// updated: bind object 
--// now handles the operation in one take and can handle the errors to process the data provided by using recursion type functions 
--// added 3 functions to handle the data and operate the creation of an object and loading of a model 
function Vectoring:attatch_obj(point_name,object_name,object_type,body_stack_location,file) 
	---print("-------------------------// run // ---------------------------")
-----------------------------------------------------------------------
--// functions for organization and use 
-----------------------------------------------------------------------



--// set the ref data to the attached object ( recursive )
local set_ = function (AO_,index_i,secondary_i) 




--// add AO_ check for a match already inserted 


	--// bind attached object x,y,z,r to vertex point location 
	AO_.world_cords.X  	= self.obj.vertex_points[index_i].X
	AO_.world_cords.Y  	= self.obj.vertex_points[index_i].Y
	AO_.world_cords.R  	= self.obj.world_cords.R
	AO_.world_cords.Z  	= self.obj.world_cords.Z + .01
	AO_.owner_dat		= self.obj 				--// PARENT ref to CHILD

	--// de-convolute the draw with a tag line 
	--// persistent toggle !!!! ( must exist without change through culling, object main table is stable )
	--// adds tag for rendering 
	 self.obj.world_cords.AO_toggle = true 
	
	--// 10,0 integration of rigging to attached objects at vertex point
	if  self.obj.vertex_points[index_i].attached_objects then 

		--// case  OPP
		for i = 1, #self.obj.vertex_points[index_i].attached_objects do 
			--// rigging already exists
			if self.obj.vertex_points[index_i].attached_objects[i][1] == object_name then 
	
					self.obj.vertex_points[index_i].attached_objects[i] = {object_name,object_type,enabled = true,true,file,AO_ = AO_}
						table.insert(
									self.Hatch_.AO_,			-- insert to AO ref table 
									1,
									{	object_name,  			--// attached object
										self.name,				--// owner object
										body_stack_location		--// body stack location 
									}							
					) 
					print("object attached!".. object_name.. " type of attachment = 2: rig exists ")
					return true 
			--// rigging for this object does not exist ( create the rig by inserting a new table set up into the next available spot  )
			elseif self.obj.vertex_points[index_i].attached_objects[i][1] ~= object_name and  1>= #self.obj.vertex_points[index_i].attached_objects then
					
					self.obj.vertex_points[index_i].attached_objects[#self.obj.vertex_points[index_i].attached_objects+1] = {object_name,object_type,enabled = true,true,file,AO_ = AO_}
					table.insert(
									self.Hatch_.AO_,			-- insert to AO ref table 
									1,
									{	object_name,
										self.name,
										body_stack_location
									}							
					) 
					print("object attached!".. object_name.. " type of attachment = 1: rig does not exist, created a attachment rig ")
					return true 
			end 
		end 



	--// DEFAULT OPP
	else 
	self.obj.vertex_points[index_i].attached_objects = {	{object_name,object_type,enabled = true,true,file,AO_ = AO_}	}
	table.insert(
					self.Hatch_.AO_,	-- insert to AO ref table 
					1,
					{	object_name,
						self.name,
						body_stack_location
					}	-- create the draw order object 
	) 
	---print("object attached!")
	print("object attached!".. object_name.. " type of attachment = 0: default - no attachment table ")
	return true 
	end
end -- //EOF




--// operator: checks for existing status of a model/object 
--// state machine operator 
local opp_ = function(i)
	if self.Hatch_:model_exists(object_type) then
		--// get Attached Object --> AO_ reference
		local AO_ = self.Hatch_:object_exists(object_name,true)
		if  AO_ ~= nil then
			return set_(AO_,i)
		else -- // model exists but no object ( create the object )
			self.Scenes_M:add_object( 
				self.Scene,
				object_name,
				object_type,
				{X = 0 ,Y = 0, Z = 202})
			return 
		end
	else 
		-- // error // no model -- > load model 
		---print("model did not exist: push to create model for attachment ")
		--return create_set(i,true,ii)
		self.Hatch_:load(file)
	end 
end
-----------------------------------------------------------------------
--// operator: 

	for i = 1,#self.obj.vertex_points do 
		if self.obj.vertex_points[i].point_name == point_name then 
			if self.obj.vertex_points[i].attached_objects then 

				return opp_(i)
					
			else
				---print("empty vertex attached objects table / first slot force ")
				return opp_(1)--// no table (force into first slot )
			end
		end
	end
end--// EOF (bind_obj)









--// removes the attachment// basically drops the object at its current point.
function Vectoring:remove_obj(point_name,object_name,object_type) 
	for i = 1, #self.obj.vertex_points do
		if  self.obj.vertex_points[i].point_name == point_name then 
			for ii = 1, # self.obj.vertex_points[i].attached_objects do 
				if self.obj.vertex_points[i].attached_objects[ii][1] == object_name and self.obj.vertex_points[i].attached_objects[ii][2] == object_type then
					--// remove ref 
					self.obj.vertex_points[i].attached_objects[ii].AO_.owner_dat = nil
					table.remove( self.obj.vertex_points[i].attached_objects,ii)
					return true 	--// removed authentication 
				else
					return false 	--// invalid object name and type 
				end
			end
		else return false 			--// no point name 
		end 
	end 
end--// EOF



--// change the on state of the object.
function Vectoring:activate_obj(point_name,object) 
end--// EOF
function Vectoring:deactivate_obj(point_name,object) 
end--// EOF
--// emitter vertex 
function Vectoring:create_emitter(point_name,table_) 
end--// EOF
function Vectoring:remove_emitter(point_name) 
end--// EOF






--// attached objects need movement to be applied to them 
function Vectoring:movment_intigration(direction_,A,B) 
	for I= 1, #self.obj.vertex_points do
		if self.obj.vertex_points[I].attached_objects then 
			for II = 1,#self.obj.vertex_points[I].attached_objects do 
				if self.obj.vertex_points[I].attached_objects[II].AO_ then 
				if direction_ == "rotation" then 
					self.obj.vertex_points[I].attached_objects[II].AO_.Movement_:rotation(	A , B 	)
				else -- //  movement 
					self.obj.vertex_points[I].attached_objects[II].AO_.Movement_:move( A , B )
				end
				end
			end
		end
	end
end -- // EOF














--// Vertex Rig update/ 60 fps 
function Vectoring:update() 

	if self.obj.world_cords.R >360 then
			self.obj.world_cords.R = 0
		elseif self.obj.world_cords.R < 0 then 
			self.obj.world_cords.R = 360
	end


	if self.obj.vertex_points then
	for i = 1, #self.obj.vertex_points do 
				-- off set angle 

				self.obj.vertex_points[i].Z  =  self.obj.world_cords.Z
				local angleA = self.obj.world_cords.R + self.obj.vertex_points[i].ROT +90	--+self.Hatch_.Camera.camera_rotation				-- angle at center of triangle
				local angleB = 90												
				local angleC = 180 -90-angleA									
				local vecx,vecy = (self.obj.vertex_points[i].RAD*math.sin(math.rad(angleC))/math.sin(math.rad(angleB))),(self.obj.vertex_points[i].RAD*math.sin(math.rad(angleA))/math.sin(math.rad(angleB))) -- law of sins 		
				self.obj.vertex_points[i].X =  self.obj.world_cords.X - vecx
				self.obj.vertex_points[i].Y =  self.obj.world_cords.Y - vecy
				--// set the cords for attached object  (assuming refrences work like this )
				if self.obj.vertex_points[i].attached_objects then 
					for ii = 1, #self.obj.vertex_points[i].attached_objects do 

						if self.obj.vertex_points[i].attached_objects[ii].AO_ then
							self.obj.vertex_points[i].attached_objects[ii].AO_.world_cords.X  	= self.obj.vertex_points[i].X
							self.obj.vertex_points[i].attached_objects[ii].AO_.world_cords.Y  	= self.obj.vertex_points[i].Y
							self.obj.vertex_points[i].attached_objects[ii].AO_.world_cords.R  	= self.obj.world_cords.R + (self.obj.vertex_points[i].R or 0)
							self.obj.vertex_points[i].attached_objects[ii].AO_.world_cords.Z  	= self.obj.world_cords.Z + .01 

						else
				
							--// Auto attachment 3.0 ( recursion function until an AO_ is set )
							self:attatch_obj(
								self.obj.vertex_points[i].point_name,
								self.obj.vertex_points[i].attached_objects[ii][1],
								self.obj.vertex_points[i].attached_objects[ii][2],
								self.obj.vertex_points[i].attached_objects[ii].stack_insert,
								self.obj.vertex_points[i].attached_objects[ii].file
							) 
							

						end
					end
				end

				--// this current code will auto delete 

				--// handled removing objects if they do not exist and are visible/enabled // idk yet 
				if self.obj.vertex_points[i].AO_ == nil and self.obj.vertex_points[i].enabled == true then 
				--self:remove_obj(self.obj.vertex_points[i].point_name,self.obj.vertex_points[i][1],self.obj.vertex_points[i][2])
				end 

	end
end
end --// EOF




return Vectoring