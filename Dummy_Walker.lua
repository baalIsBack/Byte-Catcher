function Dummy_Walker(_x, _y)
	local Dummy_Walker = {
		x = (_x)*TILE_WIDTH - TILE_WIDTH/2,
		y = (_y)*TILE_HEIGHT - TILE_HEIGHT/2,
		locked = false,
		solid = true,
		speed = 0.7,
		rememberedPos = 0,
		standing = true,
		locked = false,
	}
	table.insert(world[_x][_y], Dummy_Walker)--hook into world


	function Dummy_Walker:draw(x, y, w, h)
		love.graphics.setColor(1, 0, 0, 0.5)
		Dummy_Walker_x = getTileX(self.x) + 1-- 1
		Dummy_Walker_y = getTileY(self.y) + 1-- 1
		love.graphics.circle("fill", self.x , self.y , 30, 100)
	end

	function Dummy_Walker:moveUp()
		if self.standing then
			if not self.locked and getTileY(self.y) > 0 and isFree(getTileX(self.x), getTileY(self.y)-1) then
				self.locked = "up"
				self.rememberedPos = self.y - TILE_HEIGHT
			end
		end
	end

	function Dummy_Walker:moveDown()
		if self.standing then
			if not self.locked and getTileY(self.y) < WORLD_HEIGHT-1 and isFree(getTileX(self.x), getTileY(self.y)+1) then
				self.locked = "down"
				self.rememberedPos = self.y + TILE_HEIGHT
			end
		end
	end

	function Dummy_Walker:moveLeft()
		if self.standing then
			if not self.locked and getTileX(self.x) > 0 and isFree(getTileX(self.x)-1, getTileY(self.y)) then
				self.locked = "left"
				self.rememberedPos = self.x - TILE_WIDTH
			end
		end
	end

	function Dummy_Walker:moveRight()
		if self.standing then
			if not self.locked and getTileX(self.x) < WORLD_WIDTH-1 and isFree(getTileX(self.x)+1, getTileY(self.y)) then
				self.locked = "right"
				self.rememberedPos = self.x + TILE_WIDTH
			end
		end
	end

	function Dummy_Walker:move()
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

	function Dummy_Walker:update()
		local random_dir = math.random(1, 500)
		if random_dir == 1 then
			self:moveLeft()
		end
		if random_dir == 2 then
			self:moveUp()
		end
		if random_dir == 3 then
			self:moveDown()
		end
		if random_dir == 4 then
			self:moveRight()
		end

		self:move()

	end

	return Dummy_Walker
end

