-- converts screen coords and applies unified logic to pressed, moved and released events,
-- whether they came from mouse or touch
-- assumes screen module to be in use already
-- (all these returns are here to avoid useless implicit returns as there functions will be called a lot. may be irrelevant)

return function(love, screen)
  if love.pressed then
    local pressed
    pressed = function(x, y)
      x, y = screen.coords(x, y)
      love.pressed(x, y)
    end
    love.mousepressed = function(x, y, b, isTouch)
      if not isTouch then
        pressed(x, y)
      end
    end
    love.touchpressed = function(id, x, y, pressure)
      pressed(x, y)
    end
  end
  if love.moved then
    local moved
    moved = function(x, y)
      x, y = screen.coords(x, y)
      love.moved(x, y)
    end
    love.mousemoved = function(x, y, dx, dy)
      moved(x, y)
    end
    love.touchmoved = function(id, x, y, pressure)
      moved(x, y)
    end
  end
  if love.released then
    local released
    released = function(x, y)
      x, y = screen.coords(x, y)
      love.released(x, y)
    end
    love.mousereleased = function(x, y, b, isTouch)
      if not isTouch then
        released(x, y)
      end
    end
    love.touchreleased = function(id, x, y, pressure)
      released(x, y)
    end
  end
end
