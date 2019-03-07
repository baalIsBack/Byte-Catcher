function World()
	local World = {}
	World.x = 100
	World.y = 100

	function World:draw()
		love.graphics.circle("line", self.x, self.y, 5, 30)
	end

	function World:update()

	end

	return World
end

