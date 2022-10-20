local Class 		= require("Core/LIB/Class")		
local Movement 		= require("Core/LIB/Movement")
local LSM 			= Class:derive("LSM")	



function LSM:new(HATCH_)
	-- lights 
	self.LO_ 			= {}
	self.LDO_			= {}
	---// RANDOMLY GENERATED NAME (RGN) system 
	self.LGEN_KEY 			= 0
	self.Lighting_name_ganeration_table = {}
	self.H_ = HATCH_ 

	self.shaders = { }
	

end



----------------------------------------------------------------------------------------------------------------------------------
-- // 													light shader 
----------------------------------------------------------------------------------------------------------------------------------





--// load new light shader ? 

function LSM:load_LS(name,file)
end












----------------------------------------------------------------------------------------------------------------------------------
--// 												creation & manipulation  
----------------------------------------------------------------------------------------------------------------------------------






--// create a light object 
function LSM:create_light(X,Y,Z,params,name_ )
--// generation of key default and overflow 
	local name_ = name_ or "GEN_LIGHT:/"
	if self.LGEN_KEY >= 50000 then 
		self.LGEN_KEY = 0
	end 
--// construction table of a light 
	local L_ = { 
		vis_ = true, 													--// state // default  ( comp val )
		world_cords 	=  { 
			X 			= 		X or 0 , 								--// default (must have a value)
			Y 			= 		Y or 0 ,
		 	Z 			= 		Z or 0 ,
		 	visible 	= 		true 									--// toggle // default ( comp val )
		 },

		L_params 		=  {
			strength_ 	= 		params.strength_ 	or 		50,		   --// defaults 	
			diffuse_ 	= 		params.diffuse_ 	or 		{1,1,1}
		}
	}--//EO(L_)
--//  name( table key ) generation and duplication check // creation and subscript injection 2.0 
	if self.LO_[name_] then
	self.LGEN_KEY 						= self.LGEN_KEY +1
	end
--// key gen 3.0 
	local index_ 						= 0 
	while self.LO_[name_] do 
	local TN_							= name_.."/:_LGEN_KEY:/"..self.LGEN_KEY.."/:_RNG:/"..index_
		if self.LO_[TN_] then 
			index_ 						= index_ +1
		else 
			name_ 						= TN_
		end
	end 
--// references and sub script binding 			
	L_.name_ 							= name_  
	self.LO_[name_] 					= self.H_.ENGINE_LIB:deep_copy(	L_ )
	self.LO_[name_].Movement_ 			= Movement(		self.LO_[name_],	self.LO_[name_].world_cords,	self.H_.Camera 	)
	return self.LO_[name_]
end--// EOF






--// remove light object 
function LSM:remove_light( name )
	for i =1,#self.LDO_ do 								
		if self.LDO_[i][1] == name then 
			table.remove(self.LDO_,i)
			break
		end 
	end
self.LO_[name] 		= nil
end --// EOF









----------------------------------------------------------------------------------------------------------------------------------
--// 													buffering 3.0 ( lighting )
----------------------------------------------------------------------------------------------------------------------------------






--// buffer the light objects 
--// buffer visible lights into LDO_
function LSM:LDO_buffer( )
	if self.LO_ then 
	for k,v in pairs(self.LO_) do 

		--// remove non visible light objects from the DLO ( draw light objects )
		if v.vis_ ==  false  then	
		print("removed from the draw lights --------------------------<<<<<")									
				for i = #self.LDO_,1,-1 do 			
					if self.LDO_[i][1] == k then
						table.remove(self.LDO_,i)
						break														
					end
				end

		--// add to the LDO_ if its visible 
		else
		

				--// default opp ( the table is empty )
				if #self.LDO_ == 0 then 
					print("added to the draw lights  --------------------------<<<<<"..v.world_cords.Z.."  "..k)
					table.insert(
								self.LDO_,			-- insert to light draw table 					-- index 1
								{k,v.world_cords.Z}		-- create the light draw order object ( needs cords )
								) 
					return 							-- break main opp
				end 

				--// sort it just like an object 
				table.sort(self.LDO_,function (a,b) return a[2] > b[2] end )	
				--// normal opp for a full table 
				for i = 1,#self.LDO_ do 
					if self.LDO_[i][1] == k then 
						--// break opp if its already indexed 
						 break 
					elseif i >= #self.LDO_ and self.LDO_[i][1] ~= k then 
						--// index it
					
					print("added 2 to the draw lights  --------------------------<<<<<"..v.world_cords.Z.."  "..k)
						table.insert(
								self.LDO_,			-- insert to light draw table 
								{k,v.world_cords.Z}		-- create the light draw order object ( needs cords )
								) 
						--print("self.LDO_[i][1]:    "..self.LDO_[i][1] .. " //   "..self.LDO_)
						return 			 
					end 
				end 

----------------------------------
		end --// vis check 
	end --// end of main loop
end
end --// EOF


--// this operates on objects ( objects buffer )

function LSM:object_lighting_buffer( )


	--// loop through the DO_ objects and place lights as needed 
	for DOI = 1,#self.H_.DO_ do 
		if self.LDO_ then 
		for DLOI_ = 1,#self.LDO_ do --self.H_.objects[self.H_.DO_[DOI][1]].world_cords.Z

			if self.LDO_[DLOI_][2] >= self.H_.DO_[DOI][2] then 

				--// insert into a table within the object 
				--print("object: "..self.H_.DO_[DOI][1].. "was lower than light ")
	
				if self.H_.objects[ self.H_.DO_[DOI][1] ].lighting then  --// condition check 
						--print("has ighting ")
						local duplicate = 0
						for idex_ = 1,#self.H_.objects[ self.H_.DO_[DOI][1] ].lighting do 
							
							if self.H_.objects[ self.H_.DO_[DOI][1] ].lighting[idex_].name_ ==  self.LDO_[DLOI_][1] then 
							--	print("self.LDO_[DLOI_][1] duplicate "..self.LDO_[DLOI_][1] )
								duplicate = duplicate+1
							elseif duplicate == 0 and idex_ >= #self.H_.objects[ self.H_.DO_[DOI][1] ].lighting and self.H_.objects[ self.H_.DO_[DOI][1] ].lighting[idex_].name_ ~=  self.LDO_[DLOI_][1] then 
							--	print("self.LDO_[DLOI_][1] "..self.LDO_[DLOI_][1] )
									table.insert( 
										self.H_.objects[ self.H_.DO_[DOI][1] ].lighting,
										self.LO_[ self.LDO_[DLOI_][1] ]
								)
							
							end 
						end 
				else 
						self.H_.objects[ self.H_.DO_[DOI][1] ].lighting = {}
						table.insert(
							self.H_.objects[ self.H_.DO_[DOI][1] ].lighting,
							self.LO_[ self.LDO_[DLOI_][1] ]
						)
				end 

			else 
					print("object: "..self.H_.DO_[DOI][2].. "was higher than light ")
					--// remove lights below the object 
			end 

------------EO (checks & main loop)
		end 
		end
	end

end --// EOF





--// buffer the off screen light objects  // changes the vis_ of the light object 
--// vector math needed 
function LSM:cull_light( )

end --// EOF

--// translation for the X y based on Z 
function LSM:light_cameraTranslation( )
	if  self.LO_   then 
	for k,v in pairs( self.LO_ ) do 
		v.translated_x,v.translated_y,v.world_z = self.H_.Camera:camera_vectoring(v.world_cords.X,v.world_cords.Y,v.world_cords.Z,k)
	end 
	end
end --// EOF




function LSM:update()
self:light_cameraTranslation( )
self:object_lighting_buffer()
self:LDO_buffer()
end 


return LSM
