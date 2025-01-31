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
