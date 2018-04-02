Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(game_width, game_height)

    self.player = self.area:addGameObject(
        'Player', 
        game_width/2, 
        game_height/2
    )

    -- add a mouse-controlled circle to the scene
    -- self.mouse = HC.circle(0,0,20)
end

function Stage:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, game_width/2, game_height/2)

    -- local mouse_x, mouse_y = love.mouse.getPosition()
    -- if self.mouse then self.mouse:moveTo(mouse_x/scale_x, mouse_y/scale_y) end

    if self.player.collider then
        for collider, delta in pairs(HC.collisions(self.player.collider)) do
            print(string.format("Colliding. Separating vector = (%s,%s)", delta.x, delta.y))
        end
    end
    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
        camera:attach(0, 0, game_width, game_height)
            love.graphics.clear()
            self.area:draw()
            -- if self.mouse then self.mouse:draw("fill") end
        camera:detach()
    love.graphics.setCanvas()
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, scale_x, scale_y)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    -- HC.remove(self.mouse)
    -- self.mouse = nil
end