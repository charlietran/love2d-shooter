GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts or {}
    if opts then for k, v in pairs(opts) do self[k] = v end end

    self.area = area
    self.x, self.y = x, y
    self.id = UUID()
    self.is_dead = false
    self.timer = EnhancedTimer()
    self.depth = 50
    self.creation_time = love.timer.getTime()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:center() end
end

function GameObject:destroy()
    self.timer:destroy()
    if self.collider then 
        self.collider.game_object = nil
        HC.removeFromGroup(self.collider_group, self.collider)
        HC.remove(self.collider) 
        self.collider = nil
    end
end