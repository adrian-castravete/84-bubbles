local lg = love.graphics

local Sprite = {
	x = 160,
	y = 120,
	w = 16,
	h = 16,
	q = nil,
	img = nil,
}

function Sprite:draw()
	local c = self.color
	local img = self.img
	local w, h = self.w, self.h
	local wo, ho = -w*0.5, -h*0.5

	if not c then
		c = {1, 1, 1}
		if not img then
			c = {math.random(), math.random(), math.random()}
		end
	end

	lg.push()
	lg.translate(self.x, self.y)
	lg.setColor(c)
	if img then
		local q = self.q
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
end

local Hero = Age.clone(Sprite, {
	x = 160,
	y = 120,
	color = {1, 0.5, 0},
})

function Hero:update(dt)
	self:draw()
end

Age.template("hero", Hero)
