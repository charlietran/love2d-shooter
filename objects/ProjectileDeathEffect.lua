require "objects/GameObject"

ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
    ProjectileDeathEffect.super.new(self, area, x, y, opts)

    self.in_first_stage = true
    self.color = opts.color or colors.default

    self.timer:after(0.1, function()
        self.in_first_stage = false
        self.in_second_stage = true

        self.timer:after(0.15, function()
            self.in_second_stage = false
            self.dead = true
        end)
    end)

end

function ProjectileDeathEffect:update(dt)
    ProjectileDeathEffect.super.update(self, dt)
end

function ProjectileDeathEffect:draw()
    if self.in_first_stage then
        love.graphics.setColor(colors.default)
    elseif self.in_second_stage then
        love.graphics.setColor(self.color)
        love.graphics.rectangle(
            'fill', 
            self.x - self.size/2, 
            self.y - self.size/2, 
            self.size,
            self.size
        )
    end
end

function ProjectileDeathEffect:die()
end