Ball = Class {}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = math.random(2) == 1 and 100 or -100
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end

--[[Expects a paddle to collide with and 
    returns true or false depending on where their rectangles are overlapping
    meaning if there is a collision or not]]
function Ball:collides(paddle)
    -- checking for left edge of either(paddle or ball) is right away from the right edge of (ball or paddle) 
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- checking for bottom edge of either(paddle or ball) is higher away from the top edge of (ball or paddle) 
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- collision has happened

    return true

end
--[[
    Places the ball in the middle of the screen, with an initial random velocity
    on both axes.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.dy = math.random(2) == 1 and 100 or -100
    self.dx = math.random(-50, 50) * 1.5
end
--[[
    Simply applies velocity to position, scaled by deltaTime.
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
