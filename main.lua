--[[
    Remaking Pong in 2025
    TIP1:Read the damn error for fucks sake
        >it was a spelling mistake in resizable bruh
    PROBLEM 1:
        Resolution problem: 
            The text and images are blurry by default
            we need low res for more retro feel
]] --[[
   push is a library that will allow us 
   to draw our game at a virtual resolution, 
   instead of however large our window is; 
   used to provide a more retro aesthetic 
]] push = require 'push'
--[[
    Set window height and window width 
    which will be used throughout 
]]
WINDOW_WIDTH = 960
WINDOW_HEIGHT = 720

--[[
    initialize our virtual resolution, 
    which will be rendered within our
    actual window no matter its dimensions
]]
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[Speed of paddle,multiplied with dt with every frame]]

PADDLE_SPEED = 200

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
    love.graphics.setDefaultFilter("nearest", "nearest")

    --[[
        like a random number generator takes a different initial value each time
        thanks to os.time
    ]]
    math.randomseed(os.time())

    --[[Getting a new font to give the game that retro feel]]
    smallFont = love.graphics.newFont("font.ttf", 8);

    --[[New font object for displaying scores of players]]
    -- scoreFont = love.graphics.newFont("font.ttf", 32)

    --[[Set active font as this smallFont object]]
    love.graphics.setFont(smallFont);

    --[[
        function provided by the push library
        check push.lua for more info
    ]]
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_HEIGHT, WINDOW_WIDTH, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    --[[Initialising the two player's score]]
    player1Score = 0
    player2Score = 0

    --[[Paddle positions of both the players]]
    --[[We will only be changing Y because in pong only up and down movement is allowed]]
    player1Y = 30 --[[This will be positioned up]]
    player2Y = VIRTUAL_HEIGHT - 50 --[[This will be positioned down]]

    --[[Keeping variables for position as it would change frame by framw with the velocity Dx and Dy]]
    --[[Initially in the center of the screen]]
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    --[[Movement of ball frame by frame multiplies with velocity 
        so it would move in a direction frame by frame]]

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    --[[Will use game state to change between start and play]]
    gameState = "start"
end

--[[Runs every frame when time 'dt' has passed since the last frame]]
--[[We need a function to test for longer periods of input]]
--[[love.keyboard.isDown(key) continuously returns true if the key is pressed down]]

function love.update(dt)
    --[[Lets get player1 moving with keyevents]]
    --[[Refer the coordinate system]]
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        -- now, we clamp our position between the bounds of the screen
        -- math.max returns the greater of two values; 0 and player Y
        -- will ensure we don't go above it
        --[[Move the paddle up substracting y to show the effect of moving up]]
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        -- math.min returns the lesser of two values; bottom of the egde minus paddle height
        -- and player Y will ensure we don't go below it
        --[[Move the paddle down adding cuz y movements means adding]]
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    --[[Lets get player2 moving with keyevents]]
    if love.keyboard.isDown('up') then
        --[[Move the paddle up substracting y to show the effect of moving up]]
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        --[[Move the paddle down adding cuz y movements means adding]]
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    --[[Start the ball movement from center]]
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end

--[[
    Key event handling called by Love2D in each frame
]]

function love.keypressed(key)
    --[[key accessed by string name]]
    if key == 'escape' then
        --[[function by Love2D to terminate application]]
        love.event.quit()

    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "play"
        else
            gameState = "start"
            --[[When in start state, the ball will be in the center]]
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
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

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255);

    --[[Now we need a welcome text towards top center of screen]]
    love.graphics.setFont(smallFont)
    if gameState == "start" then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end
    -- love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')

    --[[Draw the scores of both the players in the center]]
    -- love.graphics.setFont(scoreFont)
    -- love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    -- love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    --[[Now we will draw the 2 paddles and a ball]]

    --[[First the left side paddle]]

    love.graphics.rectangle('fill', 10, player1Y, 5, 20);

    --[[Now the right side paddle]]

    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20);

    --[[Now we will draw the call in dead center]]
    --[[Now we will render ball acc to the variable positon and velocity]]

    love.graphics.rectangle('fill', ballX, ballY, 4, 4);

    --[[end rendering at virtual resolution]]
    push:apply('end')
end
--[[
    printf("text to render",starting X,starting Y,number of pixels to center within,alignment mode)
]]
