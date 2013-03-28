local cell_size = 9
local border_size = 1

local grid = {}
local grid_buffer = {}

local running = false

local grid_width, grid_height

function love.load()
	grid_width = math.floor(love.graphics.getWidth() / (cell_size + border_size))
	grid_height = math.floor(love.graphics.getHeight() / (cell_size + border_size))
	print(grid_width)
	print(grid_height)
	for x = 1, grid_width do
		table.insert(grid, {})
		table.insert(grid_buffer, {})
		for _ = 1, grid_height do
			table.insert(grid[x], false)
			table.insert(grid_buffer[x], false)
		end
	end
end

function love.draw()
	if running then
		gol_tick()
	end
	for x, column in ipairs(grid) do
		for y, cell in ipairs(column) do
			local color
			if cell then
				color = {255, 0, 0}
			else
				color = {50, 50, 50}
			end
			love.graphics.setColor(color)
			love.graphics.rectangle(
				"fill",
				(x - 1) * (cell_size + border_size),
				(y - 1) * (cell_size + border_size),
				cell_size,
				cell_size
			)
		end
	end
end

function love.update()
end

function love.mousepressed(x, y, key)
	if key == "l" and not running then
		local grid_x, grid_y = posToGrid(x, y)
		grid[grid_x][grid_y] = not grid[grid_x][grid_y]
	end
end

function love.keypressed(key)
	if key == 'm' then
		running = not running
	end
	if key == 'g' then
		local grid_x, grid_y = getMouseGridPos()
		local glider = {
			{true, true, true},
			{false, false, true},
			{false, true, false}
		}
		insert(glider, grid_x, grid_y)
	end
	if key == 'f' then
		local grid_x, grid_y = getMouseGridPos()
		local f_pentomino = {
			{false, true, true},
			{true, true, false},
			{false, true, false}
		}
		insert(f_pentomino, grid_x, grid_y)
	end
	if key == 'r' then
		for x, column in ipairs(grid) do
			for y, _ in ipairs(column) do
				grid[x][y] = false
			end
		end
	end
	if key == 'i' then
		local grid_x, grid_y = getMouseGridPos()
		local infinite = {
			{true, true, true, false, true},
			{true, false, false, false, false},
			{false, false, false, true, true},
			{false, true, true, false, true},
			{true, false, true, false, true}
		}
		insert(infinite, grid_x, grid_y)
	end
end

function insert(figure, grid_x, grid_y)
	for y, row in ipairs(figure) do
		for x, cell in ipairs(row) do
			grid[grid_x + x - 1][grid_y + y - 1] = cell
		end
	end
end

function getMouseGridPos()
	local x, y = love.mouse.getPosition()
	return posToGrid(x, y)
end

function posToGrid(x, y)
	local grid_x = math.ceil(x / (cell_size + border_size))
	local grid_y = math.ceil(y / (cell_size + border_size))
	return grid_x, grid_y
end

function gol_tick()
	for x, column in ipairs(grid) do
		for y, cell in ipairs(column) do
			local neighbours = 0
			if x > 1 then
				neighbours = neighbours + (grid[x-1][y] and 1 or 0)
				if y > 1 then
					neighbours = neighbours + (grid[x-1][y-1] and 1 or 0)
				end
				if y < grid_width then
					neighbours = neighbours + (grid[x-1][y+1] and 1 or 0)
				end
			end
			if x < grid_width then
				neighbours = neighbours + (grid[x+1][y] and 1 or 0)
				if y > 1 then
					neighbours = neighbours + (grid[x+1][y-1] and 1 or 0)
				end
				if y < grid_width then
					neighbours = neighbours + (grid[x+1][y+1] and 1 or 0)
				end
			end
			if y > 1 then
				neighbours = neighbours + (grid[x][y-1] and 1 or 0)
			end
			if y < grid_width then
				neighbours = neighbours + (grid[x][y+1] and 1 or 0)
			end

			local new_cell
			if neighbours == 3 then
				new_cell = true
			elseif cell == true and neighbours == 2 then
				new_cell = true
			else
				new_cell = false
			end
			grid_buffer[x][y] = new_cell
		end
	end
	grid, grid_buffer = grid_buffer, grid
end
