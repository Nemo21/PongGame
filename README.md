# Pong- :-) 
Making of pong step by step 
## Lesson 0:
- Lua is a dynamic scripting language like js
- [Love2D](https://love2d.org/wiki/Main_Page) is a framework for creating 2d games
- Great documentation
- Pong game is where there are two paddles and there is a ball and the player who gets it across the opponent's paddle 10 times wins
- Create a directory and in it create a main.lua file
- Set global variables for window height and window width
- call the love.load() function which will run when game first starts up and is executed only once and initalizes the game

```
function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })
end
```

- Now call the love.draw() function to draw anything
- Note: This is called after update

```
function love.draw()
    love.graphics.printf("Hello pong!",0,WINDOW_HEIGHT/2-6,WINDOW_WIDTH,"center")
end
```

## Lesson 1:
- Till now we have created a sample Love2D app which says hello pong.
- Problem: 
    - Resolution problem: 
        - The text and images are blurry by default
        - we need low res for more retro feel
- Solution: 
    - push is a library that will allow us to draw our game at a virtual resolution, 
    - instead of however large our window is used to provide a more retro aesthetic 
    - use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text and graphics
- love.graphics.setDefaultFilter is a function for texture scaling which by default is bilinear

```
love.graphics.setDefaultFilter("nearest","nearest")
```
- Function provided by push library to render our application in a virutal resolution 
```
push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_HEIGHT,WINDOW_WIDTH,{
        fullscreen=false,
        resizable=false,
        vsync=true
    })
```
- Key event handling called by Love2D in each frame
```
function love.keypressed(key)
    --[[key accessed by string name]]
    if key=='escape' then
        --[[function by Love2D to terminate application]]
        love.event.quit()
    end
end
```
```
function love.draw()
    --[[begin rendering with virtual resolution]]
    push:apply('start')
    --[[use virtual width and height,everything written inside the push:apply block will be rendered in virtual resolution]]
    love.graphics.printf("Hello pong!",0,VIRTUAL_HEIGHT/2-6,VIRTUAL_WIDTH,"center")
    --[[end rendering at virtual resolution]]
    push:apply('end')
end
```

## Lesson 2:

- Now we will find a new font to get a retro feel    
- Used to create a font object which we can use later

```
 smallFont = love.graphics.newFont('font.ttf', 8)
```
- How it is used

```
 love.graphics.setFont(smallFont)
```

- Wiping the screen with a color

```
love.graphics.clear(40/255, 45/255, 52/255, 255/255)
```

- Now we will also be sketching out our
    - 2 paddles and a ball
    - Along with a hello pong message
    
```
love.graphics.rectangle('fill', 10, 30, 5, 20)
```

- Note everything is static right now
- Read more about screen resolution

## Lesson 3:

- Now we will add paddle movement along with player's score
- For paddle movement we will need to define
    - Paddle Speed
    - Paddle positions and displacement
- Paddle displacement which will need to be updated every frame(dt)
- Paddle positions can only be along the Y which is up and down
- Score init by 0 
- We need to move while key is pressed for longer periods of time
- love.keyboard.isDown(key) continuously returns true if the key is pressed down

```
--[[Lets get player1 moving with keyevents]]
    --[[Refer the coordinate system]]
    if love.keyboard.isDown('w') then
        --[[Move the paddle up substracting y to show the effect of moving up]]
        player1Y=player1Y + -PADDLE_SPEED*dt
    elseif love.keyboard.isDown('s') then
        --[[Move the paddle down adding cuz y movements means adding]]
        player1Y=player1Y+ PADDLE_SPEED*dt
    end
```
- Get scores of the players in the center
- Mistakes:
    - Forgot to add function end declaration
        - Straight up error action BLUE SCREEN(COOKED ASF)
        - FIX: Read the fucking error ffs
    - Didnt draw rectangle movement with variable x and y for paddle
        - Causing it to still be static
        - FIX: added variable x and y in rectangle fill
    - Forgot to add if end declaration because used to js {}
        - Straight up error action BLUE SCREEN(COOKED ASF)
        - FIX: Read the fucking error ffs
    - Accidently used same key bindings for both the paddles 
        - Causing it to move in a symmterical fashion
        - FIX: Different key bindings for different paddles in keyboard.isDown
        
- Problem:
    - The paddles movements go outside our virtual resolution
    
## Lesson 4:

- Randomness and unpredictibility is an essential part of game development
- Problems:
    - The paddles movements go outside our virtual resolution
    - Ball is static
- Solutions:
    - Use of math.min and math.max to avoid them from doing out of bounds
    
```

 player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
 player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
 
```
- Use of math.randomseed to generate random number like seeds in minecraft but this function is pseudo random
- It needs some starting value to base random numbers
- But if we pass a static number it would generate same random numbers which defeats the whole purpose
- For more randomness we will use os.time() 
 - This returns time in seconds and is a large number
- To actully get random we will use math.max and math.min
- To get inclusive range numbers

```
    math.randomseed(os.time())
    ballY = ballY + ballDY * dt 
    --[[Change the value of y coordinate of ball every frame by ballldy velocity]]
```