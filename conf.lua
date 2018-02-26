game_width = 480
game_height = 270
scale_x = 3
scale_y = 3

function love.conf(t)
    t.identity = nil                      -- The name of the save directory (string)
    t.version = "0.10.2"                  -- The LÖVE version this game was made for (string)
    t.console = false                     -- Attach a console (boolean, Windows only)
 
    t.window.title = "BYTEPATH"           -- The window title (string)
    t.window.icon = nil                   -- Filepath to an image to use as the window's icon (string)
    t.window.width = game_width           -- The window width (number)
    t.window.height = game_height         -- The window height (number)
    t.window.borderless = false           -- Remove all border visuals from the window 
    t.window.resizable = true             -- Let the window be user-resizable 
    t.window.minwidth = 1                 -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1                -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false           -- Enable fullscreen 
    t.window.fullscreentype = "exclusive" -- Standard fullscreen or desktop fullscreen mode (string)
    t.window.vsync = true                 -- Enable vertical sync 
    t.window.fsaa = 0                     -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1                  -- Index of the monitor to show the window in (number)
    t.window.highdpi = false              -- Enable high-dpi mode for the window on a Retina display 
    t.window.srgb = false                 -- Enable sRGB gamma correction when drawing to the screen 
    t.window.x = nil                      -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                      -- The y-coordinate of the window's position in the specified display (number)
 
    t.modules.audio = true                -- Enable the audio module 
    t.modules.event = true                -- Enable the event module 
    t.modules.graphics = true             -- Enable the graphics module 
    t.modules.image = true                -- Enable the image module 
    t.modules.joystick = true             -- Enable the joystick module 
    t.modules.keyboard = true             -- Enable the keyboard module 
    t.modules.math = true                 -- Enable the math module 
    t.modules.mouse = true                -- Enable the mouse module 
    t.modules.physics = true              -- Enable the physics module 
    t.modules.sound = true                -- Enable the sound module 
    t.modules.system = true               -- Enable the system module 
    t.modules.timer = true                -- Enable the timer module , Disabling it will result 0 delta time in love.update
    t.modules.window = true               -- Enable the window module 
    t.modules.thread = true               -- Enable the thread module 
end