local Class 		= require("Core/LIB/Class")		
local WGE 			= Class:derive("WGE")	

--[[----------------------------------------------------------------------------------------------------------------------------------------------
--//													World Generation Engine 1.0
--------------------------------------------------------------------------------------------------------------------------------------------------

// world generation engine overview: 

Handle the chunk loading and unloading 


// chunks are loaded cam_x and y 
(cam.move_x - cam.follow_x - cam.shake_x) = our current cam_X
(cam.move_y - cam.follow_y - cam.shake_y) = our current cam_Y


chunk_size = ( 1,000,000 )


normalize_X = chunk_size - cam_X 




--]]-----------------------------------------------------------------------------------------------------------------------------------------------

function WGE:new(HATCH_,CAMERA_)

--// scene data 
self.H_ 		= HATCH_
self.CAM_ 		= CAMERA_


--// internal tables 
self.chunk_pool 		= {} --// pool of chunks ( local to the camera ( 3 x 3 chuck load ) )







self.settings = {

	chuck_size = 1000000,

}
end



--[[		load_chunk overview and notation : 

EX: 
0,0,0		visual aid: [ 3 x 3 chunk load ] 
0,x,0
0,0,0


map: 17 x 17


0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,X,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


basically a tile map system.. issues though.. set limits in size 
( granted this is 17 million px ( being dynamically scaled ))

this map... represents 17x17 = 289 chunks x 1 mill = area of 289 mil 
440px = human arm out front to back... apx 3ft 

656,818.181818 *3

1,970,454 feet 


see the fkn problem............
this works for small games... not space at HD quality scales......




-------- idea A


space is mostly god damn empty ...
i do not need to store empty space... 
only places in space ( big boi iq 200 bitch)



chunk x y =    some un godly chunk position in the middle of the fkn universe some place 
my chunk  =    x,y = not there but getting close 
load it as i come in 


all other space ? generated ? 
yes / no.... boff um fam !!!!

when i leave an area... and come back... does it generate a new ? no... needs to be persistent 

persistence ? 
not all space is empty either... some have asteroids and junk ?
pre_fab chunks ? 




















cam_                  y
0000000000000000000000|000000000000000000000                     x theoretical other end ofd screen 
0     x                |										 x	
0     x                |										 x
0     x                |										...
0     x                |
0     x                |
0-----x-------------------------------------- cam_x
0     x                |
0     x                |
0     x                |
0	  x      	       |
0     X                |
0000000000000000000000|000000000000000000000
	  x = edge of chunk 
	  = 1 ( normal val 0 - 1 )
	
	
	generate ? on load ? 





chuck genration ? 

types of chunks: at the core there is 2 
-- empty space 
-- has stuff in it 















0000000000000000000000|000000000000000000000    
0					  |
0                     |
0                     |
0                     |
0                     |
0-------------------------------------------
0                     |
0                     |
0                     |
0					  |
0                     |
0000000000000000000000|000000000000000000000



]]




--// load objects in chunk 
function WGE:load_chunk(matrix_X,matrix_Y)

end



function WGE:load_worldmap()

end









--// vector the chunks 
function WGE:vector()

end


--// controllers and plug ins ( 60 f/s)

function WGE:update()

end


return WGE
