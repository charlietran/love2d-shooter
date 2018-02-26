Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    for i = #self.game_objects, 1, -1 do
        local game_object = game_objects[i]
        game_object:update(dt)
        if game_object.dead then 
            table.remove(self.game_objects, i) 
        end
    end
end

function Area:draw(dt)
    for _, game_object in ipairs(self.game_objects) do game_object:draw(dt) end
end

function Area:add_game_object(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:get_game_objects(filter_function)
    local game_objects = {}
    if not filter_function then 
        return self.game_objects
    else
        return _.include(self.game_objects, filter_function)
    end
end