function Dummy()
	local Dummy = {}
	function Dummy:draw(x, y, w, h)
		love.graphics.setColor(1, 1, 1)
		local d = 10
		love.graphics.rectangle("line", (x-w/2)+d, (y-h/2)+d, w-d*2, h-d*2)
	end

	function Dummy:update()

	end

	return Dummy
end

