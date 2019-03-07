function Player()
	local Player = {}
	function Player:draw(x, y, w, h)
		love.graphics.push()

		love.graphics.setColor(1, 1, 1)
		local d = 10
		love.graphics.rectangle("line", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)

		love.graphics.pop()
	end

	function Player:update()
		if love.keyboard.isDown("w") then
			self.y = self.y - 1
		end
		if love.keyboard.isDown("a") then
			self.x = self.x - 1
		end
		if love.keyboard.isDown("s") then
			self.y = self.y + 1
		end
		if love.keyboard.isDown("d") then
			self.x = self.x + 1
		end
	end

	return Player
end

