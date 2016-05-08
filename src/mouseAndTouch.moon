-- converts screen coords and applies unified logic to pressed, moved and released events,
-- whether they came from mouse or touch
-- assumes screen module to be in use already
-- (all these returns are here to avoid useless implicit returns as there functions will be called a lot. may be irrelevant)

(love, screen) ->
	if love.pressed
		pressed = (x, y) ->
			x, y = screen.coords x, y
			love.pressed x, y
			return

		love.mousepressed = (x, y, b, isTouch) ->
			if not isTouch
				pressed x, y
			return

		love.touchpressed = (id, x, y, pressure) ->
			pressed x, y
			return

	if love.moved
		moved = (x, y) ->
			x, y = screen.coords x, y
			love.moved x, y
			return

		love.mousemoved = (x, y, dx, dy) ->
			moved x, y
			return

		love.touchmoved = (id, x, y, pressure) ->
			moved x, y
			return

	if love.released
		released = (x, y) ->
			x, y = screen.coords x, y
			love.released x, y
			return

		love.mousereleased = (x, y, b, isTouch) ->
			if not isTouch
				released x, y
			return

		love.touchreleased = (id, x, y, pressure) ->
			released x, y
			return

	return
