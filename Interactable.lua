function Interactable(_x, _y, _interaction)
	local Interactable = {
		interactable = true,
		solid = false,
	}


	table.insert(world[_x][_y], Interactable)--hook into world
	function Interactable:initText()
		Interactable.text = {}
		Interactable.text[1] = random_hex(8)
		Interactable.text[2] = random_hex(8)
		Interactable.text[3] = random_hex(8)
		Interactable.text[4] = random_hex(8)
		Interactable.text[5] = random_hex(8)
	end
	Interactable:initText()

	function Interactable:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		local d = 0
		--love.graphics.rectangle("line", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)
		love.graphics.setColor(0.3, 0.3, 0.3)
		font:setLineHeight(0.25)
		font:setFilter("nearest", "nearest")
		for i = 0, 4 do
			love.graphics.print(self.text[i+1], x-w/2, y-h/2 + 16*i)
		end
	end

	Interactable.counter = 0
	function Interactable:update(dt)
		Interactable.counter = Interactable.counter + dt
		if Interactable.counter > 0.2 then
			Interactable.counter = 0
			Interactable:initText()
		end
	end

	function Interactable:interact()

	end

	Interactable.interact = _interaction
	if not Interactable.interact then
		function Interactable:interact()
		end
	end

	return Interactable
end

