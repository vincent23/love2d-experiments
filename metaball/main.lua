local balls = {}
local v = {}
local width = 0
local height = 0

local enable_strobo = false

function love.load()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	for i=1,40 do
		balls[i] = {math.random(0,width), math.random(0,height)}
		local v_ges = math.random(200,400)
		local v_x = math.random(0,v_ges)
		local v_y = math.sqrt(math.pow(v_ges,2) - math.pow(v_x,2))
		v[i] = {v_x, v_y}
	end
	effect = love.graphics.newPixelEffect [[
	uniform float width;
	uniform float height;
	uniform float schwelle;
	uniform vec2 balls[40];
	uniform float time;
	float metaball(vec2 center, vec2 point) {
		vec2 v = point-center;
		return 1/dot(v, v);
	}
	vec4 effect(vec4 color, Image texture, vec2 tex_c, vec2 coord) {
		float val = 0;
		val = val + metaball(balls[0],coord);
		val = val + metaball(balls[1],coord);
		val = val + metaball(balls[2],coord);
		val = val + metaball(balls[3],coord);
		val = val + metaball(balls[4],coord);
		val = val + metaball(balls[5],coord);
		val = val + metaball(balls[6],coord);
		val = val + metaball(balls[7],coord);
		val = val + metaball(balls[8],coord);
		val = val + metaball(balls[9],coord);
		val = val + metaball(balls[10],coord);
		val = val + metaball(balls[11],coord);
		val = val + metaball(balls[12],coord);
		val = val + metaball(balls[13],coord);
		val = val + metaball(balls[14],coord);
		val = val + metaball(balls[15],coord);
		val = val + metaball(balls[16],coord);
		val = val + metaball(balls[17],coord);
		val = val + metaball(balls[18],coord);
		val = val + metaball(balls[19],coord);
		val = val + metaball(balls[20],coord);
		val = val + metaball(balls[21],coord);
		val = val + metaball(balls[22],coord);
		val = val + metaball(balls[23],coord);
		val = val + metaball(balls[24],coord);
		val = val + metaball(balls[25],coord);
		val = val + metaball(balls[26],coord);
		val = val + metaball(balls[27],coord);
		val = val + metaball(balls[28],coord);
		val = val + metaball(balls[29],coord);
		val = val + metaball(balls[30],coord);
		val = val + metaball(balls[31],coord);
		val = val + metaball(balls[32],coord);
		val = val + metaball(balls[33],coord);
		val = val + metaball(balls[34],coord);
		val = val + metaball(balls[35],coord);
		val = val + metaball(balls[36],coord);
		val = val + metaball(balls[37],coord);
		val = val + metaball(balls[38],coord);
		val = val + metaball(balls[39],coord);
		vec4 bar;
		if (val < schwelle) {
			val = val / schwelle;
			bar = vec4(0.8*(1-coord.x/width),0.8*(1-coord.y/height),0.3*val,1.0);
		}
		else {
			bar = vec4(0.8*coord.x/width,0.8*coord.y/height,0,1);
		}
		float foo = mod(time,1);
		if (foo < 0.1) {
			return bar + vec4(vec3(foo*3.14*50), 1.0);
		}
		return bar;
	}
	]]
end


function love.draw()
	love.graphics.setPixelEffect(effect)
	love.graphics.rectangle('fill', 0, 0, width, height)
	love.graphics.setPixelEffect()
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 20)
end

local x, y
x = 0
y = 0
schwelle = 0.002

local paused = false
local time = 0

function love.update(dt)
	time = time + dt
	if paused then
		return
	end
	for i=1,#balls do
		for j=1,#balls do
			if i ~= j then
				local left, right
				local bottom, top
				if balls[i][1] < balls[j][1] then
					left = i
					right = j
				else
					left = j
					right = i
				end
				if balls[i][2] < balls[j][2] then
					bottom = i
					top = j
				else
					bottom = j
					top = i
				end

				local x = balls[right][1]-balls[left][1]
				local y = balls[right][2]-balls[left][2]
				local r = math.sqrt(math.pow(x,2) + math.pow(y,2))
				local f = 200000/math.pow(r,2) * dt
				local fx = x/r*f
				local fy = y/r*f
				balls[left][1] = balls[left][1] - fx
				balls[right][1] = balls[right][1] + fx
				balls[left][2] = balls[left][2] - fy
				balls[right][2] = balls[right][2] + fy
			end
		end
	end

	for i=1,#balls do
		balls[i][1] = balls[i][1] + v[i][1] * dt
		if (balls[i][1] < 10 and v[i][1] < 0) or (balls[i][1] >= width -10 and v[i][1] > 0) then
			v[i][1] = v[i][1] * (-1)
		end
		balls[i][2] = balls[i][2] + v[i][2] * dt
		if (balls[i][2] < 10 and v[i][2] < 0) or (balls[i][2] >= height-10 and v[i][2] > 0) then
			v[i][2] = v[i][2] * (-1)
		end
	end
	effect:send("schwelle", schwelle)
	effect:send("balls", unpack(balls))
	effect:send("width", width)
	effect:send("height", height)
	if enable_strobo then
		effect:send("time", time)
	end
end

function love.keypressed(key)
	if key == "p" then
		paused = not paused
	end
end
