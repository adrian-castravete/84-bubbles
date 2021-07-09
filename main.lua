lg = love.graphics
lg.setDefaultFilter("nearest", "nearest")

Age = require("age")
VP = require("viewport")

VP.setup()

clearColor = {0, 1/3, 2/3}

function love.update(dt)
	lg.setCanvas(VP.canvas)
	lg.clear(clearColor)
	Age.update(dt)
	lg.setCanvas()
end

function love.resize(w, h)
	VP.resize(w, h)
end

love.draw = VP.draw

function love.keyreleased(key)
	if key == "f12" then
		love.event.quit()
	end
end

local worlds = require("worlds")
worlds.start()
