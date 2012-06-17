--usefull functions
function p(t)
	print( t )
end

--@see http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed( os.time() )

_W, _H = display.contentWidth, display.contentHeight
fps = 30

require "sprite"
require ("inc/utils");
require ("inc/turel");
require ("inc/bullet");
require ("inc/worm");

utils.showFps();

--background
local bg = display.newImage("img/bg.png", 0, 0)
bg:toBack()

--create turels
turel = Turel:new({x = _W * 0.5 - 100, y = _H * 0.5, shootRange = 250})
turel = Turel:new({x = _W * 0.5 + 100, y = _H * 0.5 + 200, shootRange = 200})
turel = Turel:new({x = _W * 0.5 + 100, y = _H * 0.5 - 200, shootRange = 200})


--create first worm
enemies = {}
local worm = Worm:new({
	targetX = turel.x,
	targetY = turel.y
})

table.insert(enemies, worm)