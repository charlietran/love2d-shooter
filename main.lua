Object = require "lib/classic/classic"
Input = require "lib/input"
Timer = require 'lib/hump/timer'
Camera = require 'lib/hump/camera'
_ = require 'lib/moses/moses_min'
require 'lib/utils'

function love.load()
    timer = Timer()
    camera = Camera()
    loadObjects() -- in utils.lua
    setupGraphics()
    bindInputs()
    current_room = Stage()
end

function setupGraphics()
    love.graphics.setLineStyle('rough')
    love.graphics.setDefaultFilter('nearest')
    resizeScreen(3)
end

function bindInputs()
    input = Input()
    input:bind('q', function() camera:shake(4, 60, 1) end)
end

function love.update(dt)
    camera:update(dt)
    timer:update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end