local Class = require("Core/LIB/Class")							-- load class 
local Sound_Manager = Class:derive("Sound_Manager")							-- get class system
local Events = require("Core/LIB/Events")
-- back end common functions 
local ENGINE_LIB = require("Core/LIB/ENGINE_LIB")
----------------------------------------------------------------------------------------------- VER 1.0
-- when models are loaded, sound date structures are loaded into the sound_ table from the model file data 
-- if the model has an animation and sound on a frame in the animation it will call that sound to be created 
-- when the sound is created into the buffer_ table, 


function Sound_Manager:new(hatch_)
	self.hatch_ = hatch_	-- need hatch_ reference for other module hooking 
	self.sounds_ = {}		-- loaded sounds for this scene 
	self.buffer_ = {}		-- maybe add a sound buffer, for active sounds 
end  -- // EOF ( on creation of hatch_ )



-- clear loaded sound data ( pre buffer )
function Sound_Manager:unload_sound()
end 

-- clear current sound 
function Sound_Manager:clear_buffer()
end 


-- load a sound into sound table 
-- when a model is loaded all sound data is copied to here and formated for use 
function Sound_Manager:load_sound(file_,name_,type_,rst_onstop) 
	if  #self.sounds_ > 0 then
		for i = 1,#self.sounds_ do
			if self.sounds_[i][1][1] == name_ then 
				break -- found 
			end 
			if  self.sounds_[i][1][1] ~= name_ and i >= #self.sounds_  then 
				local typ_ = type_ or "static"				-- default 
				table.insert(self.sounds_ ,1, { 			-- track insertion 
					{name_ ,file_, typ_}, 					-- 1 - data pack ( location and tracking data )
					false,									-- 2 - play trigger 
					false,									-- 3 - playing status 
					rst_onstop or false,					-- 4 - reset the ability to play 
															-- // ADDED AFTER CREATION // --
															-- 5 = sound source 
															-- 6 = volume_mixer
					} )
			end
		end
	else -- first run 
		local typ_ = type_ or "static"				-- default 
		table.insert(self.sounds_ ,1, { 			-- track insertion 
		{name_ ,file_, typ_}, 						-- 1 - data pack ( location and tracking data )
		false,										-- 2 - play trigger 
		false,										-- 3 - playing status 
		rst_onstop or false,						-- 4 - reset the ability to play 
													-- // ADDED AFTER CREATION // --
													-- 5 = sound source 
													-- 6 = volume_mixer
		} )
	end

end -- // EOF


-- creating a sound into the buffer system for playing multi sample audio files 
function Sound_Manager:create_sound(name_,cords_,obj_,bool_play, continue_)
	local cords_ = cords_ or nil
	local obj_ = obj_ or nil

	local vol_mix = 1 	-- default volume

	for i = 1, #self.sounds_ do 
		if self.sounds_[i][1][1] == name_ then 
			local  clone_ = ENGINE_LIB:deep_copy(self.sounds_[i])				-- copy the table data at index i 
			clone_[2] = bool_play or true 										-- auto play ( default true)
			clone_[4] = continue_ or false										-- repeat audio track (default to false)
			clone_[5] = love.audio.newSource(clone_[1][2],"static") 			-- create audio raw
				-- add world filters ( x and y needed )
			if cords_ and obj_ then 
			vol_mix = self:CAMZ_filters(cords_,obj_,clone_[5])
			end

			clone_[6] = vol_mix 
			clone_[7] = { obj_,cords_}												-- volume control based on Z position ( default max )
			--// insert the clone into the buffer_ //
			if #self.buffer_ >0 then 											
			table.insert(self.buffer_,clone_)
			return self.buffer_[#self.buffer_] 									--// return the ref 
			else
			self.buffer_[1] = clone_
			return self.buffer_[1]												--// return the ref
			end
		end 
	end 

end  -- // EOF


-- effect the sounds for in space, close to camera, far away... etc 
-- needs X Y
 function Sound_Manager:CAMZ_filters(cords_,obj_,source_)
 	local t_x =  obj_.translated_x or cords_.X
 	local t_y =  obj_.translated_y or cords_.Y
 	local dist_x,dist_y = math.abs(self.hatch_.Camera.X - t_x),  math.abs(self.hatch_.Camera.Y - t_y)
 	local magnitude_xy  = math.sqrt(	dist_x * dist_x + dist_y * dist_y	)
 	local max_radius = 5500 * (cords_.Z/self.hatch_.Camera.current_zoom)
 	
 	--// add weather plug in 
 	--// fix bugs in vectoring Z issue // add a roll off factor too 
 	local inverted_magnitude = ((math.abs(magnitude_xy)/max_radius)*-1)+1
 	if inverted_magnitude <= 0 then 
 		return 0 --// out of radius 
 		else
 		return ((cords_.Z/self.hatch_.Camera.current_zoom) + inverted_magnitude )/2 *inverted_magnitude*(cords_.Z/self.hatch_.Camera.current_zoom)
 	end 


 end





-- 60 fps updated/ regulated
-- responsible for updating buffer list & playing audio based on trigger command 
function Sound_Manager:update_()
-- update buffer 
	if self.buffer_ then 
		for i = 1, #self.buffer_ do 
			if self.buffer_[i] then 
				-- update sound filters 
				self.buffer_[i][6] = self:CAMZ_filters( self.buffer_[i][7][2] , self.buffer_[i][7][1])
				-- state machine 
				if self.buffer_[i][2] == true and self.buffer_[i][3]==false then 
					self.buffer_[i][5]:setLooping(self.buffer_[i][4]) -- looping 

					
					 self.buffer_[i][5]:setFilter ({ --// remove this and use it for weather and FX ( sound FX module s)
					 	type = 'lowpass',
					 	volume = self.buffer_[i][6] ,
					 	highgain = 1,
					 } )

					 self.buffer_[i][5]:play()
					 self.buffer_[i][3] = true 

				end

				if self.buffer_[i][3] == true and self.buffer_[i][5]:isPlaying() == false and self.buffer_[i][4] == false  then 
				table.remove(self.buffer_,i)
				end 
			end
		end 
	end
end -- // EOF







return Sound_Manager  -- // EO-File



















