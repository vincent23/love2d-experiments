function perlin(width, height, octaves, persistance)
	local perlinNoise = {}
	for x = 1, width do
		table.insert(perlinNoise, {})
	end
	return perlin_reuse(perlinNoise, width, height, octaves, persistance)
end

function interpolate(x0, x1, alpha)
	return interpolate_linear(x0, x1, alpha)
end

function interpolate_linear(x0, x1, alpha)
	return x0 * (1 - alpha) + alpha * x1
end

function interpolate_cos(x0, x1, alpha)
	local alpha2 = (1-math.cos(alpha*math.pi))/2
	return (x0*(1-alpha2) + x1*alpha2)
end

function perlin_reuse(perlinNoise, width, height, octaves, persistance)
	local noise = {}
	for x = 1, width do
		table.insert(noise, {})
		for y = 1, height do
			table.insert(noise[x], math.random())
			perlinNoise[x][y] = 0
		end
	end

	local sample_x0 = {}
	local sample_x1 = {}
	local sample_y0 = {}
	local sample_y1 = {}
	local horizontal_blend = {}
	local vertical_blend = {}
	for oct = 1, octaves do
		local samplePeriod = 2^oct
		local sampleFrequency = 1 / samplePeriod
		table.insert(sample_x0, {})
		table.insert(sample_x1, {})
		table.insert(sample_y0, {})
		table.insert(sample_y1, {})
		table.insert(horizontal_blend, {})
		table.insert(vertical_blend, {})
		for x = 0, #perlinNoise-1 do
			table.insert(sample_x0[oct], math.floor(x / samplePeriod) * samplePeriod)
			table.insert(sample_x1[oct], (sample_x0[oct][x+1] + samplePeriod) % #noise)
			table.insert(horizontal_blend[oct], (x - sample_x0[oct][x+1]) * sampleFrequency)
		end
		for y = 0, #perlinNoise[1]-1 do
			table.insert(sample_y0[oct], math.floor(y /samplePeriod) * samplePeriod)
			table.insert(sample_y1[oct], (sample_y0[oct][y+1] + samplePeriod) % #noise[1])
			table.insert(vertical_blend[oct], (y - sample_y0[oct][y+1]) * sampleFrequency)
		end
	end

	local amplitude = 1.0
	local totalAmplitude = 0.0
	for oct = octaves, 1, -1 do
		amplitude = amplitude * persistance
		totalAmplitude = totalAmplitude + amplitude
		for x = 1, #perlinNoise do
			for y = 1, #perlinNoise[x] do
				local top = interpolate(noise[sample_x0[oct][x]+1][sample_y0[oct][y]+1], noise[sample_x1[oct][x]+1][sample_y0[oct][y]+1], horizontal_blend[oct][x])
				local bottom = interpolate(noise[sample_x0[oct][x]+1][sample_y1[oct][y]+1], noise[sample_x1[oct][x]+1][sample_y1[oct][y]+1], horizontal_blend[oct][x])
				perlinNoise[x][y] = perlinNoise[x][y] + interpolate(top, bottom, vertical_blend[oct][y]) * amplitude
			end
		end
	end

	for x = 1, #perlinNoise do
		for y = 1, #perlinNoise[x] do
			perlinNoise[x][y] = perlinNoise[x][y] / totalAmplitude
		end
	end

	return perlinNoise
end
