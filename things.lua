local lg = love.graphics
local img = lg.newImage("slimo.png")

age.component("sprite", {
	x = 160,
	y = 120,
	w = 16,
	h = 16,
	q = nil,
	img = nil,
})

age.component("hero", {
	parents = {"sprite"},
	color = {1, 0.5, 0},
	state = "idle",
	buttons = {},
})

local bubbleQuads = {
	0, 0, 0, 0,
	0, 1, 1, 2,
	2, 2, 1, 1,
	2, 1, 1, 1,
}
for i=1, #bubbleQuads do
	bubbleQuads[i] = lg.newQuad(bubbleQuads[i] * 8, 48, 8, 8, 128, 128)
end
age.component("hero-bubble", {
	parents = {"sprite"},
	img = img,
	q = bubbleQuads[1],
	w = 8,
	h = 8,
	headingLeft = false,
	speed = 2,
	animSpeed = 0.0625,
	step = 1,
	accumStep = 0,
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
			lg.draw(img, q, wo, ho, 0)
		else
			lg.draw(img, wo, ho, 0)
		end
	else
		lg.rectangle("fill", wo, ho, w, h)
	end
	lg.setColor(1, 1, 1)
	lg.pop()
end)

age.system("hero-bubble", function (e, dt)
	e.accumStep = e.accumStep + dt
	if e.accumStep > e.animSpeed then
		e.accumStep = e.accumStep - e.animSpeed
		e.step = e.step + 1
		e.x = e.x + e.speed
		if e.step > #bubbleQuads then
			e.destroy = true
			return
		end
		e.q = bubbleQuads[e.step]
	end
end)

age.system("hero", function(e, dt)
	local bs = e.buttons
	local v, c = 16 * dt, 0
	local dx, dy = 0, 0
	if bs.left then dx = -1 c = c + 1 end
	if bs.up then dy = -1 c = c + 1 end
	if bs.right then dx = 1 c = c + 1 end
	if bs.down then dy = 1 c = c + 1 end
	if c > 1 then
		v = v * 0.707
	end
	e.x = e.x + dx * v
	e.y = e.y + dy * v
end)

age.receive("hero", "pressed", function (e, b)
	e.buttons[b] = true
	if b == "jump" then
		age.entity("hero-bubble", {
			x = e.x + 8,
			y = e.y,
		})
	end
end)

age.receive("hero", "released", function (e, b)
	e.buttons[b] = false
end)