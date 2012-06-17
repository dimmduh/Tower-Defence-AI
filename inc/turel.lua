Turel = {}

function Turel:new(params)
    local turel = {}
	
	--create a shape
	turel = display.newImage("img/barrel-h.png", params.x, params.y)
	turel.xScale = 0.5
	turel.yScale = 0.5
	turel.xReference = -78
	
	turel.x = params.x
	turel.y = params.y
	
	turel.shootRate = 10; -- shoots per second
	turel.shootSleep = 100;
	turel.shootSleepMax = fps / turel.shootRate; 
	
	turel.shootRange = params.shootRange
	turel.shootRangeObject = display.newCircle( turel.x, turel.y, turel.shootRange )
	turel.shootRangeObject:setFillColor(255, 0, 0, 100)
	
	turel.target = nil
	
	
	
	function turel:enterFrame(e)
		self:enterFrameAI();
		
		self.shootSleep = self.shootSleep + 1;
	end

	function turel:enterFrameAI()
		if ( self:canIShoot() ) then
			self:aiShoot()
		end
	end
	
	--make a shoot by AI
	--select target, point directly at target and shoot finally
	function turel:aiShoot()
		if (not self:checkTarget() ) then
			self:selectTarget()
			
		end
		
		--possible there are no suitable targets and we have to check it
		if ( self.target ) then
			self:pointAtTarget( self.target );
			self:shoot()
		end
	end
	
	function turel:pointAtTarget( target )
		self.rotation = utils.getAngle( self.x, self.y, target.x, target.y );
	end
	
	function turel:selectTarget()
		if ( #enemies ) then
		
			--try to find enemy, who is nearest to self
			local enemyKey = nil; --key of enemy who has a minimal distance to current turel
			local enemyDistance = 9999999999; --min distance to enemy
			
			for key, enemy in pairs( enemies ) do
				if (enemy.x) then --if enemy was deleted
					local distance = utils.getDistance( self.x, self.y, enemy.x, enemy.y )
					if ( self:enemyInRange( enemy ) and distance < enemyDistance ) then --found out enemy with less distance
						enemyKey = key;
						enemyDistance = distance;
					end
				end
			end

			if ( enemyKey ) then
				self.target = enemies[ enemyKey ];
				return true;
			end			
		end		
		
		self.target = nil;
		
		return false;
	end
	
	--check current target
	--the target can be out of range or already dead
	function turel:checkTarget()
		if ( self.target and self.target.x ~= nil) then			
			--check range
			if ( self:enemyInRange( self.target ) ) then
				return true;
			end
		end
		
		self.target = nil
		return false;
	end

	--check enemy is range or not
	function turel:enemyInRange( enemy )
		local distance = utils.getDistance( self.x, self.y, enemy.x, enemy.y );
		return distance <= self.shootRange;
	end
	
	--check available of shooting
	function turel:canIShoot()
		return ( self.shootSleep > self.shootSleepMax );
	end
	
	--make a shoot (create a bullet)
	function turel:shoot()
		if ( self:canIShoot() ) then
			Bullet:new( { 
				x = self.x,
				y = self.y,
				angle = self.rotation
			});
			
			self.shootSleep = 0;
		end
	end
	
	Runtime:addEventListener('enterFrame', turel)
	
	return turel
end

return Turel