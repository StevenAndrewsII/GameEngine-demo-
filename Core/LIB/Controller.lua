local Class = require("Core/LIB/Class")
local Controller = Class:derive("Controller") -- create the class 



function Controller:new()
-- params 

self.controllers_ = love.joystick.getJoysticks( ) 		-- on boot up start grabbing joy stick data  
self.controller_selected = nil 							-- the selected controller source ref
self.controller_connection = false 						-- state of connection 
self.selected_controller_data = {} 						-- table for all data collected about controller. 
self.controller_boundto = nil

self.time_out_state = 0
self.time_out_clock = 0

self.controller_params = {
	dead_zone 		= .5,				-- stick dead zone 
	refresh_rate 		= 1000,				-- time out state ( in seconds )

	rumble_toggle 	= 0,
	rumble_AmtCap 	= 0.15,
	rumble_ramp 	= 0.001,
	rumble_value 	= 0,

	-- maybe add hooking to other components of the engine 
} 



-- add error system hook 


-- a full map of all buttons and re_bindings... 
self.virtual_pad = {

	button = { -- type
	a = 				{ assignment = "a"  ,				state = false	 	},
	x = 				{ assignment = "x"  ,				state = false		},
	b = 				{ assignment = "b"  ,				state = false		},
	y = 				{ assignment = "y"  ,				state = false		},
	back = 				{assignment = "back",				state = false		},
	start = 			{assignment = "start",				state = false		},
	guide = 			{assignment = "guide",				state = false		},
	leftstick = 		{assignment = "leftstick",			state = false		},
	rightstick = 		{assignment = "rightstick",			state = false		},
	leftshoulder = 		{assignment = "leftshoulder",		state = false		},
	--rightshoulder = 	{assignment = "rightshoulder",		state = false		},
	dpup =				{assignment = "dpup",				state = false		},
	dpdown = 			{assignment = "dpdown",				state = false		},
	dpleft = 			{assignment = "dpleft",				state = false		},
	dpright = 			{assignment = "dpright",			state = false		},
	}, -- // EO buttons



	axis = { --// axis port 


	left_ = { -- left stick 
	leftx 			= {assignment = "leftx",			value = 0		},
	lefty 			= {assignment = "lefty",			value = 0		},
	},

	right_ = { -- right stick 
	rightx 			= {assignment = "rightx",			value = 0		},
	righty 			= {assignment = "righty",			value = 0		},
	},


	trigger_ = { -- trigger group 
	triggerleft 	= {assignment = "triggerleft",		value = 0		},
	triggerright 	= {assignment = "triggerright",		value = 0		},
	},

	}, 	--// 	EO axis port
} 		--//	EOT - buttons 
end 	--// 	EOF - Lib creation 



function Controller:rumble_on(amt_cap,ramp_,O_)

	if self.selected_controller_data.isVibrationSupported and self.controller_params.rumble_toggle == 0 then
		self.controller_params.rumble_AmtCap 	= amt_cap 	or self.controller_params.rumble_AmtCap 	-- // default states 
		self.controller_params.rumble_ramp 		= ramp_ 	or self.controller_params.rumble_ramp 
		self.controller_params.rumble_value 	= 0					-- // reset
		self.controller_params.rumble_toggle 	= 1					-- // state machine
		love.system.vibrate(1,1)
		self.rumble_object = O_ or nil 								-- // Z-axis rumble support
	end
end --// EOF


function Controller:rumble_off()
	if self.controller_params.rumble_toggle  ~= 0 then
		self.controller_params.rumble_toggle 	= 0
		self.controller_params.rumble_value 	= 0
		love.system.vibrate(0,0)
		self.rumble_object = nil
	end
end --// EOF

-- get the inputs of a specific button or trigger group 
function Controller:get_RAWinput(id,type_,subtype)
	if type_ == "button" then 
		return self.virtual_pad[type_][id].state -- return its value ( buttons return)
	end
	if type_ == "axis" and subtype ~= nil then 
		return self.virtual_pad[type_][subtype][id].value -- return its value ( buttons return)
	end
end -- EO 

-- controller selection / removal 

function Controller:select_controller(index)
	if index then 
	if index <= #self.controllers_ then
	self.controller_selected 						= self.controllers_[index] -- controller source binding 
			-- set controller params and collect data 
	self.selected_controller_data.isGamepad 			= self.controller_selected:isGamepad( )
	self.selected_controller_data.getButtonCount 		= self.controller_selected:getButtonCount( )
	self.selected_controller_data.getAxisCount 			= self.controller_selected:getAxisCount( )
	self.selected_controller_data.getDeviceInfo 		= self.controller_selected:getDeviceInfo( )
	self.selected_controller_data.getHatCount 			= self.controller_selected:getHatCount( )
	self.selected_controller_data.getID 				= self.controller_selected:getID()
	self.selected_controller_data.getName 				= self.controller_selected:getName( )
	self.selected_controller_data.isVibrationSupported 	= self.controller_selected:isVibrationSupported()
	self.time_out_state = 0
	end
else 
		if self.controllers_[1] then 
	self.controller_selected 						= self.controllers_[1] -- controller source binding 
			-- set controller params and collect data 
	self.selected_controller_data.isGamepad 			= self.controller_selected:isGamepad( )
	self.selected_controller_data.getButtonCount 		= self.controller_selected:getButtonCount( )
	self.selected_controller_data.getAxisCount 			= self.controller_selected:getAxisCount( )
	self.selected_controller_data.getDeviceInfo 		= self.controller_selected:getDeviceInfo( )
	self.selected_controller_data.getHatCount 			= self.controller_selected:getHatCount( )
	self.selected_controller_data.getID 				= self.controller_selected:getID()
	self.selected_controller_data.getName 				= self.controller_selected:getName( )
	self.selected_controller_data.isVibrationSupported 	= self.controller_selected:isVibrationSupported()
	self.time_out_state = 0
		end 

	end 

end

function Controller:deselect_controller()
	if self.controller_selected then 
	self.controller_selected = nil 
	return true 
	end 
end 

function Controller:remove_controller(index)
	if index then 
	table.remove(self.controllers_,index)
	return true 
	end 
end
-- remapping functions 
function Controller:button_remap(button,new_assignment)
	self.virtual_pad.button[button].assignment 	= new_assignment
	return true 
end 
function Controller:axis_remap(axi,id,new_assignment)
	self.virtual_pad.axis[axi][id].assignment 	= new_assignment
	return true 
end 



-- get raw data from controller and chnge
function Controller:operator_()

-----------------------------------------------------------
--// Controller data read and storage/value pump 
-----------------------------------------------------------
	if self.controller_connection == true then 				-- check for connectivity before read. 
		if self.selected_controller_data.isGamepad  then  	-- use game pad binding controls 
			
			for k,v in pairs (self.virtual_pad.button) do 
				self.virtual_pad.button[k].state = self.controller_selected:isGamepadDown(self.virtual_pad.button[k].assignment )
			end
			for k,v in pairs (self.virtual_pad.axis.trigger_) do 
				self.virtual_pad.axis.trigger_[k].value = self.controller_selected:getGamepadAxis(self.virtual_pad.axis.trigger_[k].assignment )
			end
			for k,v in pairs (self.virtual_pad.axis.right_) do 
				self.virtual_pad.axis.right_[k].value = self.controller_selected:getGamepadAxis(self.virtual_pad.axis.right_[k].assignment )
			end
			for k,v in pairs (self.virtual_pad.axis.left_) do 
				self.virtual_pad.axis.left_[k].value = self.controller_selected:getGamepadAxis(self.virtual_pad.axis.left_[k].assignment )
			end

		else 												-- none game pad binding for controls 
			-- error system trigger, controller must be game pad... 
		end 
	else 
		-- error no controller connected 
	end

end -- // EOF




-- updated at 60 fps
function Controller:update_()

	-- Controller selection after time out // hot swap 
	------------------------------------------------------------------------------------------------------------------
	if self.controller_selected then 											-- state machine 
		self.controller_connection = self.controller_selected:isConnected( ) 	-- check state at all times 
		self:operator_() 														-- updates button states and values 
	else
		self.controllers_ = love.joystick.getJoysticks( ) 						
	end

	if self.controller_connection == false  then 
		self.time_out_clock = self.time_out_clock+1
	end 

	if self.time_out_clock >= self.controller_params.refresh_rate and self.time_out_state == 0  then 
		self.controller_selected = nil 
		self.time_out_clock = 0 
		self.time_out_state = 1
	end 

	if self.time_out_state == 1 then 
		self.controllers_ = love.joystick.getJoysticks( )
		self:select_controller() --// default 
	end 
	----------------------------------------------------------------------------------------------------------------



	--// vibration update from character bind 
	if 	self.controller_params.rumble_toggle == 1 then 
		local OWZ_ = self.rumble_object.world_z or 0
		if self.controller_params.rumble_value <= self.controller_params.rumble_AmtCap*OWZ_ then 
			self.controller_params.rumble_value = (self.controller_params.rumble_value+ self.controller_params.rumble_ramp)
		end
	end 
	--// update the vibration state of the controller 
	if self.controller_selected then 	
		self.controller_selected:setVibration(self.controller_params.rumble_value,self.controller_params.rumble_value)

	end 
end -- // EOF


return Controller  