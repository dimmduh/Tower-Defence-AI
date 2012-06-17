--[[
version 1.1

changelog
1.1
getAngle - inverse degree according to Corona sdk function rotation - !contraclockwise
!!earlier version demos do not support this change and will work incorrectly, e.g. controller class
--]]
module ('utils', package.seeall)

function showFps()
        local prevTime = 0
        local curTime = 0
        local dt = 0       
        local fps = 50
        local mem = 0
              
        local underlay = display.newRoundedRect(0, 0, 300, 20, 12)   
        underlay.x = 240
        underlay.y = 11
        underlay:setFillColor(0, 0, 0, 128)             
        local displayInfo = display.newText("FPS: " .. fps .. " - Memory: ".. mem .. "mb", 0, 40, native.systemFontBold, 30)
        
        local function updateText()
                curTime = system.getTimer()
                dt = curTime - prevTime
                prevTime = curTime
                fps = math.floor(1000 / dt)
                mem = system.getInfo("textureMemoryUsed") / 1000000
                
                --Limit fps range to avoid the "fake" reports
                if fps > 60 then
                        fps = 60
                end
                
                displayInfo.text = "FPS: " .. fps .. " - Memory: ".. string.sub(mem, 1, string.len(mem) - 4) .. "mb"
                underlay:toFront()
                displayInfo:toFront()
        end
        
	Runtime:addEventListener("enterFrame", updateText)
end


function showScreenSize()
	print('Screen width: ', display.contentWidth);
	print('Screen height: ', display.contentHeight);	
	print('Screen top: ', display.screenOriginY);
	print('Screen bottom: ', display.viewableContentHeight + display.screenOriginY);
	print('Screen left: ', display.screenOriginX);
	print('Screen right: ', display.viewableContentWidth + display.screenOriginX);
end


function sign(x)
  return (x<0 and -1) or 1
end



function getDistance(x1, y1, x2, y2)
	return math.sqrt( math.pow( x2 - x1, 2 ) + math.pow( y2 - y1, 2 ) );
end


function getAngle(x1, y1, x2, y2)
	local angle = 0
	
	local dx = (x2 - x1)
	local dy = (y2 - y1)
	
	--несчитаем при нулевом
	if ( dx ~= 0 or dy ~= 0 ) then
	
		--находим синус угла, затем вычисляем угол в радианах, затем в градусы
		local sinus = -dy / ( math.sqrt( dy * dy + dx * dx ) );
		angle = math.deg( math.asin( sinus ) )
		
		if ( dx <= 0 ) then
			if (dy <= 0 ) then
				--2
				angle = 90 + 90 - angle
			else
				--3
				angle = 180 + math.abs(angle)
			end
		else 
			if (dy <= 0 ) then
				--1
			else
				--4
				angle = 270 + 90 - math.abs(angle)
			end
		end
	end
		
	return (360 - angle)
end