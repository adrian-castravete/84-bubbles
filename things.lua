local lg = love.graphics
local spritesheet = require("age.spritesheet")
local sprites = spritesheet.build {
	fileName = "slimo.png",
	quadGen = {
		heroBig = {
			w = 16,
			h = 24,
			n = 5,
		},
		heroMedium = {
			w = 16,
			h = 16,
			y = 24,
			n = 5,
		},
		heroSmall = {
			w = 16,
			h = 8,
			y = 40,
			n = 3,
		},
		bubble = {
			w = 8,
			h = 8,
			y = 48,
			n = 3,
		},
	}
}
sprites.reels = {
	heroIdle = { 1 },
	heroBigWalk = { 1, 2, 3, 4, 5 },
	heroMediumWalk = { 1, 2, 3, 4, 5 },
	heroSmallWalk = { 1, 2, 3, },
	bubble = {
		1, 1, 1, 1,
		1, 2, 2, 3,
		3, 3, 2, 2,
		3, 2, 2, 2,
	}
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
	img = sprites.image,
	quads = sprites.quads.heroBig,
	w = 16,
	h = 24,
	q = 1,
	life = 100,
	state = "idle",
	buttons = {},
	hf = false,
	walkTime = 0,
	animSpeed = 8,
})

age.component("hero-bubble", {
	parents = {"sprite"},
	img = sprites.image,
	quads = sprites.quads.bubble,
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
		if e.quads then
			local q = 1
			if e.q then
				q = (e.q - 1) % #e.quads + 1
			end
			lg.draw(img, e.quads[q], wo * hf, ho * vf, 0, hf, vf)
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
		local v = math.floor(p / e.animSpeed * #sprites.reels.bubble)
		e.q = sprites.reels.bubble[v + 1]
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
	local v = 16 * dt
	local dx = 0

	if bs.left then dx = -1 end
	if bs.right then dx = 1 end

	e.x = e.x + dx * v

	if e.life < 20 then
		e.quads = sprites.quads.heroSmall
		e.h = 8
	elseif e.life < 50 then
		e.quads = sprites.quads.heroMedium
		e.h = 16
	else
		e.quads = sprites.quads.heroBig
		e.h = 24
	end
	if dx == 0 then
		e.reel = sprites.reels.heroIdle
	else
		if e.life < 20 then
			e.reel = sprites.reels.heroSmallWalk
		elseif e.life < 50 then
			e.reel = sprites.reels.heroMediumWalk
		else
			e.reel = sprites.reels.heroBigWalk
		end
	end

	local q = 1
	if #e.reel > 1 then
		q = math.floor(e.walkTime) + 1
		e.walkTime = e.walkTime + dt * e.animSpeed
	else
		e.walkTime = 0
	end
	e.q = q
end)

age.receive("hero", "pressed", function (e, b)
	e.buttons[b] = true
	if b == "jump" then
		spawnHeroBubble(e)
		e.life = e.life - 1
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
