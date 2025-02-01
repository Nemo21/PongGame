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