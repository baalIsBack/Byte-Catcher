function random_hex(length)
	local result = ""
	for i = 1, length, 1 do
		local n = math.random(0, 15)
		if n < 10 then
			result = result .. n
		else
			if 	n == 10 then
				result = result .. 'a'
			elseif 	n == 11 then
				result = result .. 'b'
			elseif 	n == 12 then
				result = result .. 'c'
			elseif 	n == 13 then
				result = result .. 'd'
			elseif 	n == 14 then
				result = result .. 'e'
			elseif 	n == 15 then
				result = result .. 'f'
			end
		end
	end
	return result
end

function Object_initText(self)
	self.text = {}
	self.text[1] = random_hex(8)
	self.text[2] = random_hex(8)
	self.text[3] = random_hex(8)
	self.text[4] = random_hex(8)
	self.text[5] = random_hex(8)
end