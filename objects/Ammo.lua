require "objects/GameObject"

Ammo = GameObject:extend()

function Ammo:new(area, x, y, opts)
    Ammo.super.new(self, area, x, y, opts)
    self.width, self.height = 10, 8
    self.collider = HC.rectangle(self.x, self.y, self.width, self.height)
    self.collider_group = "ammo"
    HC.addToGroup(self.collider_group, self.collider)
    self.collider.game_object = self
    self.angle = Utils.random(0, 2*math.pi)
    self.velocity = Utils.random(10, 20)
    self.angular_velocity = Utils.random(-4, 4)

end

function Ammo:update(dt)
    Ammo.super.update(self, dt)
    self.angle = self.angle + self.angular_velocity * dt
    local x_move, y_move = self.velocity * math.cos(self.angle) * dt, self.velocity * math.sin(self.angle) * dt

    self.collider:move(x_move, y_move)
end

function Ammo:draw()
    love.graphics.setColor(colors.ammo)
    Utils.pushRotate(self.x, self.y, self.angle)
    draft:rhombus(self.x, self.y, self.width, self.height, 'line')
    love.graphics.pop()
    love.graphics.setColor(colors.default)
end