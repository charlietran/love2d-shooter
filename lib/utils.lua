function loadObjects()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    if object_files then requireFiles(object_files) end
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

function UUID()
    local fn = function(x)
        local r = love.math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function resizeScreen(scale)
    love.window.setMode(scale * game_width, scale * game_height)
    scale_x, scale_y = scale, scale
end

function random(min, max)
    local min, max = min or 0, max or 1
    if min > max then min, max = max, min end
    return love.math.random() * (max - min) + min
end