font = love.graphics.newFont("font_joystix.ttf")
print(font:getWidth("a"), font:getHeight())
love.graphics.setFont(font)
function Dummy(_x, _y)
	local Dummy = {
		solid = true,
	}
	table.insert(world[_x][_y], Dummy)--hook into world

	

	Dummy.text = {}

	function Dummy:initText()
		Dummy.text[1] = random_hex(8)
		Dummy.text[2] = random_hex(8)
		Dummy.text[3] = random_hex(8)
		Dummy.text[4] = random_hex(8)
		Dummy.text[5] = random_hex(8)
	end

	Dummy:initText()

	function Dummy:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		local d = 0
		--love.graphics.rectangle("line", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)
		love.graphics.setColor(1, 0, 0)
		for i = 0, 4 do
			love.graphics.print(self.text[i+1], x-w/2, y-h/2 + 16*i)
		end
	end

	Dummy.counter = 0
	function Dummy:update(dt)
		Dummy.counter = Dummy.counter + dt
		if Dummy.counter > 0.2 then
			Dummy.counter = 0
			Dummy:initText()
		end
	end
	return Dummy
end

