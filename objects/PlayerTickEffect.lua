require "objects/GameObject"

PlayerTickEffect = GameObject:extend()

function PlayerTickEffect:new(area, x, y, opts)
    PlayerTickEffect.super.new(self, area, x, y, opts)

    self.color = {255, 255, 255, 50}
    self.size = opts.size or Utils.random(2, 3)
    self.width, self.height = self.size, self.size
    self.depth = 75

    self.timer:tween(
        opts.duration or 0.1,
        self,
        { height = 0 },
        'linear',
        function() self.dead = true end
    )
end

function PlayerTickEffect:update(dt)
    PlayerTickEffect.super.update(self, dt)
end

function PlayerTickEffect:draw()
    Utils.pushRotate(self.x, self.y, self.angle)
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
    love.graphics.pop()
end