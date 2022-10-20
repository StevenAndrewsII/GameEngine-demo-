
local Class 			= require("Core/LIB/Class")
local hatchery 			= Class:derive("Hatchery")																		 -- create the class 
local Animator 			= require("Core/LIB/Animator")
local Rigging 		= require("Core/LIB/world_vectoring")
local SM 				= require("Core/LIB/Sound_Manager")
local Emitter 			= require("Core/LIB/Emitter")
local Movement 			= require("Core/LIB/Movement")
local INVM 		= require("Core/LIB/Inventory")
local ModelController	= require("Core/LIB/ModelController")
local Particle	= require("Core/LIB/Particle")


local LSM	= require("Core/LIB/LSM")
-- back end common functions 
local ENGINE_LIB 		= require("Core/LIB/ENGINE_LIB")


--[[
-------------------------------------------------------------------------
VERSION: 10.0 - under heavy construction 
-- Steven Andrews II
- THE HATCHERY:	 (entity creation LIB)
DEV LOG: rough cut: 
-------------------------------------------------------------------------

updated: 1.5 ( core building + major error fixes )
* model and object creation
* scene manager (upper systems )
* animation binding 
* Camera module (version 4.3 to 5)
* Animator hooked into the system per object ~ per body segment 
* created the Hatch_ ( master draw for each scene )

updated: 2.0 ( core building )
* bug fixes 
* animator fixed to 60 fps 				( smooth animations )
* unbound the draw 60_fps 				( draws at full frames, animations look better )
* hooking in 60 fps to game logic  		(standardizes all game logic )
* creating model files 					(basic roll out/ advanced prototype format )

updated: 3.0 ( core building )
* object attachment (1.0)
* model vertex vectoring (1.0)
* added different vertex types. ( ray_caster , Emitter, vertex obj attachment )
* bug fixes 

update 4.0- 6 ( major feature update patch !! ( core features flush )
* particle emission creation  ( full functional emitter/ particle system )
* (vectoring module now runs faster 20 fps boost ) **
* bug and error fixes (fps boosts) 
* adding a world movement system ( controls all world objects movements basic roll out ) 
* added object removal system  (fps boosting )
* added new features to particles ( creation, destruction, tracking, movement binding.. many) 
* bug fixes and testing 4.5**
---<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   update 6-7 ( graphics improvements ) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

update 7.0: ( major core update )
* images_ table to hold loaded images for cross referencing for model creation 						- done
* add a frame buffer ( can now draw hundreds of objects at full speed ) 	                		- done 
* add Z axis 																						- done 
** draw from cull/draw list																			- done
*clean up models - fix formatting up a tad, remove dead materials 

* emitter upgrades:	-- done all
* shrink function
* grow functions 
* color arbitration 

* model upgrades:  -- basic roll out done 
* color arbitration 
* color arbitration 


* movement:  -- done 

* added sway 
* shake 
* push
* basic object rotation around object center 
* object XYZ manipulation 

** bug fixes in all scripts '

--<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< update 8 - 9 ( getting moving ) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

* sound system roll out (hooked to animations)
* controls and bindings 
* model binding to controls 
* model rigging 
* camera updates ( bug fixes and error fix + new features )

---<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   currently active update 10 (pew pew pew, large content dump ) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

weapon attachment version 2.0 
rendering 2.0: 			(	 hot object injection 	) --> animation and new weapon types 
New weapons: 			(  XMT [ flame thrower ], SMG  )
Inventory systems: 		( just started )
model rigging / "world vectoring old name " 3.0
Animator API big/error patch 
model patches and upgrades 
emitters and particles 2.0 
buffer system 2.0 + bug fixes 
object removal bug fixes 2.0
object sizing on loading 2.0


----------------------------------------------------------------------
Lighting and shader 1.0   ( current construction order : )
----------------------------------------------------------------------


created a lighting system to apply lighting to each object 

pros:

multi colored lighting 
z axis buffered so only lights above an object affect those objects draw ops 
vectored for camera, they are treated like normal objects 
has movement module bind
direct look up from within each object // each object has a new list: lighting : contains each light to be applied to itself 
all in back end, no external files needed to load. load the lights shader in later through a shader system . 

broken:

some shader issue on mobile  ( IDK looks complex works on pc?? )
still hae no idea how to do th zaxis normalization 
Multi-Shader support isnt even in 

notes 

moved entire lighting system to the LSM for management 


------------------------------------------------------------------
-- composite object ( made of several real objects ) 1.0 
------------------------------------------------------------------
-- base functions roll out 


]]


















function hatchery:new(Camera,Scenes_,scene_name,controller) 	
	
	--// meta data tables 
	self.model_table 	= 	{}					--	holds all loaded objects and image data 
	self.images_ 		= 	{}					--  holds all image (in use/loaded)/cleared if models don't need it automatically (update 7.0 )													
	self.objects 		= 	{}					--  holds all objects created 
	self.DO_ 			= 	{}					--  order to draw objects based on z axis height 
	self.AO_ 			=	{}					--  Attached objects table 
	--// new type of model 
	self.CModels		= 	{}
	


	--// lighting system 
	self.LSM					= LSM(self)
	--// world camera 
	self.Camera 				= Camera				
	--// sound system 
	self.Sound_Manager 			= SM(self)       
	--// scene manager and current self scene ref 
	self.Scenes_ 				= Scenes_			   
	self.scene_name 			= scene_name
	--// controller      < -- move to scenes// passed to the hatch 
	self.C 						= controller  
	self.ENGINE_LIB = ENGINE_LIB

	

	-- DEBUGGING: 
	--// to do:
	self.debug_modelLoad		= true
	self.debug_objectCreation 	= true
	--// ready: 
	self.debug_draw 			= true
	self.debug_AO 				= false
	self.debug_draw_order 		= false 
	
end  -- // EOF


---------------------------------------------------------------------------------------------------------------------------------------------------
--// 													compositional models loading and creation  ( space station and frigate ships tech )
---------------------------------------------------------------------------------------------------------------------------------------------------


--// create a composite model
--/. stores the comp model into a table for ref 
function hatchery:load_composite(file)
	local raw_ 				= love.filesystem.load( file ) 													-- load the file into ram
	local O_ 				= raw_() 																		
	O_.self_file 			= file 
	assert(self.objects[O_.type] == nil, "Hatchery:load_composite " .. O_.type .. " name already exist in reference !")

	--[[ example of a composited model architecture: 

			type 			= "Arch_cruiser"
			visible 		= true, 			--// vis state 	( works with libs )

			world_cords = {						--// cords 		( works with libs )
				vis_ 		= true,
				X 			= 0,
				Y 			= 0,
				Z 			= 0,
				R 			= 0
			},

			composition = {				--// objects to make
				(	name = "XR-5"		,	type =  "XR-5"		,	cords = {x,y,z,r}	,file = f	)
				(	name = "player_1"	, 	type =  "player"	,	cords = {x,y,z,r}	,file = f	)
			},

	]]

	--// load each model ( into model table)
	for index = 1, #O_.composition do 
		self.load(O_.composition[index].file) 
	end 
	-- // set the Composite Model we just loaded into the CM table 
	self.CModels[O_.type] = O_

end




--// create a composition from existing models or from 
function hatchery:create_composite_object(name_,type_)

	assert(self.CModels[type_] ~= nil, "Hatchery:create_composite_object " .. type_ .. " type does not exist in reference !")
	

	--// create objects and pool them 



--// create objects for the model 
end

function hatchery:remove_composite_object( name )
--// create objects for the model 
end

function hatchery:remove_composite_model( name )
--// create objects for the model 
end






---------------------------------------------------------------------------------------------------------------------------------------------------
--// 															model loading & object creation 
---------------------------------------------------------------------------------------------------------------------------------------------------


function hatchery:load(file) 		



															-- add an object and its table...
	local raw_ 	= love.filesystem.load( file ) 													-- load the file into ram
	local object_ 	= raw_() -- run to get the return 	

	object_.self_file = file -- // 8.0 	added file location of itself. 	

	assert(self.model_table[object_.type] == nil, "Hatchery:load " .. file .. " already exists exists in model_table!")
	print("file loading... "..object_.type)
	self.model_table[object_.type]= object_												-- insert object table from file loading into hatchery objects list
	local tmp_width = {}
	local tmp_height = {}
	for a = 1,#object_.body_parts do
		for b = 1,	#object_.body_parts[a].images do

			----------------------------------------------------------------------------------
			-- image duplication check and image copy system (update 7.0 )
			----------------------------------------------------------------------------------
			if  #self.images_>0 then 
				for i = 1,#self.images_ do 
					-- check for duplicates, copy the found copy to the model 
					if self.images_[i][2] == object_.body_parts[a].images[b] then 
						self.model_table[object_.type].body_parts[a].images[b] =  ENGINE_LIB:deep_copy(self.images_[i])
						break
					-- check for end of the table, insert the new image into table, 
					elseif i == #self.images_  then
						table.insert(
							self.images_,  -- image data , location 
							i,
							{ love.graphics.newImage(	object_.body_parts[a].images[b]	) , object_.body_parts[a].images[b] }
						)
						self.model_table[object_.type].body_parts[a].images[b] = ENGINE_LIB:deep_copy(self.images_[i]) 
						break
					end
				end 
			else 						-- first run indexing and assignment
				table.insert(
					self.images_,  		-- image data , location 
					{ love.graphics.newImage(	object_.body_parts[a].images[b]	) , object_.body_parts[a].images[b] }
				)
				self.model_table[object_.type].body_parts[a].images[b] = ENGINE_LIB:deep_copy(self.images_[1]) -- first index
			end


			-- capture the height and width of image set. ( all must be the same size !!)
			local state__ = false
			if b == 1 and state__ == false then
					
				------------------------------------------------------------------------------------------------------------
				--// 2.0 composite image sizing system 
				--//
				--// assumes all images within  ( Bdy_parts / animation_set )  are the same size images 
				--// vectors the images around the model center and gets the outside edge distance from the center 
				--// to return 
				--// the actual size of the composite imaged models // also works for single image models 
				--
				--
				--// 10.0 bug fix JAN 23/22
				------------------------------------------------------------------------------------------------------------

				-- get image data for the set ( assumes all images are the same size in the set )
				self.model_table[object_.type].body_parts[a].width  = self.model_table[object_.type].body_parts[a].images[b][1]:getWidth(  ) -- get height and width data from first image
				self.model_table[object_.type].body_parts[a].height = self.model_table[object_.type].body_parts[a].images[b][1]:getHeight(  )
				--the actual location vectored around a model center. 
				local X____ 		= 	(self.model_table[object_.type].body_parts[a].local_X)
				local Y____ 		= 	(self.model_table[object_.type].body_parts[a].local_Y)
				--// heat and width of the current images 
				local H____ 		= 	self.model_table[object_.type].body_parts[a].height
				local W____ 	=	self.model_table[object_.type].body_parts[a].width
				--// get the leading Edge___ ( what side of zero is bigger )
				if X____ < 0  then  
					Edge___w = -(W____/2)+math.abs(X____)
				else
					Edge___w = (W____/2)+math.abs(X____)
			 
					if X____ == 0 then
						Edge___w = self.model_table[object_.type].body_parts[a].width/2
					end
			
				end
				-- Y axis 
				if Y____ >0  then  
					Edge___h = -(H____/2)+math.abs(Y____)
				else
					Edge___h = (H____/2)+math.abs(Y____)
					if Y____ == 0 then
						Edge___h = self.model_table[object_.type].body_parts[a].height/2
					end
				end
				table.insert(tmp_width,  (Edge___w )  )
				table.insert(tmp_height,  (Edge___h )  )
				state__ = true
			end -- // EOF
			--// END OF image composition size 




		end
	end
	

	-----------------------------------------------------------------------------------------------
	---// get and set the width/ height of the composite imaged model and its constituent images 
	-- // 10.0 bug fix 
	-----------------------------------------------------------------------------------------------
	table.sort(tmp_width  ,function (a,b) return a > b end )
	table.sort(tmp_height ,function (a,b) return a > b end )
	--// (-negative) values about the Cartesian axis plains 
	local tmp_smallest_value_W = ENGINE_LIB:deep_copy(tmp_width)	
	local tmp_smallest_value_H = ENGINE_LIB:deep_copy(tmp_height)	
	table.sort(tmp_smallest_value_W  ,function (a,b) return a < b end )
	table.sort(tmp_smallest_value_H ,function (a,b) return a < b end )
	--// to get the total size we add thair absolute values together 
	local A___ = math.abs(tmp_width[1]) + math.abs( tmp_smallest_value_W[1])
	local B___ = math.abs(tmp_height[1]) + math.abs(tmp_smallest_value_H[1])
	--// error handle for single image models  and setting the values 
	if A___ ~=0 then 
		self.model_table[object_.type].obj_width = A___
	else
		self.model_table[object_.type].obj_width = tmp_width[1]
	end 

	if B___ ~=0 then 
		self.model_table[object_.type].obj_height = B___
	else
		self.model_table[object_.type].obj_height = tmp_height[1]
	end 

	--// 8.0 
	-- load sound 
	-- load the sound into a main sound table 
	if self.model_table[object_.type].sound then 
		for i = 1,#self.model_table[object_.type].sound do 
			self.Sound_Manager:load_sound(
				self.model_table[object_.type].sound[i][1] ,
				self.model_table[object_.type].sound[i][2] , 
				self.model_table[object_.type].sound[i][3]
			)
		end 
	end 

return true 
end -- // EOF





-- create a new object with the attributes of its model file in ram..
function hatchery:create_object(scene,object_name,object_type,spawn_vector_table) 
	assert(self.model_table[object_type] ~= nil, "Hatchery:create_object " .. object_type .. " Does not exist in objects!")
	assert(self.objects[object_name] == nil, "Hatchery:create_object " .. object_name .. " name already exist in objects!")

		

	--print("object creating: ".. object_name)

		-----------------------------------------------------------------------
		--// Set up and initialization 
		-----------------------------------------------------------------------
		-- copy the meta data of the model as the object 
		local metta_model 								= ENGINE_LIB:deep_copy(self.model_table[object_type])
		-- insert a copy of the model into the objects table
		self.objects[object_name] 						= metta_model					
		-- update the objects world position on our copy
		self.objects[object_name].world_cords.X 		= spawn_vector_table.X or self.objects[object_name].world_cords.X
		self.objects[object_name].world_cords.Y 		= spawn_vector_table.Y or self.objects[object_name].world_cords.Y
		self.objects[object_name].world_cords.Z 		= spawn_vector_table.Z or self.objects[object_name].world_cords.Z
		self.objects[object_name].world_cords.vis_ 		= spawn_vector_table.vis_ or self.objects[object_name].world_cords.vis_ --// entire object vis
		self.objects[object_name].world_cords.R 		= spawn_vector_table.R or self.objects[object_name].world_cords.R
		
		self.objects[object_name].scene 				= scene -- add the scene name as a reference to the model 
		self.objects[object_name].name 					= object_name

		--// changing emitter stuff so it is persistent (update 10 emitter and particles separation )
		self.objects[object_name].Particle_params 		= spawn_vector_table.Particle_params or nil 
	


		-----------------------------------------------------------------------
		--// Movement API 
		-----------------------------------------------------------------------
		self.objects[object_name].Movement_ 			= Movement(self.objects[object_name],self.objects[object_name].world_cords,self.Camera)

		-----------------------------------------------------------------------
		--// Controller binding 
		-----------------------------------------------------------------------
		if self.objects[object_name].controller_bind then 
			self.objects[object_name].ModelController 	= ModelController(
				self,										-- hatch_ call back ref 
				self.objects[object_name],					-- object data reference 
				self.C,										-- controller raw input module
				self.objects[object_name].controller_bind, 	-- controller bind map/table ( EZ ref )
				self.Camera 								-- world camera 
			)
		end 

		--------------------------------------------------------------------
		--// update 10.0 systems plug in // no bugs reported !
		--------------------------------------------------------------------

		--// hooks the rigging of an object to manipulate the object creation and deletion in hand 
		if self.objects[object_name].Inventory then 

		self.objects[object_name].Iventory_manager 	= INVM (

			self,											--// hatch_ ref
			{ self.objects[object_name],object_name }		--// object self ref 

		)
		end

		--self.object[object_name].Weapon_manager 	= WM ()

		-----------------------------------------------------------------------
		--// Vertex point location manipulation and binding 
		-----------------------------------------------------------------------
		self.objects[object_name].Rigging_ = Rigging(
			self,											-- hatch_ call back ref
			{self.Scenes_,self.scene_name},					-- scene manager and current scene ref
			self.objects[object_name],						-- object data ref 
			object_name										-- self object name ref 
		)


		-----------------------------------------------------------------------
		--// Emitter binding for vertex points 
		-----------------------------------------------------------------------
		if self.objects[object_name].vertex_points then 
			for a =1,#self.objects[object_name].vertex_points do		
				---------------------------------------------------------------
				--//  emitter creation on start 
				---------------------------------------------------------------
				if self.objects[object_name].vertex_points[a].emitter__ then
					self.objects[object_name].vertex_points[a].Emitter_ = Emitter(
						object_name,									-- object name 
						a,												-- object vertex stack location 
						self.objects[object_name].world_cords,			-- the actual objects world cord
						self.objects[object_name].vertex_points[a],		-- the A(th) vertex table 
						self.objects[object_name].scene,				-- the current scene name that the parent exists in 
						self,										 	-- hatch_ call back ref
						self.objects[object_name].Movement_				-- object movement module
					)
				end
			end 
		end


		----------------------------------------------------------------------
		--//  Particle sub system controller 
		--// needs to be updated all the time 
		----------------------------------------------------------------------

		if self.objects[object_name].Particle_params then 
			self.objects[object_name].Particle_ = Particle(
				self.objects[object_name].Particle_params[1],			--// conditions 
				self.objects[object_name],								--// particle ref 
				object_name,											--// object self name // for call back 
				self,													--// hatch_ ref 
				{self.Scenes_,self.scene_name},							--// (scene manager and current scene ref)
				self.objects[object_name].Particle_params[2]			--// the Emiter caster functions ref  
				)				
		end 


		-----------------------------------------------------------------------
		--// Animator_Manager_System
		-----------------------------------------------------------------------
		for a =1,#self.objects[object_name].body_parts do
			self.objects[object_name].body_parts[a].Animator_ = Animator(
				self.objects[object_name].body_parts[a], 
				self.objects[object_name].vertex_points, 
				self.objects[object_name], 
				self.Sound_Manager						-- 8.0 sound input 
				) 
		end
		-----------------------------------------------------------------------
		-- inserting the object into a draw order to be buffered before draw 
		-----------------------------------------------------------------------
		table.insert(
			self.DO_,																					
			{object_name,self.objects[object_name].world_cords.Z}	
		) 


		-- return the object by default. 
		return self.objects[object_name]
end   -- // EOF





-------------------------------------------------------------------------
--// BUFFING SUB SYSTEMs 
--[[
10.0 update: (edited ( updated 10.7 ))

->	attached objects 
->	multi scene bug fixed 
->	rendering 2.0 / rigging 2.0 integration 

]]
-------------------------------------------------------------------------


function hatchery:buffer(  )
	---------------------------------------------------------------------------------
	--// buffer AO_ and DO_ list for pair  // remove from the draw buffer if its in the AO_ 
	--// ( updated 10.7 )
	--------------------------------/AO_ buffer/-------------------------------------
	for AOI = 1,#self.AO_ do
		for DOI = 1,#self.DO_ do 
			if self.AO_[AOI][1] == self.DO_[DOI][1] then 
				print("removed a draw object for AO_ buffer  ")
				table.remove(self.DO_,DOI)
				break --// speed up w/ breaks
			end
		end
	end
	---------------------------------------------------------------------------------
	--// sort the draw list ( updated 10.7 )
	---------------------------------------------------------------------------------
	for k,v in pairs(self.objects) do 
		if v.world_cords.vis_ ==  false  then										
				--// remove non visible objects from draw buffer
				for i = #self.DO_,1,-1 do 			
					if self.DO_[i][1] == k then
						table.remove(self.DO_,i)
						break														
					end
				end

			--// insert visible objects into the draw buffer 
			else 
	
				--// default opp 
				if #self.DO_ == 0 then 
					table.insert(
								self.DO_,			-- insert to draw table 
								1, 					-- insert at the end of the table 
								{k,v.world_cords.Z}	-- create the draw order object 
								) 
					return 							-- break opp
				end 

			table.sort(self.DO_,function (a,b) return a[2] > b[2] end )																
			for i = 1,#self.DO_ do
				--// Already in the draw buffer/ no opp required 
				if self.DO_[i][1] == k then
					break 														 
				end
				--// if its VISIBLE and not in the DO_ check if it in the AO else put it in the DO
				if self.DO_[i][1] ~= k and i >= #self.DO_ then 
				--// loop AO_ to check if its name is flagged 
					if #self.AO_ ~= 0 then 
					for AOI = 1, #self.AO_ do 
						if k == self.AO_[AOI][1] then 
							break
						--// insert object --> draw: DO_ if not in the AO either 
						elseif AOI >= #self.AO_ then 
								table.insert(
								self.DO_,			-- insert to draw table 
								i, 					-- insert at the end of the table 
								{k,v.world_cords.Z}	-- create the draw order object 
								) 
						end 
					end	
					else --// default if no AO objects 
						table.insert(
								self.DO_,			-- insert to draw table 
								i, 					-- insert at the end of the table 
								{k,v.world_cords.Z}	-- create the draw order object 
								) 

					end
				end 
			end
		end 
	end 
end --//EOF


-----------------------------------------------------------
--// World camera vector translation 
-----------------------------------------------------------

function hatchery:world_translation()
	for k,v in pairs( self.objects ) do 
		v.translated_x,v.translated_y,v.world_z = self.Camera:camera_vectoring(v.world_cords.X,v.world_cords.Y,v.world_cords.Z,k)
	end 
end -- // EOF


-- --------------------------------------------------------
--//  Object off screen render culling 
--// updated: ( updated 10.7 )
-----------------------------------------------------------
function hatchery:culling(obj)

	local VTX 		= 	obj.translated_x 		or 0 -- defaults check arguments if not yet translated 
	local VTY 		= 	obj.translated_y 		or 0
	local VTZ 		= 	obj.world_z 			or 0
	local offset_ =  obj.world_cords.Z_offset or 1

		--// off screen culling 
	if  VTX  <=  - obj.obj_width * (VTZ/offset_)  or VTY <= -obj.obj_height * (VTZ/offset_) or 
		VTX  >=  love.graphics.getWidth() + obj.obj_width * (VTZ/offset_)  or VTY >= love.graphics.getHeight() + obj.obj_height * (VTZ/offset_)
		--// Z culling 

		-- if model takes up entire screen dont draw it (1.0 add please)
		or obj.world_cords.Z >= self.Camera.current_zoom then -- temp

		obj.world_cords.vis_ = false 
	else
		obj.world_cords.vis_ = true
	end 
end-- // EOF






-----------------------------------------------------------------------------------------------
---// lighting demo shader ( under construction )
-----------------------------------------------------------------------------------------------
local shader_code = [[
#pragma language glsl3
#define NUM_LIGHTS 32
struct Light {
    highp vec2 position;
    highp float Z;
    highp vec3 diffuse;
    highp float power;
    highp float wrldZ;
    highp float X;
    highp float Y;
};
extern Light lights[NUM_LIGHTS];
extern int num_lights;
extern vec2 screen;
extern highp float wrldZ;
const float constant = 1.0;
const float linear = 0.09;
const float quadratic = .32;
vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords){
    vec4 pixel = Texel(image, uvs);
    vec2 norm_screen = (screen_coords / screen);
    vec3 diffuse = vec3(0);
    for (int i = 0; i < num_lights; i++) {
        Light light = lights[i];
        vec2 norm_pos = light.position / screen;



        
        highp float distance = (length(norm_pos - norm_screen) * light.power);
        highp float attenuation = constant / (constant + linear * distance + (quadratic) * (distance * distance));
        diffuse += light.diffuse * attenuation;
    }
    diffuse = clamp(diffuse, 0.0, 1.0);
    return pixel * vec4(diffuse, 1.0)*color; 
}
]]


local shader = nil

shader = love.graphics.newShader(shader_code)

------------------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<










-------------------------------------------------------------------------------------------
--[[//							RENDERING ENGING 10.0 
-------------------------------------------------------------------------------------------
	updates:
	shader support ( lighting 2.0 )	
	color arbitration ( LOVE back-end // default shader )
	object attachment (  [a models] body layer object injection )
	debugging ( rudimentary )
	bugs cleared: speed issues mostly are resolved 

--//]]
-------------------------------------------------------------------------------------------

function hatchery:render()	


	local function call(v_, VBP_,VL_)
		if VBP_.vis_toggle and VBP_.visible and (VBP_.Animator_.rt[1] ~= 0 or nil)  then
					-- utilize love graphics push for color arbitration 






					love.graphics.push()
					--------------------------------------------- (7.0 has to be here )
					-- Z_offset and world_z defaults (if not in model by engine...) ** used in shrink for emitters 
					local world_z 	= v_.world_z 				or 0 	--// default val if no translation val  = 0
					local Z_offset 	= v_.world_cords.Z_offset 	or  VBP_.Z_offset or 1 	--// default val if no offset data = 1	
					
					--// render effects size manipulation 
					local vbp_ZM = VBP_.Z_multiplier or 1
					local shear_factorX = VBP_.Animator_.rt[5] or 1
					local shear_factorY = VBP_.Animator_.rt[6] or 1



					------------------------------------------------------------------------------------------------------
					--// light system 
					--// 1.0 // shader initialization ( taken out for demo )
					------------------------------------------------------------------------------------------------------
					local function L___(V___)
						if V___.lighting then 
							--print(#V___.lighting)
							for i = 1, #V___.lighting do 
								--// test code for lighting shader application ( multi color lightning example )
								local name = "lights[" .. i-1 .."]"
								love.graphics.setShader(shader)

							    shader:send("screen", {
							    love.graphics.getWidth( ),
							    love.graphics.getHeight( ),
							    })
							   
								shader:send(name .. ".position", {V___.lighting[i].translated_x or 0 , V___.lighting[i].translated_y or 0})
						        shader:send(name .. ".diffuse", V___.lighting[i].L_params.diffuse_)
						        shader:send(name .. ".power", V___.lighting[i].L_params.strength_)
						        shader:send(name .. ".wrldZ",V___.lighting[i].world_z or 0 )
						        shader:send("num_lights", #V___.lighting)
							end 
						end 
					end 
					--// passes light arguments from an object 
					if VL_ then 
						---L___(VL_)
					else
						---L___(v_) --// default, uses self table 
					end 
					--------------------------------------------------------------------------------------------------



					--// old lighting system... if no lights exist this should be a default operation 

					--??<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					--// update 10.9 ( future update// remove all of this to a system that condenses it out side of the draw loop )
					--// color arbitration direct manipulation
					if VBP_.Animator_.rt[4] then --// passed by animator 
						love.graphics.setColor(  VBP_.Animator_.rt[4][1] , VBP_.Animator_.rt[4][2] ,  VBP_.Animator_.rt[4][3] ,  VBP_.Animator_.rt[4][4] )
					    elseif VBP_.color_ then --// body part color (alpha over ride)	
							love.graphics.setColor(  VBP_.color_.RED_, VBP_.color_.GREEN_, VBP_.color_.BLUE_,  VBP_.color_.ALPHA   ) 
						elseif v_.color_ then  --// model color chang
							love.graphics.setColor(  v_.color_.RED_, v_.color_.GREEN_, v_.color_.BLUE_, v_.color_.ALPHA )
						else -- default
							love.graphics.setColor(1,1,1,1)
					end

					--// update 7.0 final draw call operator 
					if VBP_.Animator_.rt[ 1 ] ~= 0 then --// skip
					love.graphics.draw(  
						VBP_.images[ VBP_.Animator_.rt[ 1 ] ][ 1 ], 	-- // image passed down from objects animator 
						v_.translated_x, 								-- // 2.5Dimensional re_vectoring for Z axis for X around center of camera
						v_.translated_y, 								-- // 2.5Dimensional re_vectoring for Z axis for Y around center of camera
						math.rad(	v_.world_cords.R + VBP_.local_ROT	), 
																		-- // z off set, doesn't affect true z or ordering 
						(vbp_ZM	*	world_z/	Z_offset)	/	(shear_factorX),   							-- // scale factored to Z along X based on image width  2.5D (camera )
						(vbp_ZM	*	world_z/	Z_offset)	/	(shear_factorY),   							-- // scale factored to Z along Y based on image height 2.5D (camera ) 
						((VBP_.width  /	2	) + VBP_.local_X + VBP_.Animator_.rt[2] ) , -- bind animation offset and local offset to center of part.. offsets the part 
						((VBP_.height /	2	) - VBP_.local_Y + VBP_.Animator_.rt[3] )   -- bind animation offset and local offset to center of part.. offsets the part 
					)
					love.graphics.pop()
				end
				end
				love.graphics.setShader()
	end-- EOF ( CALL )
		
	for i = #self.DO_,1,-1 do

	if (self.objects[self.DO_[i][1]] )then
	local v = self.objects[self.DO_[i][1]]

	if self.debug_draw_order ==true  then 
	love.graphics.print(self.DO_[i][1] , love.graphics.getWidth( ) - 200, 20*i/2,0,.6,.6)
	end 



			-------------------------------------------------------------------------------------------------------
			--// version 3.0 rendering system 
			--// object stack injection 
			-------------------------------------------------------------------------------------------------------
			for a = 1,#v.body_parts do

					if self.objects[self.DO_[i][1]].world_cords.AO_toggle then  --// toggle ( fps boost )
					for AOI = 1, #self.AO_ do 
						if self.debug_AO then 
						love.graphics.print(self.AO_[AOI][1] , love.graphics.getWidth( ) - 800, 20*AOI/2,0,.6,.6)
						end
							--// call the layer of the owner object first 
						call(v , v.body_parts[a]) 			
						if v.body_parts[a].reference == self.AO_[AOI][3] and self.AO_[AOI][2] == self.DO_[i][1]   then 	
								if ( self.objects[ self.AO_[AOI][1] ] )then	 
								local V_ = self.objects[ self.AO_[AOI][1] ]
								for BP_ = 1,#V_.body_parts do 
							--//insert the AO_ into the draw directly 
									call(V_ , V_.body_parts[BP_],v) -- // pass lighting from an object to its attached object  
									if BP_>= #V_.body_parts then 
										break
									end 
								end
									else
									break
								end	
						end
					end
					else 	--// default draw opp
						call(v , v.body_parts[a]) 
					end
			end
			-------------------------------------------------------------------------------------------------------	  
	end
	end --// main draw loop end 

	--// debug stats: 
	if self.debug_draw then 
		local stats = love.graphics.getStats()
		local string4 = "Current FPS: "..tostring(love.timer.getFPS( ))
		love.graphics.print(string4.." // images loaded: "..stats.images .. "// Draw_calls: "..stats.drawcalls, 10, 40)
		local string5 =string.format("Estimated amount of texture memory used: %.2f MB", stats.texturememory / 1024 / 1024)
		love.graphics.print(string5, 10, 30)
	end 

end -- // EOF







----------------------------------------------------------------------------------
--// Object manipulation: GET/FIND/DESTROY functions 
----------------------------------------------------------------------------------

function hatchery:get_model(object_type,copy_bool)
	-- returns model file data 
	if not copy_bool or copy_bool == false then
			if self.model_table[object_type] then 
				return self.model_table[object_type] -- returns a ref * original source material
				else return false -- error out 
			end
		else
			if self.model_table[object_type] then 
				return ENGINE_LIB:deep_copy(self.model_table[object_type]) -- copy source materials 
				else return false -- error out 
			end
	end
end -- // EOF




function hatchery:model_exists(object_type,bool_) -- 8.0 added quick return bool_
	local bool = bool_ or false 
	if bool == false then
		if self.model_table[object_type] then
				return true 
		else 	return false 	-- error
		end
	else
		if self.model_table[object_type] then
			-- return reference 
			return self.model_table[object_type]
		else return nil 		-- error 
		end
	end
end  -- // EOF

function hatchery:object_exists(object_name,bool_) -- added quick return bool_ 
	local bool  = bool_ or false 
	if bool == false then 
		if self.objects[object_name] then
				return true 
		else 	return false	 -- error 
		end
	else
		if self.objects[object_name] then
			-- return reference 
			return self.objects[object_name] 	
		else return nil 		-- error 
		end
	end
end  -- // EOF



--// object removal updated in 10.0 
function hatchery:object_remove(object_name)
	if self.objects[object_name] then
		-- remove the controller if has controller bound 
		if self.C.controller_bound__ == object_name then 
			print("deleted controller binding ")
			self.C.controller_bound__ = nil 					--<< this needs an update , but the format is good //also switch controls to scene 
			self.Camera:shakeStop()								
		end 
		--// delete the draw object from its list 
		for i =1,#self.DO_ do 								
			if self.DO_[i][1] == object_name then 
				table.remove(self.DO_,i)
				break
			end 
		end
		--// finds and removes all AO_ objects 
		for i =1,#self.AO_ do 
			if self.AO_[i] and self.AO_[i][2] == object_name then 
				print("found an AO_ and deleted it ")
				self:object_remove(self.AO_[i][1] )
				table.remove(self.AO_,i)
			end 
		end
	-- straight remove the object 
	self.objects[object_name] = nil
	return true 
	end
end -- // EOF



-- removes all reverences of the model and its loaded images... update 7.0 
function hatchery:model_remove(object_type,bool_)
	if self.model_table[object_type] then
		-- Remove image references !
		if bool_ then  -- defaults to false 
			for a = 1,#self.model_table[object_type].body_parts	do 
				--for every image
				for b = 1,#self.model_table[object_type].body_parts[a].images do
					-- check against loaded images_ list 
					for c = 1,#self.images_ do 
						-- remove if found 
						if self.images_[c][2] == self.model_table[object_type].body_parts[a].images then 
							table.remove(self.images_,c)
						end 
					end
				end
			end 
		end 
	-- remove model 
	self.model_table[object_type] = nil
	return true 
	end
end -- // EOF






-------------------------------------------------------------------------------------
--// internal updating 
-------------------------------------------------------------------------------------

-- update the modules that are needed for models to exist at 60 FPS
 function hatchery:object_update()
	for k,v in pairs(self.objects) do
		-- run culling function 
		self:culling(self.objects[k])
		-- // update inventory systems for models with 
		if self.objects[k].Iventory_manager then 
			self.objects[k].Iventory_manager:update()
		end
		-- update the objects movement controller 
		self.objects[k].Movement_:update_()
		self.objects[k].Rigging_:update()
	
		-- update the emitters connected to vertex points... 
		if self.objects[k].vertex_points then 
			for a = 1, #self.objects[k].vertex_points do 
				if self.objects[k].vertex_points[a].Emitter_ then 
				self.objects[k].vertex_points[a].Emitter_:update_()
				end 
			end 
		end
		for b =1,#self.objects[k].body_parts do
			self.objects[k].body_parts[b].Animator_:Animate_()
		end 
		if self.objects[k].ModelController then 
			self.objects[k].ModelController:update()
		end

		if self.objects[k].Particle_ then
		self.objects[k].Particle_:update_() 
		end 





	end
 end -- // EOF




-- update calculations at 60 FPS
function hatchery:update_()
	-- update camera 
	self.Camera:update_()
	-- update the objects 
	self:object_update()
	-- camera vector translation 
	self:world_translation()
	-- buffer update 
	self:buffer(  )
	-- update sound manager
	self.Sound_Manager:update_()
	--// light system 
	self.LSM:update()
end



-- 120 fps  max 
function hatchery:HIGHupdate_()
self.C:update_()


end-- // EOF



return hatchery -- END OF FILE
