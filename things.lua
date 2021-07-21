local lg = love.graphics

age.component("sprite", {
	x = 160,
	y = 120,
	w = 16,
	h = 16,
	q = nil,
	img = nil,
})

age.system("sprite", function (e)
	local c = e.color
	local img = e.img
	local w, h = e.w, e.h
	local wo, ho = -w*0.5, -h*0.5

	if not c then
		c = {1, 1, 1}
		if not img then
			c = {math.random(), math.random(), math.random()}
		end
	end

	lg.push()
	lg.translate(e.x, e.y)
	lg.setColor(c)
	if img then
		local q = e.q
		if q then
			lg.draw(img, q, wo, ho)
		else
			lg.draw(img, wo, ho)
		end
	else
		lg.rectangle("fill", wo, ho, w, h)
	end
	lg.setColor(1, 1, 1)
	lg.pop()
end)

age.component("hero", {
	parents = {"sprite"},
	color = {1, 0.5, 0},
})

age.receive("hero", "keypressed", function (e, key)
	print("pressed " .. key)
end)

age.receive("hero", "keyreleased", function (e, key)
	print("released " .. key)
end)
