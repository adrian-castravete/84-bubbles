lg = love.graphics
lg.setDefaultFilter("nearest", "nearest")

age = require("age")
local vp = require("viewport")

vp.setup()

clearColor = {0, 0.5, 1}

function love.update(dt)
	lg.setCanvas(vp.canvas)
	lg.clear(clearColor)

	age.update(dt)

	lg.setCanvas()
end

function love.resize(w, h)
	vp.resize(w, h)
end

love.draw = vp.draw

local worlds = require("worlds")
local world = worlds.start()

function love.keypressed(key)
	world.keypressed(key)
end

function love.keyreleased(key)
	if key == "f12" then
		love.event.quit()
		return
	end

	world.keyreleased(key)
end
