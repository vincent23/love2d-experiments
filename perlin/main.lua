require('perlin')
local time, width, height = 0, 0, 0

local test_img
local octaves = 6
local persistance = 0.7
local perlinNoise

function love.load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	regen_perlin()
end

function love.draw()
	love.graphics.draw(test_img, 0, 0)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
end

function love.update(dt)
	time = time + dt
end

function regen_perlin()
	local start = love.timer.getMicroTime()
	if perlinNoise ~= nil then
		perlin_reuse(perlinNoise, width, height, octaves, persistance)
	else
		perlinNoise = perlin(width, height, octaves, persistance)
	end
	local img_data = love.image.newImageData(width, height)
	for x= 1, width do
		for y = 1, height do
			img_data:setPixel(x-1, y-1, perlinNoise[x][y]*255, 0, 0, 255)
		end
	end
	test_img = love.graphics.newImage(img_data)
	local end_t = love.timer.getMicroTime()
	print("Regenerated in " .. end_t-start .. " seconds")
end

function love.keypressed(key)
	if key == "up" then
		octaves = octaves + 1
		regen_perlin()
		print("Octaves: " .. octaves)
	elseif key == "down" then
		octaves = octaves - 1
		regen_perlin()
		print("Octaves: " .. octaves)
	elseif key == "left" then
		persistance = persistance - 0.1
		regen_perlin()
		print("Persistance: " .. persistance)
	elseif key == "right" then
		persistance = persistance + 0.1
		regen_perlin()
		print("Persistance: " .. persistance)
	elseif key == "r" then
		regen_perlin()
	end
end
