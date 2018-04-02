require "objects/GameObject"

TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
    TrailParticle.super.new(self, area, x, y, opts)

    self.depth = 40

    self.size = opts.size or Utils.random(4, 6)
    self.color = opts.color or colors.default

    self.timer:tween(
        opts.duration or Utils.random(0.3, 0.5), 
        self, {size = 0},
        'out-quad', 
        function() self.dead = true end
    )

end

function TrailParticle:update(dt)
    TrailParticle.super.update(self, dt)
end

function TrailParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.size)
end