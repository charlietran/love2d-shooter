require "objects/GameObject"

ShootEffect = GameObject:extend()

function ShootEffect:new(...)
    ShootEffect.super.new(self, ...)
    self.w = 8
    self.timer:tween(0.1, self, {w=0}, 'in-out-cubic', function()
        self.dead = true
    end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)
    if self.player then
        self.x = self.player.x + self.distance * math.cos(self.player.angle)
        self.y = self.player.y + self.distance * math.sin(self.player.angle)
    end
end

function ShootEffect:draw()
    Utils.pushRotate(self.x, self.y, self.player.angle + math.pi/4)
    love.graphics.setColor(colors.default)
    love.graphics.rectangle(
        'fill',
        self.x - self.w/2,
        self.y - self.w/2,
        self.w,
        self.w
    )
    love.graphics.pop()
end