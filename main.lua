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

--[[Requiring the class package]]
Class = require 'class'
require 'Paddle'
--[[Requiring the classes we made]]
require 'Ball'
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

    love.window.setTitle("Pong")
    --[[
        like a random number generator takes a different initial value each time
        thanks to os.time
    ]]
    math.randomseed(os.time())

    --[[Getting a new font to give the game that retro feel]]
    smallFont = love.graphics.newFont("font.ttf", 8);

    largeFont = love.graphics.newFont("font.ttf", 16)
    --[[New font object for displaying scores of players]]
    scoreFont = love.graphics.newFont("font.ttf", 32)

    --[[Set active font as this smallFont object]]
    love.graphics.setFont(smallFont);

    --[[Sounds table like a javascript object or a python dictionary]]
    sounds = {
        ['paddle_hit'] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
        ['score'] = love.audio.newSource("sounds/score.wav", "static"),
        ['wall_hit'] = love.audio.newSource("sounds/wall_hit.wav", "static")
    }

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

    --[[Staring with serving player 1 and switch as player scores points slay queen]]
    servingPlayer = 1
    --[[Paddle positions of both the players]]
    --[[We will only be changing Y because in pong only up and down movement is allowed]]

    -- initialize our player paddles; make them global so that they can be
    -- detected by other functions and modules
    player1 = Paddle(10, 30, 5, 20) --[[This will be positioned up]]
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20) --[[This will be positioned down]]

    --[[Keeping variables for position as it would change frame by framw with the velocity Dx and Dy]]
    --[[Initially in the center of the screen]]
    -- place a ball in the middle of the screen
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --[[Movement of ball frame by frame multiplies with velocity 
        so it would move in a direction frame by frame]]

    --[[Will use game state to change between start and play]]
    gameState = "start"
end

--[[Runs every frame when time 'dt' has passed since the last frame]]
--[[We need a function to test for longer periods of input]]
--[[love.keyboard.isDown(key) continuously returns true if the key is pressed down]]

function love.update(dt)
    if gameState == 'serve' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position of collision
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end

        -- detect upper and lower screen boundary collision and reverse if collided
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- -4 to account for the ball's size
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- if we reach the left or right edge of the screen, 
        -- go back to start and update the score
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            -- if we've reached a score of 10, the game is over; set the
            -- state to done so we can show the victory message
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                -- places the ball in the middle of the screen, no velocity
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
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
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
            --[[When in start state, the ball will be in the center]]
        elseif gameState == "done" then
            gameState = "serve"
            ball:reset()
            player1Score = 0
            player2Score = 0
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
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
    displayScore()
    if gameState == "start" then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to pong you slime!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin you bitch!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics
            .printf('Player ' .. tostring(servingPlayer) .. " 's fucking serve", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Pookie press enter to serve UwU", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == "play" then

    elseif gameState == "done" then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. "wins bitch", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press enter to retard!", 0, 30, VIRTUAL_WIDTH, "center")
    end
    -- love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')

    --[[Draw the scores of both the players in the center]]

    --[[Now we will draw the 2 paddles and a ball]]

    --[[First the left side paddle]]

    player1:render()

    --[[Now the right side paddle]]

    player2:render()

    --[[Now we will draw the call in dead center]]
    --[[Now we will render ball acc to the variable positon and velocity]]

    ball:render()

    --[[Call display FPS]]
    displayFPS()

    --[[end rendering at virtual resolution]]
    push:apply('end')
end
--[[
    printf("text to render",starting X,starting Y,number of pixels to center within,alignment mode)
]]

function displayFPS()
    --[[display FPS on left side of screen in green]]
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end
