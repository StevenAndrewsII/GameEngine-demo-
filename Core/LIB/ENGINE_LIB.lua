


ENGINE_LIB = {

--// random NAME generation 
GEN_KEY 		= 0 ,		--/		Key that is generated ( 0 to overflow value )  ( if )  name supplied is already indexed in table for a key 
OVERFLOW		= 500000,	--/		max number before a reset of the overflow 
TIMEOUT_ENABLE	= false,	--/		timeout system enable toggle ( if the function is stuck for too long looking for a solution it will try random generation )
ENABLE_RANDOM	= false,	--/		always try to use a random (vary fast if name space inst important or is indexed somewhere )
TIMEOUT 		= 500,		--/		max number of secondary index counting (overflow X timeout = number of runs)
ERROROUT_ENABLE = false,	--/ 	error out 
ERROROUT		= 500, 		--/ 	locked at 500 





}



------------------------------------------------------------------------------------------------------------------------------------
--												quick math operations 
------------------------------------------------------------------------------------------------------------------------------------



function ENGINE_LIB:dot_product( ax, bx ,ay , by)
	return ax * bx + ay * by
end 



function ENGINE_LIB:vec(R,radius)
	local angleA 				= R or 0 				-- angle at center of triangle
	local angleB 				= 90												-- right angle triangle, always has 1, 90
	local angleC 				= 180 - 90 - angleA		
 	return ( radius * math.sin( math.rad( angleA ) ) / math.sin( math.rad( angleB ) ) ) ,( radius * math.sin( math.rad( angleC ) ) / math.sin( math.rad( angleB ) ) ) -- law of sins 
end

	--table_[i][1]-table_[i][3] = x1 x2
	--table_[i][2]-table_[i][4] = y1,y2
function ENGINE_LIB:distance_mass(table_)
	local rt_ = {} -- out data 
	for i = 1,#table_ do
		-- calculations
		rt_[i][1],rt_[i][2],rt_[i][3] = math.abs( table_[i][1]-table_[i][3] ), math.abs( table_[i][2]-table_[i][4] ),  math.sqrt(	 math.pow(math.abs( table_[i][1]-table_[i][3] ),2) + math.pow(math.abs( table_[i][2]-table_[i][4] ),2)	 )
		if i >= #table_ then 
			return rt_
		end
	end 
end
function ENGINE_LIB:distance_(x1,y1,x2,y2)
	return  math.abs( x1-x2 ), math.abs( y1-y2 ),  math.sqrt(	 math.pow(math.abs( x1-x2 ),2) + math.pow(math.abs( y1-y2 ),2)	 )
end




----------------------------------------------------------------------------------------------------------------------------------
--//												Table operators 
----------------------------------------------------------------------------------------------------------------------------------




--// creates a random NAME for a Key of a table object K(NAME) = V(data)
--[[//								version 3.0 ( update 10_6 addition )

overflow 		= over flow limit 														( does not have to exist )
NAME 			= a NAME input to check ( unique or not to be checked )					( does not have to exist )
default 		= a default NAME identifier ( default = "default" by default )			( does not have to exist )
N_INDEX    		= a unique index for the key  (  NAME/:_GEN_KEY:/100 ....)				( does not have to exist )
CHECK_T		= a table - checked for a unique key compared to the ( NAME ) input 	( should exist, but not required .. will return but error usually. )


settings :

OVERFLOW		= 500000		
TIMEOUT_ENABLE	= false
TIMEOUT 		= 500000
DEFAULT 		= " default" 		--// base string 


--//]]

function ENGINE_LIB:INDEX_GENERATOR(CHECK_T,N_INDEX,NAME,SETTINGS)

		--// SETTINGS FOR LIB FEED
		local TIMEOUT 						= SETTINGS.TIMEOUT 			or 	ENGINE_LIB.TIMEOUT 
		local TIMEOUT_ENABLE 				= SETTINGS.TIMEOUT_ENABLE 	or 	ENGINE_LIB.TIMEOUT_ENABLE 
		local OVERFLOW 						= SETTINGS.OVERFLOW 		or 	ENGINE_LIB.OVERFLOW  
		local ERROROUT_ENABLE				= SETTINGS.ERROROUT_ENABLE 	or 	ENGINE_LIB.ERROROUT_ENABLE 
		local ERROROUT 						= SETTINGS.ERROROUT 		or  ENGINE_LIB.ERROROUT
		--// DEFAULT value registration 
		local N 							= NAME 						or 	(SETTINGS.DEFAULT or "default")
		local T_ 					        = CHECK_T 					or  {}						
		local N_INDEX 						= N_INDEX 					or 	ENGINE_LIB.GEN_KEY

		--// reset internal (overflow)
		if ENGINE_LIB.GEN_KEY 	>= 	ENGINE_LIB.OVERFLOW then 
		ENGINE_LIB.GEN_KEY 					= 					0
		end 

		--// index the main key 
		if T_[N] then
		N_INDEX 							= N_INDEX 			+	1			--// main index
		end
		----------------------------------------------------------------------------------------------------------------------------
	    --// random NAME generator 3.0 
	    ----------------------------------------------------------------------------------------------------------------------------				
	    local TO_ 							= 					0				--// time out clock 				(clock)
	  --  local RNG_							= 					""				--// RANDOM NAME GEN BLOCK 			( default ~= nil but empty)
	  --  local TOC_							= 					""				--// TIMEOUT compensation 			(uses the random generated number to make a random name with RNG_ tag)
		local index_ 						= 					0 				--// recursion internal index 		( number of new tried index keys )

		while T_[N] do 
		local TN_							= N.."/:_GEN_KEY:/"..N_INDEX.."/:_index:/"..index_
			if T_[TN_] then 
				index_ 						= index_ 			+	1
				--// TIMEOUT SYSTEM && RANDOM NAME GENERATION [ infinite key gen ]
				
			else 				--// end recursion 
				N 							= TN_
			end
		end 					--// EO (WHILE)
		return T_[N]  , N
end 							--// EOF

--[[

TO_ = TO_+1
				if TO_ > TIMEOUT  and TIMEOUT_ENABLE or ENABLE_RANDOM then 
					RNG_ 	= "/:/"..math.random(0,500000.0000		+index_^1.314567) 	--// a pool of RANDOM #'s that grow exponentially based on run 
					TOC_ 	= N_INDEX/math.random(0,500000.0000	    +index_^1.314567)	--// speed up random generator
				end 
				--// extreme error Handle
				if math.abs(TO_ - TIMEOUT) > ERROROUT and ERROROUT_ENABLE then 
					return false
				end

]]





--// copy deep tables ( no ref )
function ENGINE_LIB:deep_copy(obj, seen)
	-- Handle non-tables and previously-seen tables.
	-- check for end/non table element
	if type(obj) ~= 'table' then
	return obj
	end
	if seen and seen[obj] then
		 return seen[obj] -- trace 
	end
	-- New table; mark it as seen an copy recursively.
	local s = seen or {}
	local res = {}
	s[obj] = res
	-- recursion
	for k, v in next, obj do 
		res[self:deep_copy(k, s)] = self:deep_copy(v, s)
	 end 
	 -- return meta copy 
	return setmetatable(res, getmetatable(obj))
end







return ENGINE_LIB