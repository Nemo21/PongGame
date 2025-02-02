--[[
    Remaking Pong in 2025
    TIP1:Read the damn error for fucks sake
        >it was a spelling mistake in resizable bruh
    PROBLEM 1:
        Resolution problem: 
            The text and images are blurry by default
            we need low res for more retro feel
]]


--[[
   push is a library that will allow us 
   to draw our game at a virtual resolution, 
   instead of however large our window is; 
   used to provide a more retro aesthetic 
]]
push = require 'push'
--[[
    Set window height and window width 
    which will be used throughout 
]]
WINDOW_WIDTH=960
WINDOW_HEIGHT=720

--[[
    initialize our virtual resolution, 
    which will be rendered within our
    actual window no matter its dimensions
]]
VIRTUAL_WIDTH=432
VIRTUAL_HEIGHT=243

--[[
    Function run when game first starts up
    and only once its run to initailize game
]]

function love.load()
--[[
    use nearest-neighbor filtering on upscaling and downscaling 
    to prevent blurring of text and graphics
    try removing this function to see the difference!
]]
    love.graphics.setDefaultFilter("nearest","nearest")
    
    --[[Getting a new font to give the game that retro feel]]
    smallFont=love.graphics.newFont("font.ttf",8);
    
    --[[Set active font as this smallFont object]]
    love.graphics.setFont(smallFont);
    
    --[[
        function provided by the push library
        check push.lua for more info
    ]]
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_HEIGHT,WINDOW_WIDTH,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })
end


--[[
    Key event handling called by Love2D in each frame
]]

function love.keypressed(key)
    --[[key accessed by string name]]
    if key=='escape' then
        --[[function by Love2D to terminate application]]
        love.event.quit()
    end
end

--[[
    Called after update by Love2d,used to draw anything 
    on the screen,updated
]]

function love.draw()
    --[[begin rendering with virtual resolution]]
    push:apply('start')
    
    --[[use virtual width and height]]
    
    
    --[[
        When we start rendering,first clear the screen wipe with this color
    ]]
    
    love.graphics.clear(40/255,45/255,52/255,255/255);
    
    --[[Now we need a welcome text towards top center of screen]]
    
    love.graphics.printf("Hello Pong!",0,20,VIRTUAL_WIDTH,'center')
    
    --[[Now we will draw the 2 paddles and a ball]]
    
    --[[First the left side paddle]]
    
    love.graphics.rectangle('fill',10,30,5,20);
    
    --[[Now the right side paddle]]
    
    love.graphics.rectangle('fill',VIRTUAL_WIDTH-10,VIRTUAL_HEIGHT-50,5,20);
    
    --[[Now we will draw the call in dead center]]
    
    love.graphics.rectangle('fill',VIRTUAL_WIDTH/2-2,VIRTUAL_HEIGHT/2-2,4,4);
    
    --[[end rendering at virtual resolution]]
    push:apply('end')
end
--[[
    printf("text to render",starting X,starting Y,number of pixels to center within,alignment mode)
]]