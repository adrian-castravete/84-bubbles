require("things")

local function start()
	age.entity("hero")

	return {
		pressed = function (b)
			age.send("hero", "pressed", b)
		end,
		released = function (b)
			age.send("hero", "released", b)
		end,
	}
end

return {
	start = start,
}