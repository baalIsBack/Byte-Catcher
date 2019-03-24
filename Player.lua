function Player(_x, _y)
	local Player = {
		name = "Player",
		x = (_x)*TILE_WIDTH - TILE_WIDTH/2,
		y = (_y)*TILE_HEIGHT - TILE_HEIGHT/2,
		locked = false,
		solid = false,
		speed = 2,
		rememberedPos = 0,
		standing = true,
		locked = false,
		energy = 50,
		direction = 0,--WIP draw rotation on graphics 0 means right and 0.5 means up
	}
	table.insert(world[_x][_y], Player)--hook into world
	camera = Player


	function Player:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		player_x = getTileX(self.x) + 1-- 1
		player_y = getTileY(self.y) + 1-- 1
		love.graphics.rectangle("line", self.x-w/2 , self.y-h/2 , w, h)
	end

	function Player:moveUp()
		self.direction = 0.5
		if self.standing then
			if self.energy > 0 and not self.locked and not doOnProperty(getTileX(self.x), getTileY(self.y)-1, "solid", function() return true end) then
				self.locked = "up"
				self.rememberedPos = self.y - TILE_HEIGHT
				self.energy = self.energy - 1
			end
		end
	end

	function Player:moveDown()
		self.direction = 1.5
		if self.standing then
			if self.energy > 0 and not self.locked and not doOnProperty(getTileX(self.x), getTileY(self.y)+1, "solid", function() return true end) then
				self.locked = "down"
				self.rememberedPos = self.y + TILE_HEIGHT
				self.energy = self.energy - 1
			end
		end
	end

	function Player:moveLeft()
		self.direction = 1.0
		if self.standing then
			if self.energy > 0 and not self.locked and not doOnProperty(getTileX(self.x)-1, getTileY(self.y), "solid", function() return true end) then
				self.locked = "left"
				self.rememberedPos = self.x - TILE_WIDTH
				self.energy = self.energy - 1
			end
		end
	end

	function Player:moveRight()
		self.direction = 0.0
		if self.standing then
			if self.energy > 0 and not self.locked and not doOnProperty(getTileX(self.x)+1, getTileY(self.y), "solid", function() return true end) then--isFree(getTileX(self.x)+1, getTileY(self.y)) then
				self.locked = "right"
				self.rememberedPos = self.x + TILE_WIDTH
				self.energy = self.energy - 1
			end
		end
	end

	function Player:move()
		if self.locked == "up" then
			self.standing = false
			self.y = self.y - (self.speed/(TICK_RATE))/TILE_HEIGHT
			if self.y < self.rememberedPos then
				self.y = self.rememberedPos
				self.locked = false
				self.standing = true
			end
		elseif self.locked == "left" then
			self.standing = false
			self.x = self.x - (self.speed/(TICK_RATE))/TILE_WIDTH
			if self.x < self.rememberedPos then
				self.x = self.rememberedPos
				self.locked = false
				self.standing = true
			end
		elseif self.locked == "down" then
			self.standing = false
			self.y = self.y + (self.speed/(TICK_RATE))/TILE_HEIGHT
			if self.y > self.rememberedPos then
				self.y = self.rememberedPos
				self.locked = false
				self.standing = true
			end
		elseif self.locked == "right" then
			self.standing = false
			self.x = self.x + (self.speed/(TICK_RATE))/TILE_WIDTH
			if self.x > self.rememberedPos then
				self.x = self.rememberedPos
				self.locked = false
				self.standing = true
			end
		end
	end

	function Player:interact()
		--[[if 	self.direction == 0.0 then
			doProperty(getTileX(self.x) + 1, getTileY(self.y), "interactable", "interact")
			--if tileIsLegal(getTileX(self.x) + 1, getTileY(self.y)) and world[getTileX(self.x) + 1][getTileY(self.y)].interactable then
			--	world[getTileX(self.x) + 1][getTileY(self.y)]:interact()
			--end
		elseif 	self.direction == 0.5 then
			doProperty(getTileX(self.x), getTileY(self.y) - 1, "interactable", "interact")
			--if tileIsLegal(getTileX(self.x), getTileY(self.y) - 1) and world[getTileX(self.x)][getTileY(self.y) - 1].interactable then
			--	world[getTileX(self.x)][getTileY(self.y) - 1]:interact()
			--end
		elseif 	self.direction == 1.0 then
			doProperty(getTileX(self.x) - 1, getTileY(self.y), "interactable", "interact")
			--if tileIsLegal(getTileX(self.x) - 1, getTileY(self.y)) and world[getTileX(self.x) - 1][getTileY(self.y)].interactable then
			--	world[getTileX(self.x) - 1][getTileY(self.y)]:interact()
			--end
		elseif 	self.direction == 1.5 then
			doProperty(getTileX(self.x), getTileY(self.y) + 1, "interactable", "interact")
			--if tileIsLegal(getTileX(self.x), getTileY(self.y) + 1) and world[getTileX(self.x)][getTileY(self.y) + 1].interactable then
			--	world[getTileX(self.x)][getTileY(self.y) + 1]:interact()
			--end

		else
			print("Wrong direction " .. self.direction)
		end]]
		doProperty(getTileX(self.x), getTileY(self.y), "interactable", "interact")
	end

	DEBUG_cooldown = 0
	function Player:update(dt)
		local dir = 0
		if love.keyboard.isDown("w") then
			self:moveUp()
			dir = dir + 1
		end
		if love.keyboard.isDown("a") then
			self:moveLeft()
			dir = dir + 1
		end
		if love.keyboard.isDown("s") then
			self:moveDown()
			dir = dir + 1
		end
		if love.keyboard.isDown("d") then
			self:moveRight()
			dir = dir + 1
		end
		if dir > 1 and self.standing then
			self.locked = false
		end
		if love.keyboard.isDown("e") then
			self:interact()
		end
		if love.keyboard.isDown("c") then
			print(self.energy)
		end


		DEBUG_cooldown = DEBUG_cooldown - dt
		if love.keyboard.isDown("left") and DEBUG_cooldown < 0 then
			self.x = self.x-TILE_WIDTH
			DEBUG_cooldown = 0.1
			print(getTileX(self.x), getTileY(self.y))
		end
		if love.keyboard.isDown("right") and DEBUG_cooldown < 0 then
			self.x = self.x+TILE_WIDTH
			DEBUG_cooldown = 0.1
			print(getTileX(self.x), getTileY(self.y))
		end
		if love.keyboard.isDown("up") and DEBUG_cooldown < 0 then
			self.y = self.y-TILE_HEIGHT
			DEBUG_cooldown = 0.1
			print(getTileX(self.x), getTileY(self.y))
		end
		if love.keyboard.isDown("down") and DEBUG_cooldown < 0 then
			self.y = self.y+TILE_HEIGHT
			DEBUG_cooldown = 0.1
			print(getTileX(self.x), getTileY(self.y))
		end

		self:move()

	end

	return Player
end

