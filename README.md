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
    - [push](https://github.com/Ulydev/push) is a library that will allow us to draw our game at a virtual resolution, 
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

## Lesson 5:

- We do be scaling <3
- We talking classes and objects for paddle and ball
- Classes are blueprints fpr creating bundles of data and code that are related
- Its gonna maintain its own state for us
- Descriptive attributes about the class are: Fields
- Methods that define behaviour of class are: Functions
- Concrete object is instantiated from class blueprints
- We will use the library [Class](https://github.com/vrld/hump)
- This library allows us to create classes in lua without complications
- Everything in lua is a table(similar to object in javascript)
- A contructor:
    - Self: Whatever object we are creating with class is going to be Self
- Mistakes:
    - Typo of using math.max instead of math.min
    - Paddle after movement went back to the bottom of the screen and then out of the screen resolution
    - FIX: Spending 5mins rereading what I wrote in class files
    

## Lesson 6:

- Frames per second is to check performance of game
- Setting title of game for beautification purposes.
```
love.window.setTitle(title)
```
- To check if game is running well or not we use 
```
love.timer.getFPS()
```
- We will draw this on our application
- It returns a number so we will need to convert it to string to concatinate with string
- Lua doesnt allow string and number concatination
- We concatinate using the ".." 
```
love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
```

## Lesson 7:

- Problem :
    - The ball passes through the paddle.
- Solution:
    - NOTES AND INFORMATION ABOUT AABB(Axis-Aligned Bounding Boxes)
        - Collison boxes(Reactangle,Quadrilaterals which have (x,y,width,height)) contain no rotation(completely parallel perpendicular to the axes)
        - IDEA: No edges of our boxes are outside the opposite edge THIS MEANS THERE IS A COLLISION
        - Some naming convention for simplicity:
            - TE: Top edge
            - BE: Bottom edge
            - LE: Left edge
            - RE: Right edge
            - R1: Rectangle1
            - R2: Rectangle2
        - Condition for NO Collision(we will write a inverse query)
            - If top and bottom condition
                1. R1TE is BELOW R2BE 
                    - Refer to the illustration in images/Case1OfTopAndBottom
                2. R1BE is ABOVE R2TE
                    - Refer to the illustration in images/Case2OfTopAndBottom
            - If left and right condition
                1. R1LE is RIGHT to R2RE
                    - Refer to the illustration in images/Case1OfLeftAndRight
                2. R1RE is LEFT to R2LE   
                    - Refer to the illustration in images/Case2OfLeftAndRight
        - When we detect a collison we need to do the following:
            - Change the direction of velocity of the ball
            - Change the position of the ball to avoid the ball to infinitely collide
            - Randomise angle between paddle and ball when a collision happens
            - Refer to the illustration in images/AngleOfDeflection
- Problem:
    - Ball ball passes through the screen wall infinitely        
- Solution:
    - Check if it went to the top of screen and went down the screen
    - Set the position to top or bottom and  change the directon of the ball velocity
    
    
## Lesson 8:

- Making a state machine this case is of using if else not using a state machine class 
- Monitoring what state we are in and what has to take place between states to bring new states
- Each individual state has its own logic
- Helps scaling and avoid monolith shit
- Play state,serve state and game over state
- A state can be in only any one particular state at one time
- Transitions allow to to go between states.
    - Each state does have transitions in and out of other states
- Serve state:
    - Player who lost the previous score gets to serve
    - Scoring a point is trigger between going from play to serve state
    - Pressing the enter key is trigger between going from serve state back to play state
- GG cooked chat