--[[
    Original Author: https://github.com/Leandros
    Updated Author: https://github.com/jakebesworth
	MIT License
	Copyright (c) 2018 Jake Besworth
    Original Gist: https://gist.github.com/Leandros/98624b9b9d9d26df18c4
    Love.run 11.X: https://love2d.org/wiki/love.run
    Original Article, 4th algorithm: https://gafferongames.com/post/fix_your_timestep/
    Forum Discussion: https://love2d.org/forums/viewtopic.php?f=3&t=85166&start=10
    Add this code to bottom of main.lua to override love.run() for Love2D 11.X
    Tickrate is how many frames your simulation happens per second (Timestep)
    Max Frame Skip is how many frames to allow skipped due to lag of simulation outpacing (on slow PCs) tickrate
---]]

-- 1 / Ticks Per Second
TICK_RATE = 1 / 100

-- How many Frames are allowed to be skipped at once due to lag (no "spiral of death")
MAX_FRAME_SKIP = 25

-- No configurable framerate cap currently, either max frames CPU can handle (up to 1000), or vsync'd if conf.lua

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local lag = 0.0
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Cap number of Frames that can be skipped so lag doesn't accumulate
		if love.timer then lag = math.min(lag + love.timer.step(), TICK_RATE * MAX_FRAME_SKIP) end

		while lag >= TICK_RATE do
			if love.update then love.update(TICK_RATE) end
			lag = lag - TICK_RATE
		end

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())
 
			if love.draw then love.draw() end
			love.graphics.present()
		end

		-- Even though we limit tick rate and not frame rate, we might want to cap framerate at 1000 frame rate as mentioned https://love2d.org/forums/viewtopic.php?f=4&t=76998&p=198629&hilit=love.timer.sleep#p160881
		if love.timer then love.timer.sleep(0.001) end
	end
end


--require 'import'
require 'Wall'
require 'Dummy_Walker'
require 'Player'
require 'Interactable'
require 'Background'

require 'Parser'

WORLD_WIDTH = 16
WORLD_HEIGHT = 16
CHUNK_WIDTH = 16
CHUNK_HEIGHT = 16
TILE_WIDTH = 80
TILE_HEIGHT = 80

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

function isFree(x, y)
	for i=#world[x][y],1,-1 do
		if world[x][y][i].solid then
			return false
		end
	end
	return true
end

function love.load()
	math.randomseed(os.time())

	font = love.graphics.newFont("font_joystix.ttf")
	print(font:getWidth("a"), font:getHeight())
	love.graphics.setFont(font)


	world = {}
	--[[for x = 0, WORLD_WIDTH-1, 1 do
		for y = 0, WORLD_HEIGHT-1, 1 do
			generate(x, y)
			
		end
	end]]
	generate_chunk(math.floor(CHUNK_WIDTH/2), math.floor(CHUNK_HEIGHT/2))


	player = Player(math.floor(CHUNK_WIDTH/2), math.floor(CHUNK_HEIGHT/2))
	--camera = player
end


function doProperty(x, y, property_string, action_string, ...)
	if not tileIsLegal(x, y) then return end
	for i, entry in ipairs(world[x][y]) do
		if entry[property_string] then
			return entry[action_string](entry, ...)
		end
	end
end

function doOnProperty(x, y, property_string, action, ...)
	if not tileIsLegal(x, y) then return end
	for i, entry in ipairs(world[x][y]) do
		if entry[property_string] then
			return action(entry, ...)
		end
	end
end

function getMouseTileX()
	return getTileX(love.mouse.getX() -(-camera.x + love.graphics.getWidth()/2))
end

function getMouseTileY()
	return getTileY(love.mouse.getY() -(-camera.y + love.graphics.getHeight()/2))
end

function tileIsLegal(x, y)
	--print(x, WORLD_WIDTH-1)
	return world[x] ~= nil and world[x][y] ~= nil
	--return x >= 0 and x < WORLD_WIDTH and y >= 0 and y < WORLD_HEIGHT
end

local code = ""
function love.draw()





	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.push()
	love.graphics.translate(-camera.x + love.graphics.getWidth()/2, -camera.y + love.graphics.getHeight()/2)


	


	--love.graphics.setColor(100/255, 100/255, 100/255)
	--love.graphics.rectangle("fill", -TILE_WIDTH, -TILE_HEIGHT, WORLD_WIDTH * TILE_WIDTH, WORLD_HEIGHT * TILE_HEIGHT)
	
	


	love.graphics.setColor(1, 1, 1)	

	for x = getTileX(camera.x - (love.graphics.getWidth()/2))-1, getTileX(camera.x + (love.graphics.getWidth()/2))+1, 1 do
		for y = getTileY(camera.y - (love.graphics.getHeight()/2))-1, getTileY(camera.y + (love.graphics.getHeight()/2))+1, 1 do
			if tileIsLegal(x, y) then


				for i=#world[x][y],1,-1 do -- i starts at the end, and goes "down"
					local currentObject = world[x][y][i]
					currentObject:draw(TILE_WIDTH * x - TILE_WIDTH/2, TILE_HEIGHT * y - TILE_HEIGHT/2, TILE_WIDTH, TILE_HEIGHT)
				end


			end
		end	
	end
	player:draw(TILE_WIDTH * getTileX(player.x) - TILE_WIDTH/2, TILE_HEIGHT * getTileY(player.y) - TILE_HEIGHT/2, TILE_WIDTH, TILE_HEIGHT)


	love.graphics.pop()


	love.graphics.setColor(1, 0, 0)
	love.graphics.print(">" .. code, 0, 0)
	--love.graphics.setColor(0, 1, 1)
	--love.graphics.circle("line", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 5, 100)
end



function love.textinput(t)
	--code = code .. t
end


local function starts_with(str, start)
	return str:sub(1, #start) == start
end

local function ends_with(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

function split(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	source:gsub(pattern, function(value) elements[#elements + 1] =     value;  end);
	return elements
end

bind_list = {}
PARAM_SPECIFIER_CHARACTER = " "
function interpret(str)
	str = str:lower()
	str = str:gsub("\t", " ")
	str = str:gsub("%s+", " ")
	str = str:gsub("\n", "")
	str = str:gsub("\r", "")
	print(">" .. str)
	print(str:match('%(.-%)'))
	--[[if str:match('^help:.-') == 'help:' then
		local helpList = require 'help_list'
		for i, entry in ipairs(helpList) do
			print(entry)
		end
	end]]



	--[[local substr = split(str, PARAM_SPECIFIER_CHARACTER)
	if substr[1] == nil then
		return true 
	end

	if substr[1] == "reset" then
		bind_list = {}
	end

	local newStr = ""
	for i = 1, #substr, 1 do
		for input, output in pairs(bind_list) do
			if substr[i] == input then
				print("'" .. substr[i] .. "' ~> '" .. output .. "'")
				substr[i] = output
			end
		end
		newStr = newStr .. substr[i] .. PARAM_SPECIFIER_CHARACTER
	end
	newStr = newStr:sub(1, newStr:len()-1)
	print("~> " .. newStr)
	str = newStr

	print("substr = " .. substr[1])
	if substr[1] == "help" then
		local helpList = require 'help_list'
		for i, entry in ipairs(helpList) do
			print("-" .. entry)
		end
		for input, bind in pairs(bind_list) do
			print("~" .. input)
		end
	elseif substr[1] == "left" then
		player:moveLeft()
	elseif substr[1] == "right" then
		player:moveRight()
	elseif substr[1] == "up" then
		player:moveUp()
	elseif substr[1] == "down" then
		player:moveDown()
	elseif substr[1] == "bind" then
		if faulty_string(substr[1]) or faulty_string(substr[2]) then
			return false
		end
		--print(str:sub((substr[1] .. ":" .. substr[2] .. ":"):len()+1, str:len()))
		bind_list[ substr[2] ] = str:sub((substr[1] .. PARAM_SPECIFIER_CHARACTER .. substr[2] .. PARAM_SPECIFIER_CHARACTER):len()+1, str:len())
		print("'" .. substr[2] .. "' <- '" .. str:sub((substr[1] .. PARAM_SPECIFIER_CHARACTER .. substr[2] .. PARAM_SPECIFIER_CHARACTER):len()+1, str:len()) .. "'")
	else

	end]]
	return true
end

function faulty_string(str)
	return str == nil or str:len() == 0
end





local generated = 0
function generate(x, y)
	if world[x] == nil then
		world[x] = {}
	end
	if world[x][y] == nil then
		generated = generated + 1
		--print("Tile number #" .. generated .. " is located on x:" .. x .. " y:" .. y)
		world[x][y] = {}
		random = math.random(1, 50)
		if random == 1 then
			--Dummy_Walker(x, y)
			Wall(x, y)
		elseif random >= 2 and random < 15 then
			Wall(x, y)
		elseif random == 15 then
			Background(x, y)
			--[[Interactable(x, y, function(self)
				print("Goodbye!")
				self.dead = true
			end)]]
		else
			Background(x, y)
		end
		if x%300 > 200 and x%300 <= 205 and y%300 > 200 and y%300 <= 205 then
			world[x][y] = {}
			if x % 300 == 203 and y % 300 == 203 then
				Interactable(x, y, function(self)
					print("Goodbye!")
					self.interactable = false
					self.dead = true
				end)
			else
				Background(x, y)
			end
		end
	end
end

function generate_chunk(x, y)
	local rand = math.random(1, 100)
	if rand%2 == 0 then
		for _x = math.floor(x/CHUNK_WIDTH)*CHUNK_WIDTH, math.floor(x/CHUNK_WIDTH)*CHUNK_WIDTH + CHUNK_WIDTH -1, 1 do
			for _y = math.floor(y/CHUNK_HEIGHT)*CHUNK_HEIGHT, math.floor(y/CHUNK_HEIGHT)*CHUNK_HEIGHT + CHUNK_HEIGHT -1, 1 do
				if world[_x] == nil then
					world[_x] = {}
				end
				if world[_x][_y] == nil then
					world[_x][_y] = {}
				end
				if _x % 3 == 0 and _y % 3 == 0 then
					Interactable(_x, _y, function(self)
						print("Goodbye!")
						self.interactable = false
						self.dead = true
					end)
				else
					Background(_x, _y)		
				end
			end
		end
	else
		for _x = math.floor(x/CHUNK_WIDTH)*CHUNK_WIDTH, math.floor(x/CHUNK_WIDTH)*CHUNK_WIDTH + CHUNK_WIDTH -1, 1 do
			for _y = math.floor(y/CHUNK_HEIGHT)*CHUNK_HEIGHT, math.floor(y/CHUNK_HEIGHT)*CHUNK_HEIGHT + CHUNK_HEIGHT -1, 1 do
				generate(_x, _y)		
			end
		end
	end
end

backspace_down = false
backspace_down_counter = 0
insert_down = false
function love.update(dt)

	--player:update()
	if love.keyboard.isDown("backspace") then
		backspace_down_counter = backspace_down_counter + dt
		if not backspace_down or backspace_down_counter > 0.5 then
			if code:len() > 0 then
				code = code:sub(1, code:len()-1);
			end
		end
		backspace_down = true
	else
		backspace_down_counter = 0
		backspace_down = false
	end
	if love.keyboard.isDown("insert") then
		if not insert_down then
			code = code .. love.system.getClipboardText( )
		end
		insert_down = true
	else
		insert_down = false
	end
	if love.keyboard.isDown("return") then
		interpret(code)
		code = ""
	end

	for x = getTileX(camera.x - (love.graphics.getWidth()/2))-1, getTileX(camera.x + (love.graphics.getWidth()/2))+1, 1 do
		for y = getTileY(camera.y - (love.graphics.getHeight()/2))-1, getTileY(camera.y + (love.graphics.getHeight()/2))+1, 1 do
			if tileIsLegal(x, y) then


				for i=#world[x][y],1,-1 do -- i starts at the end, and goes "down"
					local currentObject = world[x][y][i]
					currentObject:update(dt)--(TILE_WIDTH * x - TILE_WIDTH/2, TILE_HEIGHT * y - TILE_HEIGHT/2, TILE_WIDTH, TILE_HEIGHT)
						
					table.remove(world[x][y], i)
					if not currentObject.dead then
						if currentObject.x and currentObject.y then
							--print(getTileX(currentObject.x))
							table.insert(world[getTileX(currentObject.x)][getTileY(currentObject.y)], currentObject)
						else
							table.insert(world[x][y], currentObject)
						end
					else
						Background(x, y)
					end
				end
			else
				generate_chunk(x, y)
			end
		end	
	end
	
	local _x = getMouseTileX()
	local _y = getMouseTileY()
	--print(tileIsLegal(_x, _y))
	--[[if love.mouse.isDown(1) and tileIsLegal(_x, _y) then
		
		world[_x][_y] = {}
		if _x == getTileX(player.x) and _y == getTileY(player.y) then
			world[_x][_y] = {player,}
		end
	end]]

	if love.keyboard.isDown('escape') then
		love.event.quit()
	end
end

function getTileX(x)
	return math.floor(x/TILE_WIDTH)+1
end
	
function getTileY(y)
	return math.floor(y/TILE_HEIGHT)+1
end