local lg = love.graphics
local spritesheet = require("age.spritesheet")
local sprites = spritesheet.build {
	fileName = "slimo.png",
	quadGen = {
		bubble = {
			w = 8,
			h = 8,
			y = 48,
			n = 3,
		}
	}
}
sprites.bubbleReel = {
	1, 1, 1, 1,
	1, 2, 2, 3,
	3, 3, 2, 2,
	3, 2, 2, 2,
}

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
	hf = false,
})

age.component("hero-bubble", {
	parents = {"sprite"},
	img = sprites.image,
	reel = sprites.quads.bubble,
	q = 1,
	w = 8,
	h = 8,
	hf = false,
	speed = 32,
	animSpeed = 0.625,
})

age.system("sprite", function (e)
	local c = e.color
	local img = e.img
	local w, h = e.w, e.h
	local wo, ho = -w*0.5, -h*0.5
	local hf = e.hf and -1 or 1
	local vf = e.vf and -1 or 1

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
		if e.reel then
			lg.draw(img, e.reel[e.q or 1], wo * hf, ho * vf, 0, hf, vf)
		else
			lg.draw(img, wo * hf, ho * vf, 0, hf, vf)
		end
	else
		lg.rectangle("fill", wo, ho, w, h)
	end
	lg.setColor(1, 1, 1)
	lg.pop()
end)

local function spawnHeroBubble(h)
	local dir = h.hf and -1 or 1
	local e = age.entity("hero-bubble", {
		x = h.x + dir * 8,
		y = h.y,
		hf = h.hf,
	})
	age.tween(e.animSpeed, function (p, dt)
		local v = math.floor(p / e.animSpeed * #sprites.bubbleReel)
		e.q = sprites.bubbleReel[v + 1]
		return dt
	end, function ()
		e.destroy = true
	end)
end

age.system("hero-bubble", function (e, dt)
	local dir = e.hf and -1 or 1
	e.x = e.x + e.speed * dt * dir
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
		spawnHeroBubble(e)
	end
	if b == "left" then
		e.hf = true
	end
	if b == "right" then
		e.hf = false
	end
end)

age.receive("hero", "released", function (e, b)
	e.buttons[b] = false
end)
