require("things")

local function start()
	age.entity("hero")

	return {
		keypressed = function (key)
			age.send("hero", "keypressed", key)
		end,
		keyreleased = function (key)
			age.send("hero", "keyreleased", key)
		end,
	}
end

return {
	start = start,
}
