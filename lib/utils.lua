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


Utils = {
}

function Utils.random(min, max)
    local min, max = min or 0, max or 1
    if min > max then min, max = max, min end
    return love.math.random() * (max - min) + min
end

function Utils.pushRotate(x, y, angle)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle or 0)
    love.graphics.translate(-x, -y)
end

function Utils.pushRotateScale(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end

function Utils.isOutOfBounds(object)
    return object.x < 0 or object.x > game_width or object.y < 0 or object.y > game_height 
end

time_scale = 1.0
function Utils.scaleTime(scale)
    scale = math.max(scale, 0)
    time_scale = scale
end

function Utils.slowTime(scale, duration)
    time_scale = scale
    timer:tween('slow', duration, _G, {time_scale = 1.0}, 'in-out-cubic')
end

function Utils.resetTimeScale()
    time_scale = 1.0
end

function Utils.screenFlash(frames)
    flash_frames = frames
end

--- memory analysis utilities

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
            f(t)
	    seen[t] = true
	    for k,v in pairs(t) do
	        if type(v) == "table" then
		    count_table(v)
	        elseif type(v) == "userdata" then
		    f(v)
	        end
	end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
            for k,v in pairs(_G) do
	        global_type_table[v] = k
	    end
	global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end

function print_as_json(obj)
    if obj == nil then return "null" else
        local buffer = {}
        format_any_value(obj, buffer)
        print(table.concat(buffer))
    end
end