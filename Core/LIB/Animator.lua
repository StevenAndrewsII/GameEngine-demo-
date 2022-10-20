local Class = require("Core/LIB/Class")
local Animator = Class:derive("Animator") -- create the class 
local Events = require("Core/LIB/Events")

--[[-----------------------------------------------------------------------------------------
Animator: revision 3.0
---------------------------------------------------------------------------------------------
Subsystem to handle the back end rendering of animations from models loaded into hatch_

for every objects and its respective components, this lib is attached. 
objects are only animated when in the view of the screen, thus cutting down on draw calling 
and wasted frame rates 

updated: 1.0
* initial concepts integration 
* ran through draw call... ( need fix. 60 fps)
updated: 2.5
* no longer is attached to draw call operator 
* is ran at a constant 60 fps 
* no longer returns anything, grabs the table from the above class
//notes:
is attached to objects body parts
update 3.0:
* added x and y offset to the animation frame matrix
update 4.0
* added emitters to vertex locations 
* call emitters linked to vertex locations through animations binding (working so far...)
]]
---------------------------------------------------------------------------------------------

function Animator:new(self_,emit_,obj_,SM_) 
self.Events_ = Events() 				-- added event binding 8.0 
self.Events_:add("state") 				-- add event: state = the runtime state for the length of an animations

self.self_ = self_ 						-- body part data 
self.object_ = obj_ 					-- the entire object ref 
self.SM_ = SM_							-- sound hook
self.frame = 1							-- current frame 
self.counter = 1						-- timer
self.rt = {1,0,0}						-- returns the frame data to the front side render in the hatchery. (updated in 2.1 and 7.0-8.0)
self.obj_vertexEmitter = emit_	or nil	-- list of vertex points with emitters connected to object... 
self.counter_time = 0 					-- counter time length based on matrix length/speed 


-- demo of color arbiter 8.0 working 
self.colorarbitor_frame = 0
-- sound for models binding 8.0 working 
self.looping_sound = nil
self.looping_animation = nil 

-- 8.0 update // allows for the completion of an animation set before a change in animation can be preformed 
self.selected_animation = nil
self.ended_set = false
self.state = false
-- 



end


-- call back to parents // working 8.0
function Animator:color_flip(tab,i)
 local i = i or 1
-- print("frame"..self.frame)
 self.colorarbitor_frame = self.frame
-- print("assignment"..self.colorarbitor_frame)
 self.rt[4] = {tab[1],tab[2],tab[3],tab[4]}
end





--// 8.0 update 
-- hook functions/events to the end of animation set 
function Animator:state_eventClear()
	self.Events_:clear("state")
end
function Animator:state_event(clear_,...)
	if clear_ == true  then 
	self.Events_:clear("state")
	end
	-- function callback hooking of list 
	local func_list = {...}
	-- added event clearing link to invoke so it clears on end 
	for i = 1, #func_list do 
		if func_list[i] then 
			self.Events_:hook("state", func_list[i])
		end 
	end
end


-- // select animation return information for event bind 
function Animator:select_animation(selected,skip)
	skip_ = skip or false
	if skip_ == true then
		self.self_.animation_set.selected_animation = selected  
		self.selected_animation = self.self_.animation_set.selected_animation
	else
		self.self_.animation_set.selected_animation = selected 
	end
end--// EOF




local old_frame = 0
function Animator:Animate_() -- push down selected_animation

	--// 8.0 handle nil case 
	if self.selected_animation == nil and (self.self_.animation_set)then 
		self.selected_animation = self.self_.animation_set.selected_animation
	end
	
	--// main loop body 
	if (self.self_.animation_set) and self.self_.animation_set[self.selected_animation] then
	--// increment timers and counters  
	--// counter time == number of frames/ speed of animation 
	self.counter_time = #self.self_.animation_set[self.selected_animation].matrix/ self.self_.animation_set[self.selected_animation].speed  + love.timer.getDelta( )
	self.counter = self.counter+self.self_.animation_set[self.selected_animation].speed + love.timer.getDelta( )
		

		--// at the end of the counter 
		if self.counter>= self.counter_time and self.frame < #self.self_.animation_set[self.selected_animation].matrix then
		--// state release 
		self.ended_set = false










		local offset_ = self.self_.animation_set[self.selected_animation].matrix[self.frame].random_spawn or 0
		--// front side render push 
		self.rt[2]  = self.self_.animation_set[self.selected_animation].matrix[self.frame][2] + math.random(-offset_,offset_)	-- x off set + randomized
		self.rt[3]  = self.self_.animation_set[self.selected_animation].matrix[self.frame][3] + math.random(-offset_,offset_)	-- y off set + randomized
		-- in frame color swap
		self.rt[4]  = (self.self_.animation_set[self.selected_animation].matrix[self.frame].arbitration or nil	)				-- color parsing 

		
		-------------------------------------------------------
		-- 8.0 update // plug-ins 
		-------------------------------------------------------
		--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		-- color arbitration // test 
		if self.object_.owner_dat and self.self_.animation_set[self.selected_animation].matrix[self.frame].arbitration then 
			-- add color arbiter 
			for i = 1,#self.object_.owner_dat.body_parts do 
				self.object_.owner_dat.body_parts[i].Animator_:color_flip(self.self_.animation_set[self.selected_animation].matrix[self.frame].arbitration,i)
			end
		end
		
        -- sound system hook // working unit (demo)
        if self.self_.animation_set[self.selected_animation].matrix[self.frame].sound_ then 
        	local O_ = self.self_.animation_set[self.selected_animation].matrix[self.frame].sound_ 
       		self.SM_:create_sound( self.object_.sound[ O_[1] ][2] ,self.object_.world_cords, self.object_, true)
        end 

        -- constant playing of a track while the animation set is selected.... 
      	 if self.looping_sound == nil then 
        	if self.self_.animation_set[self.selected_animation].sound then 
        	local O_ = self.self_.animation_set[self.selected_animation].sound
        	self.looping_sound =  self.SM_:create_sound( self.object_.sound[ O_[1] ][2] ,self.object_.world_cords, self.object_, true, true)	
        else
        	 self.looping_sound = nil -- off state // note maybe add a fade out here somewhere ?? 
       	 	end 
        end 

        --// [pre 8.0 update -- must change based on renderer 2.0]
		-- call the objects vertex emitter... 
		if self.self_.animation_set[self.selected_animation].matrix[self.frame][4] then 
			if self.obj_vertexEmitter then 
				for i = 1,#self.obj_vertexEmitter do
					if  self.obj_vertexEmitter[i].point_name == self.self_.animation_set[self.selected_animation].matrix[self.frame][4] then
					-- call the emitter attached..
					

					self.obj_vertexEmitter[i].Emitter_:emit_(self.obj_vertexEmitter[i].ROT+self.obj_vertexEmitter[i].emitter__.angle) --// added offset 
					end 
				end
			end
		end
		--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



		--//state machine 
		----------------------------
		-- advance frame forward
		--// track old frame 
		old_frame = self.frame

		self.frame  = self.frame+1
		--// state reset  
		self.counter = 0 
		----------------------------
		end
		--// End of the animation set 
		if self.frame  >= #self.self_.animation_set[self.selected_animation].matrix and self.counter >= self.counter_time then 
			self.frame =1
			self.rt[4] = nil
			self.state = false
			--// 8.0 (end of animation set event call) // broken 
			--self.Events_:invoke("state")
			--// 8.0 - added a toggle to mark state position and changes 
			self.ended_set = true
			--// 8.0 - animation selection from model controller system 
			self.selected_animation = self.self_.animation_set.selected_animation
		end



			



			
			
			------------------------------------------------------------------------------------------------------------------------
			--// Random frame plug in 
			------------------------------------------------------------------------------------------------------------------------
			if self.self_.animation_set[self.selected_animation].matrix[self.frame] and self.self_.animation_set[self.selected_animation].matrix[self.frame].random_frame then 
			--// if frame has advanced 
			--// random chance 50/50
				if math.random(1,2) < 2 then 
					--// random frame insertion 
					if self.self_.animation_set[self.selected_animation].matrix[self.self_.animation_set[self.selected_animation].matrix[self.frame].random_frame]  == nil then 
				--	self.rt[1] = 1
					elseif self.state == false then
					self.rt[1] = self.self_.animation_set[self.selected_animation].matrix[self.self_.animation_set[self.selected_animation].matrix[self.frame].random_frame][1]
					self.state = true
					end
				else
					--// normal frame 
					self.rt[1] = self.self_.animation_set[self.selected_animation].matrix[self.frame][1] 
					self.state = true
				end
			else
				if self.self_.animation_set[self.selected_animation].matrix[self.frame]  == nil then 
					self.rt[1] = 1
				else
					--// default state 
					self.rt[1] = self.self_.animation_set[self.selected_animation].matrix[self.frame][1] 
					self.state = true
				end 
				
			end
			

			------------------------------------------------------------------------------------------------------------------------
			--// 2.5D axis rotation 
			------------------------------------------------------------------------------------------------------------------------

			if  self.self_.animation_set[self.selected_animation].free_rotate then 
			
				local clock_x 		= self.self_.animation_set[self.selected_animation].free_rotate.clock_x or 1
				local counter_x 	= self.self_.animation_set[self.selected_animation].free_rotate.counter_x or 1
				local speed_x		= self.self_.animation_set[self.selected_animation].free_rotate.speed_x or 0 

				local clock_y 		= self.self_.animation_set[self.selected_animation].free_rotate.clock_y or 1
				local counter_y 	= self.self_.animation_set[self.selected_animation].free_rotate.counter_y or 1
				local speed_y		= self.self_.animation_set[self.selected_animation].free_rotate.speed_y or 0 
				

				-----------------
				--// Y Axis flip
				-----------------
				if (counter_x == 0 and clock_x < 1.2 )  then 
					if clock_x >= 1 then 
						counter_x = 1
					else
						self.self_.animation_set[self.selected_animation].free_rotate.clock_x = clock_x + speed_x
					end
				end 
				if counter_x == 1 and clock_x > -1.2 then 	
					if clock_x <= -1 then 
						counter_x = 0
					else
						self.self_.animation_set[self.selected_animation].free_rotate.clock_x = clock_x - speed_x
					end	
				end 
				self.self_.animation_set[self.selected_animation].free_rotate.counter_x =  counter_x
				-----------------
				--// Y Axis flip
				-----------------
				if (counter_y == 0 and clock_y < 1.2 )  then 
					if clock_y >= 1 then 
						counter_y = 1
					else
						self.self_.animation_set[self.selected_animation].free_rotate.clock_y = clock_y + speed_y
					end
				end 
				if counter_y == 1 and clock_y > -1.2 then 	
					if clock_y <= -1 then 
						counter_y = 0
					else
						self.self_.animation_set[self.selected_animation].free_rotate.clock_y = clock_y - speed_y
					end	
				end 
				self.self_.animation_set[self.selected_animation].free_rotate.counter_y =  counter_y
				-------------------------------------------------------------------------------------------------------------------
				--// render push 
				self.rt[5] = (1/clock_x)
				self.rt[6] = (1/clock_y)
			end 
			------------------------------------------------------------------------------------------------------------------------






	
		--// Nil bug issue patch
		if self.self_.animation_set[self.selected_animation].matrix[self.frame] == nil then
		self.frame = 1
		end
	end --//EO


	--// static image model 
	if (self.self_.animation_set) == nil or self.self_.animation_set[self.selected_animation] == nil then
		self.rt[1] = self.self_.frame
		self.state = false
		self.rt[4] = nil
	end
end--EOF



return Animator