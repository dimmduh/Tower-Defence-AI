Worm = {}

function Worm:new(params)
	
	local sheet1 = sprite.newSpriteSheet( "img/worm.png", 64 , 48 )
	local spriteSet1 = sprite.newSpriteSet(sheet1, 1, 4)
	sprite.add( spriteSet1, "worm", 1, 4, 400, 0 ) -- play 8 frames every 1000 ms

	local worm = sprite.newSprite( spriteSet1 )
	worm.destroied = false
	
	local randScale = math.random(10, 30) / 10
	worm.xScale = randScale
	worm.yScale = randScale
	
	local randAngle = math.random(0, 359);
	worm.x =  math.cos( math.rad( randAngle ) ) * (_W / 2 + 100) + _W / 2
	worm.y = -math.sin( math.rad( randAngle ) ) * (_H / 2 + 100) + _H / 2
	
	worm.targetX = params.targetX
	worm.targetY = params.targetY
	
	worm:prepare("worm")
	worm:play()
	
	--real angle (movement angle)
	worm.angle = utils.getAngle( worm.x, worm.y, worm.targetX, worm.targetY )

	--rotation image object
	worm.rotation = worm.angle - 180
	worm.speed = math.random(2, 5) + 0

	function worm:enterFrame(e)
		if (self.destroied ) then
			self:destroy()
			return true;
		end
		if ( self:isOut() ) then
			self:kill()
		end
		
		--calculate offset
		self.dx = math.cos( math.rad( self.angle) ) * self.speed;
		self.dy = math.sin( math.rad( self.angle) ) * self.speed;
		
		--moving
		self.x = self.x + self.dx
		self.y = self.y + self.dy
		
	end
	
	function worm:kill()
		if (#enemies < 300) then --bug! the enemies does not update
			table.insert(enemies, Worm:new({
				targetX = turel.x,
				targetY = turel.y
				})
			);
			table.insert(enemies, Worm:new({
				targetX = turel.x,
				targetY = turel.y
				})
			);
		end
		self.destroied = true
	end
	
	function worm:destroy()
		if ( self ) then
			
			Runtime:removeEventListener("enterFrame", self)	
			self:removeSelf();
			self = nil
		end
	end
	
	function worm:isOut()
	local offset = 200
		return ( (self.x < -offset) 
		or (self.x > _W + offset)
		or (self.y < -offset)
		or (self.y > _H + offset) )
	end
	
	Runtime:addEventListener('enterFrame', worm)
	
	return worm
end

return Worm