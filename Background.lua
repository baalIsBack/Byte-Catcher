function Background(_x, _y)
	local Background = {

	}
	table.insert(world[_x][_y], Background)--hook into world

	

	

	Background.initText = Object_initText
	Background:initText()

	function Background:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		local d = 0
		--love.graphics.rectangle("line", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)
		love.graphics.setColor(0.15, 0.15, 0.15, 0.7)
		font:setLineHeight(0.25)
		font:setFilter("nearest", "nearest")
		for i = 0, 4 do
			love.graphics.print(self.text[i+1], x-w/2, y-h/2 + 16*i)
		end
	end

	Background.counter = 0
	function Background:update(dt)
		Background.counter = Background.counter + dt
		if Background.counter > 0.2 then
			Background.counter = 0
			Background:initText()
		end
	end
	return Background
end