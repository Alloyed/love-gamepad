local json = require 'dkjson'
local data = require 'love-gamepad.prompts.data'
local atlas = {}
local atlas_mt = {__index = atlas}

function atlas.new(sheetname, mapname)
	local sheet
	if sheetname then
		sheet = love.graphics.newImage(sheetname)
	else
		local data = love.filesystem.newFileData(data.atlas, "atlas.png", 'base64')
		sheet = love.graphics.newImage(data)
	end

	local map_str
	if mapname then
		map_str = assert(love.filesystem.read(mapname))
	else
		map_str = data.atlas_map
	end

	local map = json.decode(map_str)
	assert(sheet)
	assert(map)
	return setmetatable({
		sheet = sheet,
		map = map.frames,
		quads = {}
	}, atlas_mt)
end

function atlas:get(image)
	if not self.quads[image] then
		local data = self.map[image]
		if data == nil then
			return false
		end
		--assert(data ~= nil, "No such sprite: " .. tostring(image))
		assert(not data.trimmed, "trimmed sprites are unsupported.")
		assert(not data.rotated, "rotated sprites are unsupported.")
		local frame = data.frame
		local q = love.graphics.newQuad(frame.x, frame.y,
		                                frame.w, frame.h,
										self.sheet:getDimensions())

		self.quads[image] = q
	end
	return self.sheet, self.quads[image]
end

function atlas:getDimensions(image)
	local data = self.map[image]
	assert(data ~= nil, "No such sprite: " .. tostring(image))
	return data.frame.w, data.frame.h
end

return atlas
