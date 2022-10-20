

local Class 			= require("Core/LIB/Class")
local ModelController 	= Class:derive("ModelController") -- create the class 

--[[
------------------------------------------------------------------------------
// controller and AI interface layer for controllable objects 
// Steven Andrews II 9/19/21
------------------------------------------------------------------------------



]]

--// created for each object with a controller bind mapping 
function ModelController:new(hatch_, object_, controller, params_, camera )
	self.hatch_ 		= hatch_		--// hatchery bind 
	self.object_ 		= object_    	--// the object reference data 
	self.controller 	= controller 	--// controller module 
	self.params_ 		= params_ 		--// EZ controller bind table ref 
	self.camera 		= camera		--// unused at the moment 

	-- parameters/ set up construction 
	self.con_blocking = nil						-- blocked controls by other controls 
end


--// Recursion 
--// push trigger to vertex object  ( recursion )
function ModelController:push_trigger(id,state)
	for i = 1, #self.params_.controls do 
		if self.params_.controls[i].id == id then 
			--// push trigger state 
			local rumble_ = self.params_.controls[i].rumble or nil
			self:handler(self.params_.controls[i],state)
		end 
	end 
end -- // eof 



function ModelController:handler(control_table,state)

--// needs to be able to unlock from camera locks 
--// time out to locked back after moving 
--// ease in 
if control_table.zoom_ then 
	if state == true then 
		self.camera:zoom_manual(control_table.zoom_speed)
	end 
end





--// use 










	if type(state) ~= "boolean" then

	--// passed from gun model 
	--// set rumble from controller (rev 3)
	--// add gun mag stop 
		if control_table.rumble then 		
			if control_table.rumble.state <= state then
				self.controller:rumble_on(
						control_table.rumble.max_amt_,    	-- Max rumble val
						control_table.rumble.ramp,			-- ramp up speed
						self.object_ 						-- Z axis orientation from an object 
					)

			else
				self.controller:rumble_off()
			end 
		end 

	--[[ NOTE: 

	Camera shake is broken, but appears correct 
	brakes system hard if player Z is higher than the locked object ( x and y tries to catch up with a ghost )
	-- patched by camera off screen buffer kinda.
	--// add gun mag stop 
	]]
	-- // Camera shake 
		if control_table.camera_rumble then 
			
			if control_table.camera_rumble.state <= state then
				self.camera:shake(control_table.camera_rumble.amount,self.object_.world_cords.Z)
			else
				self.camera:shakeStop()
			end 
		end 

	--// right stick rotation 
	
		local dead_zone = control_table.rotate_deadZone or 0.5 		--// default dead zone
		if state > (  dead_zone  ) and control_table.pos_rotate then
			self.object_.Movement_:rotation(	 (control_table.rotation_amt), control_table.rotate_speed*math.abs(state)^2		)	
			self.object_.Rigging_:movment_intigration("rotation", -(control_table.rotation_amt), control_table.rotate_speed*math.abs(state)^2  ) 

		end
		if state < ( -dead_zone  ) and control_table.neg_rotate then
			self.object_.Movement_:rotation(	-(control_table.rotation_amt), control_table.rotate_speed*math.abs(state)^2 	)
			self.object_.Rigging_:movment_intigration("rotation", (control_table.rotation_amt), control_table.rotate_speed*math.abs(state)^2  ) 
		end

	end  -- // end of not boolean check 

	
	--// firing an attached objects trigger ( control system of weapon linked to character models through tag: " fire " ) 
	if control_table.vertex_trigger then
		-- down a tree stack of attached objects ( EX: A -> B -> C... ) 
		for i = 1, #self.object_.vertex_points do 
			if self.object_.vertex_points[i].point_name == control_table.vertex_trigger and self.object_.vertex_points[i].attached_objects then
			-- search list of attached objects..
			for ii = 1,#self.object_.vertex_points[i].attached_objects do 
				-- if toggled in hand // is active 
				if self.object_.vertex_points[i].attached_objects[ii].enabled == true then								-- all of this is just a state check... wtf redo this bs 	
				-- if the object exists // push the trigger to attached objects (ModelController) 

				local vert_obj = self.hatch_:object_exists(self.object_.vertex_points[i].attached_objects[ii][1],true)
					if vert_obj then 
					if vert_obj.ModelController and vert_obj.world_cords.vis_ then
						-- push trigger to vertex object 
						vert_obj.ModelController:push_trigger(control_table.id,state)
					end
					end  
				end
				
			end 
			--// add emitter call out for bound emitter 
			end
		end
	end -- // EO vertex_trigger





	if control_table.animation_toggle then 

		--// initial animation_toggle construct/ default 
		local AT_ = control_table.animation_toggle
		-- // group sub system ( allows for swaping sets of animations ) )// weapons swapping added 
		if control_table.animation_toggle.group_ then
			AT_ = control_table.animation_toggle.group_[ control_table.animation_toggle.group_.selection ]
		end 


		--// handle the animation binding and movement bound to those animations
		-- // loop through AT_ table in the model 
		for i = 1,#AT_ do



			-- main function 
			local function f_()
			--// controller function 
				local function con_(animate_,move_)

					for ii = 1,#self.object_.body_parts do
					if self.object_.body_parts[ii].reference == AT_[i][1]  then
		

						if animate_ == true then 
						self.object_.body_parts[ii].Animator_:select_animation(
							AT_[i][2],
							AT_[i].animationSetWait_skip or false
						)
						end

						if move_ == true then
						if AT_[i].move then
						AT_[i].move.speed = AT_[i].move.speed 	or 0
						AT_[i].move.R = AT_[i].move.R 			or 0  
							self.object_.Movement_:move( AT_[i].move.speed , AT_[i].move.R )
							--// object movement binding patch ( not a full solution )
							self.object_.Rigging_:movment_intigration("move", AT_[i].move.speed, AT_[i].move.R ) 
						end
						end

					end
					end
				end--// EOF


			--// handle numbers
			if type(state) ~= "boolean" then
				--// tristate  issue 
				--// -1 , 0 , 1 ( x < o < y )

				local pos = false
				local neg = false
				local zeo = false
				local zeo_neg = false
				local zeo_pos = false

				-- positive values above ( AT_[i][3] ) 
				if AT_[i][3] <= state and AT_[i][3] > 0 and AT_[i][3] <= state and AT_[i][3] > 0 then
				pos = true
				else pos = false
				end 

				-- negative values above ( AT_[i][3] ) 
				if AT_[i][3] >= state and AT_[i][3] < 0 and AT_[i][3] >= state and AT_[i][3] < 0 then
				neg = true
				else neg = false
				end 

				--// zero input 
				if AT_[i][3] == state and AT_[i][3] == 0 then
				zeo = true
				else zeo = false
				end 

				--// tristate handle 
				if #AT_ == 3 then 
					if AT_[1][3] < state and state < 0 and pos == false and zeo == false and neg == false then
						zeo_neg = true 
					else
						zeo_neg = false
					end
					if AT_[3][3] > state and state > 0 and pos == false and zeo == false and neg == false then
						zeo_pos = true
					else
						zeo_pos = false
					end
				end


				--// STATE MACHINE

				-- movement / animation tries, doubles, singles 
				if pos == true then 
					con_(true,true)
				end 

				if neg == true then 
					con_(true,true)
				end 

				if zeo == true then 
					con_(true,true)
				end 
				--// tri state 
				if zeo_pos == true and zeo_neg  == false and AT_[i][3] == 0 then 
					con_(true,false)
				end 
				if zeo_neg == true and zeo_pos == false and AT_[i][3] == 0 then 
					con_(true,false)
				end 
			end

			--// boolean value controller 
			if AT_[i][3] == state and type(state) ~= "number" then 
				con_(true,true)
			end
		end 


			--// controller for a wait command 
					if AT_[i].hold_for then 
						--// get the input from that button  or axis 
						local v_ = self.controller:get_RAWinput(
						AT_[i].hold_for[1].con_bind_id,					
						AT_[i].hold_for[1].button_axis,					
						AT_[i].hold_for[1].subtype or nil				
						) 

						if v_ == AT_[i].hold_for.value then 
							f_()
						end 
					else 
						f_()
					end 
	end -- EOF 
	end -- end of sticks 
end --// EOF





---------------------------------------------------------------------------------
--// button / axis read 
---------------------------------------------------------------------------------


--// quick function to block controls if buttons are pressed with a con_block tag 
function ModelController:is_blocked(id,state)
	if self.con_blocking then 
		for i = 1, #self.con_blocking do 
			if self.con_blocking[i][1] == id and self.con_blocking[i][2] == state or self.con_blocking[i][3] == 1 then --or self.con_blocking[i][3] == false then 
				print("blocked: "..id .."  state:  ".. tostring(state))
				return true   --// (blocking controller input)
			else 
				print("no block id: ".. id)
				return false  --// (no block)
			end
		end
	else
		--print("default")
		return false -- // default if no blocking bind (no block)
	end
end

function ModelController:check_buttons()

-- bound on camera lock and if an object has key bindings and is toggles on durring the lock 
	if self.controller.controller_bound__ == self.object_.name then  --< 10 fix this TO_DO

	
		for i = 1, #self.params_.controls do
			--// get the values of a specific button bound in animation 
			local value_ = self.controller:get_RAWinput(
				self.params_.controls[i].con_bind_id,					-- id of button/other ( string )
				self.params_.controls[i].button_axis,					-- button or axis : string 
				self.params_.controls[i].subtype or nil					-- see control table for ref ( string )  ( in control module LIB)
			) -- get_RAWinput(id,type_,subtype)
			--------------------------
			-- button input 
			--------------------------
			 --  button state machine 

				--// check if the button is blocked 
				if self:is_blocked(self.params_.controls[i].con_bind_id,value_) == false then 
					--// pass button value to handler 
					--// see note: HANDLER_ 

					
					self:handler(self.params_.controls[i],value_)
					-- state handler for blocking button presses 
					if self.params_.controls[i].con_block and value_ == true then 
							--// set the blocking table ( list of buttons to block during any key press )
						self.con_blocking = self.params_.controls[i].con_block
					else 	--// take this out 
						self.con_blocking = nil
					end
				end

		
		end
	else
		for i = 1,#self.params_.controls do 
			self:handler(self.params_.controls[i],false)
		end
	end 

end --// EOF


--// 60 fps lock 
function ModelController:update()
	self:check_buttons()	
end


return ModelController



