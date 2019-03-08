function Dummy(_x, _y)
	local Dummy = {}
	table.insert(world[_x][_y], Dummy)--hook into world
	function Dummy:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		local d = 0
		love.graphics.rectangle("fill", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)
	end

	function Dummy:update()

	end

	return Dummy
end

