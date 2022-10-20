local Class = require("Core/LIB/Class")
local Movement = Class:derive("Movement") -- create the class 


--[[-----------------------------------------------------------------------------------------
Movement: world movement controller for objects 
---------------------------------------------------------------------------------------------
update 3.0 
-- advanced movement characteristics for each model can be accessed through the library attached to all models in the game. 

-- added object shake 
-- added push (used by emitter )
-- added sway ( use this for flight models )
-- manual x,y,z manipulation 
-- rotation manipulation 

to do:
	add event bindings for controllers connected to the user interface 
]]
---------------------------------------------------------------------------------------------

function Movement:new(object_,cords_,camera_) 
-- object world cords 

self.object_ 				= object_	-- // get the vertex stuff 
self.cords_ 				= cords_
self.camera_ 				= camera_ -- 8.0 tie in ?
-- push function var list 
self.push_toggle 			= 0 
self.push_angle 			= 0 
self.push_speed 			= 0 
self.push_rotation 			= 0
self.push_duration 			= 0
self.push_acceleration 		= 0 

self.sway_toggle 			= 0 
self.sway_angle 			= 0 
self.sway_speed 			= 0 
self.sway_duration 			= 0 	-- 0 -> skip
self.sway_dampening 		= .5
self.sway_time 				= .1 -- clock 
self.sway_clock_state 		= 0 
self.sway_distance 			= 0 
self.sway_state 			= 0 
self.sway_duration_clock 	= 0 -- clock

self.shake_toggle 			= 0
end






function Movement:sway(angle,speed,distance,dampening,duration)  -- on object axis 90 = side to side 
	if self.sway_toggle == 0 then
	self.sway_angle 			= angle
	self.sway_speed				= speed
	self.sway_dampening 		= dampening
	self.sway_duration 			= duration
	self.sway_distance  		= distance
	self.sway_toggle 			= 1
	end
end




-- manual manipulation  
function Movement:move_X(X_speed) 
self.cords_.X = self.cords_.X + X_speed
end
function Movement:move_Y(Y_speed) 
self.cords_.Y = self.cords_.Y + Y_speed
end
function Movement:move_Z(Z_speed) 
self.cords_.Z = self.cords_.Z + Z_speed
end

function Movement:move(speed,R)
		local R_ = R or 0 
		-----------------------------------------------
		local angleA = self.cords_.R  +90 + R_	 --+ self.camera_.camera_rotation			-- angle at center of triangle
		local angleB = 90												
		local angleC = 180 -90-angleA									

			--local vecx,vecy = ( hype_ * math.sin( math.rad( angleB ) ) / math.sin( math.rad( angleA ) ) ) , ( hype_ * math.sin( math.rad( angleB ) ) / math.sin( math.rad( angleC) ) ) -- law of sins 
		-- apply the translated hypotenuse to the angles, returns translated x and y cord
		local vecx,vecy = (speed*math.sin(math.rad(angleC))/math.sin(math.rad(angleB))),(speed*math.sin(math.rad(angleA))/math.sin(math.rad(angleB))) -- law of sins 		
		-- vector converting (pushes object)
		self.cords_.X =  self.cords_.X - vecx
		self.cords_.Y =  self.cords_.Y - vecy

end


function Movement:shake(amount) 
	if shaself.shake_toggle == 0 then
	self.shake_toggle = 1
	self.shake_amount = amount
	end
end
function Movement:shake_cancle() 
	if shaself.shake_toggle == 1 then
	self.shake_toggle = 0
	end
end





function Movement:rotation(rotation_amount,rotation_speed) 
	
	if (self.cords_.R+rotation_amount) > self.cords_.R then
	self.cords_.R = self.cords_.R + rotation_speed
	end
	if (self.cords_.R+rotation_amount) <= self.cords_.R then
	self.cords_.R = self.cords_.R - rotation_speed
	--self.object_.Rigging:movment_intigration( "rotation",rotation_amount,rotation_speed )
	end

end

-- pushes an object forever in one direction  (used by emitter)
function Movement:push(angle_,speed_,rotation, duration, acceleration )

	local acceleration_		= acceleration or 0 	 -- -1 = decelerate, 0 no change , 1 accelerate / by duration !
	local duration_ 		= duration or 0          -- 0 - forever in one direction 
	local rot_ 				= rotation or 0 		 -- 0 - no rotation speed 

	if self.push_toggle == 0 then
	self.push_speed 		= speed_				-- initial speed of the push 
	self.push_angle 		= angle_				-- angle of the push 
	self.push_rotation 		= rot_					-- rotation speed 
	self.push_duration 		= duration_				-- time 
	self.push_acceleration 	= acceleration_			-- decelerate or accelerate over time 
	self.push_toggle = 1
	end
	if self.push_toggle == 3 then
		self.push_toggle = 0
		return true 
		else return false
	end

end 




-- each calculation is directly applied to object coordinates before camera vector transform 

-- runs at 60 fps locked 
function Movement:update_() 




	if self.shake_toggle == 1 then 
		local hype_ = (1.5) 
		-----------------------------------------------
		local angleA = math.random(1,360)			-- angle at center of triangle
		local angleB = 90												
		local angleC = 180 -90-angleA									

			--local vecx,vecy = ( hype_ * math.sin( math.rad( angleB ) ) / math.sin( math.rad( angleA ) ) ) , ( hype_ * math.sin( math.rad( angleB ) ) / math.sin( math.rad( angleC) ) ) -- law of sins 
		-- apply the translated hypotenuse to the angles, returns translated x and y cord
		local vecx,vecy = (hype_*math.sin(math.rad(angleC))/math.sin(math.rad(angleB))),(hype_*math.sin(math.rad(angleA))/math.sin(math.rad(angleB))) -- law of sins 		
		-- vector converting (pushes object)
		self.cords_.X =  self.cords_.X - vecx
		self.cords_.Y =  self.cords_.Y - vecy
		--print("self.cords_.X "..self.cords_.X )

	end






	if self.sway_toggle == 1 then 
		
		-- clock flip flop
		--// clock driven state machine 
		if self.sway_time <= self.sway_speed and self.sway_clock_state == 0 then 
			self.sway_time = self.sway_time	 + .01
		end
		if self.sway_time >= self.sway_speed and self.sway_clock_state == 0 or self.sway_clock_state == 1 then 
			self.sway_time = self.sway_time	 - .01
			self.sway_clock_state = 1
		end

		if self.sway_clock_state == 1  and self.sway_time <= 0 and self.sway_state == 0 then 
			self.sway_state 		= 1
			self.sway_clock_state 	= 0
			self.sway_time			= 0
		end 
		if self.sway_clock_state == 1  and self.sway_time <= 0 and self.sway_state == 1 then 
			local random_ = math.random(0,360)
			--// if the angle is to sharp of a change 
				if random_> (self.sway_angle -180)-25 and random_< (self.sway_angle +180)+25 then  -- < make constraints a var 
				self.sway_angle = math.random(0,360)
				end
			self.sway_state 		= 0
			self.sway_clock_state 	= 0
			self.sway_time 			= 0
		end 

		


		-- time based sway
		local hype_ = self.sway_distance*(self.sway_time/self.sway_speed)
		local angleA = self.sway_angle  +90					-- angle at center of triangle
		local angleB = 90												
		local angleC = 180 -90-angleA	
		-- apply the translated hypotenuse to the angles, returns translated x and y cord
		local vecx,vecy = (hype_*math.sin(math.rad(angleC))/math.sin(math.rad(angleB))),(hype_*math.sin(math.rad(angleA))/math.sin(math.rad(angleB))) -- law of sins 		
		-- vector converting (pushes object)
		if self.sway_state == 0 then
		self.cords_.X =  self.cords_.X - vecx
		self.cords_.Y =  self.cords_.Y - vecy
		end
		if self.sway_state == 1 then
		self.cords_.X =  self.cords_.X + vecx
		self.cords_.Y =  self.cords_.Y + vecy
		end
	end 





	if self.push_toggle == 1 then
		self.cords_.R = self.cords_.R
		local hype_ = (self.push_speed) 
		-----------------------------------------------
		local angleA = self.push_angle  +90	 --+ self.camera_.camera_rotation			-- angle at center of triangle
		local angleB = 90												
		local angleC = 180 -90-angleA									

			--local vecx,vecy = ( hype_ * math.sin( math.rad( angleB ) ) / math.sin( math.rad( angleA ) ) ) , ( hype_ * math.sin( math.rad( angleB ) ) / math.sin( math.rad( angleC) ) ) -- law of sins 
		-- apply the translated hypotenuse to the angles, returns translated x and y cord
		local vecx,vecy = (hype_*math.sin(math.rad(angleC))/math.sin(math.rad(angleB))),(hype_*math.sin(math.rad(angleA))/math.sin(math.rad(angleB))) -- law of sins 		
		-- vector converting (pushes object)
		self.cords_.X =  self.cords_.X - vecx
		self.cords_.Y =  self.cords_.Y - vecy
		--print("self.cords_.X "..self.cords_.X )
	end







end








return Movement

























