local lg = love.graphics

local width = 320
local height = 240
local pixelScaleX = 1
local pixelScaleY = 1
local fitScreen = false

local outputWidth = 960
local outputHeight = 720
local internalCanvas = nil

local viewport = {
	offsetX = 0,
	offsetY = 0,
	scale = 2,
}

function viewport.resize(w, h)
	local v = viewport
	outputWidth = w
	outputHeight = h
	v.scale = math.max(1, math.floor(math.min(w / (width * pixelScaleX), h / (height * pixelScaleY))))
	v.offsetX = math.floor((w - width * v.scale * pixelScaleX) * 0.5)
	v.offsetY = math.floor((h - height * v.scale * pixelScaleY) * 0.5)
end

function viewport.draw()
	if not internalCanvas then
		return
	end
	
	local v = viewport

	lg.push()
	lg.setDefaultFilter("linear", "linear", 4)
	lg.translate(v.offsetX, v.offsetY)
	lg.scale(v.scale * pixelScaleX, v.scale * pixelScaleY)
	lg.draw(internalCanvas, 0, 0)
	lg.pop()

	lg.setCanvas(internalCanvas)
	lg.setDefaultFilter("nearest", "nearest")
	lg.clear(0, 0, 0)
	lg.setCanvas()
end

function viewport.setup(config)
	local config = config or {}
	
	width = config.width or width
	height = config.height or height
	pixelScaleX = config.pixelScaleX or 1
	pixelScaleY = config.pixelScaleY or 1
	fitScreen = config.fitScreen or false

	viewport.resize(lg.getDimensions())

	internalCanvas = lg.newCanvas(width, height)
	viewport.canvas = internalCanvas
end

return viewport