function Wall(_x, _y)
	local Wall = {
		solid = true,
	}
	table.insert(world[_x][_y], Wall)--hook into world

	

	

	Wall.initText = Object_initText
	Wall:initText()

	function Wall:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		local d = 0
		--love.graphics.rectangle("line", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)
		love.graphics.setColor(1, 0, 0)
		font:setLineHeight(0.25)
		font:setFilter("nearest", "nearest")
		for i = 0, 4 do
			love.graphics.print(self.text[i+1], x-w/2, y-h/2 + 16*i)
		end
	end

	Wall.counter = 0
	function Wall:update(dt)
		Wall.counter = Wall.counter + dt
		if Wall.counter > 0.2 then
			Wall.counter = 0
			--Wall:initText()
		end
	end
	return Wall
end