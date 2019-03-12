function Player(_x, _y)
	local Player = {
		x = (_x)*TILE_WIDTH - TILE_WIDTH/2,
		y = (_y)*TILE_HEIGHT - TILE_HEIGHT/2,
		locked = false,
		solid = true,
		speed = 2,
		rememberedPos = 0,
		standing = true,
		locked = false,
	}
	table.insert(world[_x][_y], Player)--hook into world
	camera = Player


	function Player:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		player_x = getTileX(self.x) + 1-- 1
		player_y = getTileY(self.y) + 1-- 1
		love.graphics.circle("fill", self.x , self.y , 5, 100)
	end

	function Player:moveUp()
		if self.standing then
			if not self.locked and getTileY(self.y) > 0 and isFree(getTileX(self.x), getTileY(self.y)-1) then
				self.locked = "up"
				self.rememberedPos = self.y - TILE_HEIGHT
			end
		end
	end

	function Player:moveDown()
		if self.standing then
			if not self.locked and getTileY(self.y) < WORLD_HEIGHT-1 and isFree(getTileX(self.x), getTileY(self.y)+1) then
				self.locked = "down"
				self.rememberedPos = self.y + TILE_HEIGHT
			end
		end
	end

	function Player:moveLeft()
		if self.standing then
			if not self.locked and getTileX(self.x) > 0 and isFree(getTileX(self.x)-1, getTileY(self.y)) then
				self.locked = "left"
				self.rememberedPos = self.x - TILE_WIDTH
			end
		end
	end

	function Player:moveRight()
		if self.standing then
			if not self.locked and getTileX(self.x) < WORLD_WIDTH-1 and isFree(getTileX(self.x)+1, getTileY(self.y)) then
				self.locked = "right"
				self.rememberedPos = self.x + TILE_WIDTH
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

	function Player:update()
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


		self:move()

	end

	return Player
end

