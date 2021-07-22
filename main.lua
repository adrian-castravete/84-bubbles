lg = love.graphics
lg.setDefaultFilter("nearest", "nearest")

age = require("age")
local vp = require("age.viewport")
vp.setup()

local input = require("age.input")
input.setup()

clearColor = {0, 0.5, 1}

function love.update(dt)
	lg.setCanvas(vp.canvas)
	lg.clear(clearColor)

	age.update(dt)

	lg.setCanvas()
end

function love.resize(w, h)
	vp.resize(w, h)
	input.resize(w, h)
end

function love.draw()
	vp.draw()
	input.draw()
end

love.keypressed = input.keypressed
function love.keyreleased(key)
	if key == "f12" then
		love.event.quit()
		return
	end

	input.keyreleased(key)
end

love.touchpressed = input.touchpressed
love.touchreleased = input.touchreleased
love.touchmoved = input.touchmoved

local worlds = require("worlds")
local world = worlds.start()
