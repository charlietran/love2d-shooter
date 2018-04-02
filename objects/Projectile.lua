require "objects/GameObject"

Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.radius = opts.radius or 2.5
    self.velocity = opts.velocity or 200

    self.collider = HC.circle(self.x, self.y, self.radius)
    self.collider.game_object = self
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)
    if Utils.isOutOfBounds(self) then self:die() end

    local x_move, y_move = self.velocity * math.cos(self.angle) * dt, self.velocity * math.sin(self.angle) * dt
    self.collider:move(x_move, y_move)
end

function Projectile:draw()
    love.graphics.setColor(colors.default)
    love.graphics.circle('line', self.x, self.y, self.radius)
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject(
        "ProjectileDeathEffect",
        self.x,
        self.y,
        { color = colors.hp, size = 3 * self.radius}
    )
end