require "objects/GameObject"

ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(area, x, y, opts)
    ExplodeParticle.super.new(self, area, x, y, opts)

    self.color = opts.color or colors.default
    self.angle = Utils.random(0, 2*math.pi)
    self.size = opts.size or Utils.random(2, 3)
    self.velocity = opts.velocity or Utils.random(75, 150)
    self.line_width = 2

    self.timer:tween(
        opts.duration or Utils.random(0.3, 0.5),
        self,
        { size = 0, line_width = 0 },
        'linear',
        function() self.dead = true end
    )
end

function ExplodeParticle:update(dt)
    ExplodeParticle.super.update(self, dt)
    local x_move, y_move = self.velocity * math.cos(self.angle) * dt, self.velocity * math.sin(self.angle) * dt
    self.x, self.y = self.x + x_move, self.y + y_move
end

function ExplodeParticle:draw()
    Utils.pushRotate(self.x, self.y, self.angle)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.size, self.y, self.x + self.size, self.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end