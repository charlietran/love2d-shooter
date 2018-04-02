require "lib/globals"
Object = require "lib/classic/classic"
Input = require "lib/input"
EnhancedTimer = require "lib/EnhancedTimer/EnhancedTimer"
Camera = require "lib/hump/camera"
HC = require "lib/HC"
fn = require "lib/moses/moses_min"
Draft = require('lib/draft/draft')
draft = Draft()

require "lib/utils"

function love.load()
    timer = EnhancedTimer()
    camera = Camera()
    rooms = {}
    loadObjects() -- in utils.lua
    setupGraphics()
    bindInputs()
    current_room = Stage()
end

function setupGraphics()
    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest')
    resizeScreen(2)
end

function bindInputs()
    input = Input()
    input:bind('left', 'left')
    input:bind('dpleft', 'left')
    input:bind('dpright', 'right')
    input:bind('right', 'right')
    input:bind('dpup', 'accelerate')
    input:bind('up', 'accelerate')
    input:bind('dpdown', 'decelerate')
    input:bind('down', 'decelerate')
    input:bind('fup', function() camera:shake(4, 60, 1) end)
    input:bind('leftx', 'analog_angle')
    input:bind('lefty', 'analog_speed')

    -- memory analysis and debugging
    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)

    input:bind('f2', function()
        gotoRoom("Stage")
    end)

    input:bind('f5', function()
        current_room:destroy()
        current_room = nil
    end)

end

function love.update(dt)
    timer:update(dt * time_scale)
    camera:update(dt * time_scale)
    if current_room then current_room:update(dt * time_scale) end
end

function love.draw()
    if current_room then current_room:draw() end
    Graphics.screenEffects()
end

Graphics = {}
function Graphics:screenEffects()
    if flash_frames then
        flash_frames = flash_frames - 1
        if flash_frames < 0 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(colors.background)
        love.graphics.rectangle('fill', 0, 0, game_width * scale_x, game_height * scale_y)
        love.graphics.setColor(255, 255, 255)
    end
end

function addRoom(room_type, room_name, ...)
    local room = _G[room_type](room_name, ...)
    rooms[room_name] = room
    return room
end

function gotoRoom(room_type, ...)
    if current_room and current_room.destroy then current_room:destroy() end
    current_room = _G[room_type](...)
    -- if current_room and rooms[room_name] then
    --     if current_room.deactivate then current_room.deactivate() end
    --     current_room = rooms[room_name]
    --     if current_room.activate then current_room.activate() end
    -- else
    --     current_room = addRoom(room_type, room_name, ...)
    -- end
end