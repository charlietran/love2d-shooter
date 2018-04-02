require "objects/GameObject"

Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12

    self.collider = HC.circle(self.x, self.y, self.w)
    self.collider.game_object = self
    self.collider_group = "player"
    HC.addToGroup(self.collider_group, self.collider)

    self.angle = -math.pi/2
    self.angle_velocity = 1.66*math.pi
    self.velocity = 0
    self.base_max_velocity = 100
    self.max_velocity = self.base_max_velocity
    self.acceleration = 100

    self.attack_interval = 0.24
    self.attack_speed = 1

    self.sketchiness = 1

    -- boost
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2
    self.is_boosting = false
    self.max_boost = 100
    self.boost = self.max_boost

    -- health
    self.max_hp = 100
    self.hp = self.max_hp

    -- ammo
    self.max_ammo = 100
    self.ammo = self.max_ammo


    self.tick_interval = 5
    self.timer:after(self.tick_interval, function(func) 
        self:tick() 
        self.timer:after(self.tick_interval, func) 
    end)

    self:initPlayerTrail()
    self:initShip()
    self:scheduleShoot()
end

function Player:initShip()
    self.polygons = {}
    self.ship_color = {255, 255, 255}

    self.ship = self:getShip("fighter")
    self:initShipTrails(self.ship.trail_points)
end

function Player:initShipTrails(trail_points)
    for __index, trail_point in ipairs(trail_points) do
        self.timer:every(0.01, function() 
            self.area:addGameObject(
                'TrailParticle',
                self.x + trail_point.x_offset * math.cos(self.angle) + trail_point.y_offset*math.cos(self.angle + math.pi/2),
                self.y + trail_point.x_offset * math.sin(self.angle) + trail_point.y_offset*math.sin(self.angle + math.pi/2),
                {
                    parent = self, 
                    size = Utils.random(self.ship.trail_size-1, self.ship.trail_size+1), 
                    duration = Utils.random(0.15, 0.25), 
                    color = self.trail_color
                }
            )
        end)
    end
end
function Player:drawShip()
    Utils.pushRotate(self.x, self.y, self.angle)
    love.graphics.setColor(self.ship_color)
    for __index, polygon in ipairs(self.ship.polygons) do
        local points = fn.map(polygon, function(index, val)
            if index % 2 == 1 then
                return self.x + val + Utils.random(-self.sketchiness, self.sketchiness)
            else
                return self.y + val + Utils.random(-self.sketchiness, self.sketchiness)
            end
        end)
        love.graphics.polygon('line', points)
    end
    love.graphics.pop()
    -- love.graphics.circle('line', self.x, self.y, self.w)
end
 
function Player:update(dt)
    Player.super.update(self, dt)
    if Utils.isOutOfBounds(self) then self:die() end

    self:updateRotation(dt)
    self:updateBoost(dt)

    input:bind('p', function() 
        self.area:addGameObject(
            'Ammo', 
            Utils.random(0, game_width),
            Utils.random(0, game_height)
        )
    end)

    self.trail_color = self.is_boosting and colors.boost or self.base_trail_color

    self.velocity = math.min(self.velocity + self.acceleration * dt, self.max_velocity)
    local x_move, y_move = self.velocity * math.cos(self.angle) * dt, self.velocity * math.sin(self.angle) * dt
    self.collider:move(x_move, y_move)
end

function Player:updateRotation(dt)
    if input:down('left') then
        self.angle = self.angle - self.angle_velocity * dt
    end
    if input:down('right') then
        self.angle = self.angle + self.angle_velocity * dt
    end

    analog_x = input:down('analog_angle')
    if analog_x and (analog_x < -0.3 or analog_x > 0.3) then 
        analog_x = (analog_x < 0 and analog_x + 0.3 or analog_x - 0.3) / 0.7
        self.angle = self.angle + self.angle_velocity * dt * analog_x
    end
end

function Player:updateBoost(dt)
    self.boost = math.min(self.boost + 10*dt, self.max_boost)

    self.boost_timer = self.boost_timer + dt
    self.can_boost = self.boost_timer > self.boost_cooldown
    self.is_boosting = false

    self.max_velocity = self.base_max_velocity

    if self.can_boost then
        if input:down('accelerate') then 
            self.is_boosting = true 
            self.max_velocity = 1.5 * self.max_velocity 
            self.boost = self.boost - 50*dt
        end
        if input:down('decelerate') then 
            self.is_boosting = true 
            self.max_velocity = 0.5 * self.max_velocity 
            self.boost = self.boost - 50*dt
        end

        analog_y = input:down('analog_speed')
        if analog_y and (analog_y < -0.3 or analog_y > 0.3) then 
            analog_y = (analog_y < 0 and analog_y + 0.3 or analog_y - 0.3) / 0.7
            self.is_boosting = true
            self.max_velocity = self.max_velocity * (1 - analog_y/2)
        end
    end

    if self.boost <= 0 then
        self.is_boosting = false
        self.can_boost = false
        self.boost_timer = 0
    end
end

function Player:draw()
    self:drawShip()
    -- orientation dot
    love.graphics.points(
        self.x + 2 * self.w * math.cos(self.angle) - 2,
        self.y + 2 * self.w * math.sin(self.angle),

        self.x + 2 * self.w * math.cos(self.angle) + 2,
        self.y + 2 * self.w * math.sin(self.angle),

        self.x + 2 * self.w * math.cos(self.angle),
        self.y + 2 * self.w * math.sin(self.angle) - 2,

        self.x + 2 * self.w * math.cos(self.angle),
        self.y + 2 * self.w * math.sin(self.angle) + 2
    )
    -- love.graphics.line(
    --     self.x, 
    --     self.y, 
    --     self.x + 2 * self.w * math.cos(self.angle),
    --     self.y + 2 * self.w * math.sin(self.angle)
    -- )
end

function Player:scheduleShoot()
    self.timer:after(self.attack_interval/self.attack_speed, function()
        self:shoot()
        self:scheduleShoot()
    end)
end
function Player:shoot()
    local distance = 1.2 * self.w
    self.area:addGameObject(
        'ShootEffect',
        self.x + distance * math.cos(self.angle),
        self.y + distance * math.sin(self.angle),
        { player = self, distance = distance }
    )
    self.area:addGameObject(
        'Projectile',
        self.x + 1.5 * distance * math.cos(self.angle),
        self.y + 1.5 * distance * math.sin(self.angle),
        { angle = self.angle }
    )
    -- Extra bullets exercise
    -- self.area:addGameObject(
    --     'Projectile',
    --     self.x + 10*math.sin(self.angle) + 1.5 * distance * math.cos(self.angle),
    --     self.y - 10*math.cos(self.angle) + 1.5 * distance * math.sin(self.angle),
    --     { angle = self.angle }
    -- )
    -- self.area:addGameObject(
    --     'Projectile',
    --     self.x - 10*math.sin(self.angle) + 1.5 * distance * math.cos(self.angle),
    --     self.y + 10*math.cos(self.angle) + 1.5 * distance * math.sin(self.angle),
    --     { angle = self.angle }
    -- )
end

function Player:initPlayerTrail()
    self.base_trail_color = colors.player_trail
    self.trail_color = self.base_trail_color
end

function Player:die()
    self.dead = true
    Utils.screenFlash(4)
    camera:shake(6, 60, 0.4)
    Utils.slowTime(0.15, 1)
    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end
end

function Player:tick()
    self.area:addGameObject('PlayerTickEffect', self.x, self.y, { size = 30, angle = self.angle })
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:getShip(name)
    local ships = {}

    ships.fighter = {
        polygons = {
            -- main body
            {
                self.w, 0, -- right center
                self.w/3, -self.h/2, -- top right
                -self.w/2, -self.h/2, -- top left
                -self.w/4, 0, -- left center
                -self.w/2, self.h/2, -- bottom left
                self.w/3, self.h/2 -- bottom right
            },

            -- top wing
            {
                self.w/4, -self.h/2, -- bottom right of wing
                -self.w/2, -self.h, -- tip of wing
                -self.w/3, -self.h/2, -- bottom left of wing
            },

            -- bottom wing
            {
                self.w/4, self.h/2, -- top right of wing
                -self.w/2, self.h, -- tip of wing
                -self.w/3, self.h/2, -- top left of wing
            }
        },
        trail_points = {
            {x_offset = -4, y_offset = -self.h/4},
            {x_offset = -4, y_offset = self.h/4}
        },
        trail_size = 2
    }

    ships.bomber = {
        polygons = {
            -- main body
            {
                12, 0, -- right center
                8, -12, -- top right
                -4, -12, -- top left
                -8, -8, -- top left tip
                -4, -8, -- top left tip inset
                0, 0, -- left center
                -4, 8, -- bottom left tip inset
                -8, 8, -- bottom left tip
                -4, 12, -- bottom left
                8, 12, -- bottom right
            },

        },
        trail_points = {
            {x_offset = -2, y_offset = 0},
        },
        trail_size = 4
    }

    return ships[name]
end