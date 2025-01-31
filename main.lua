--[[
    Remaking Pong in 2025
    TIP1:Read the damn error for fucks sake
        >it was a spelling mistake in resizable bruh
]]

--[[
    Set window height and window width 
    which will be used throughout 
]]
WINDOW_WIDTH=1280
WINDOW_HEIGHT=720

--[[
    Function run when game first starts up
    and only once its run to initailize game
]]

function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })
end

--[[
    Called after update by Love2d,used to draw anything 
    on the screen,updated
]]

function love.draw()
    love.graphics.printf("Hello pong!",0,WINDOW_HEIGHT/2-6,WINDOW_WIDTH,"center")
end
--[[
    printf("text to render",starting X,starting Y,number of pixels to center within,alignment mode)
]]