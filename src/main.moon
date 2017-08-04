screen = require 'screen'
mouseAndTouch = require 'mouseAndTouch'

la = love.audio
le = love.event
lg = love.graphics
lw = love.window

local round, play
local doneSfx, tickSfx
local font, sfx, save, W, H, W2, H2, w, h, iw, ih
local rest, exercises, exerciseSecs, restSecs, atRest, running, currEx
local iw, ih, img

round = (num, idp) ->
  mult = 10^(idp or 0)
  math.floor(num * mult + 0.5) / mult

play = (isDone) ->
  local s
  if isDone
    s = doneSfx
  else
    s = tickSfx
  if s\isPlaying!
    s\stop!
  s\play!

t = 0

W = 400
H = 400
W2 = W / 2
H2 = H / 2

iw = 400
ih = 400

atRest = true
running = true

exerciseSecs = 30
restSecs     = 10

exercises = {
  'jumping jacks',
  'wall sit',
  'push-up',
  'abdominal crunch',
  'step-up onto chair',
  'squat',
  'triceps dip on chair',
  'plank',
  'high knees running',
  'lunge',
  'push-up and rotation',
  'crunch'
}

rest = 'rest'

currEx = 1

imgs = {}

love.load = () ->
  font = lg.newImageFont 'images/font1.png', " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\""
  lg.setFont font
  tickSfx = la.newSource 'sounds/tick.ogg', 'static'
  doneSfx = la.newSource 'sounds/done.ogg', 'static'
  for i = 1, 12
    imgs[i] = lg.newImage "images/#{i}.png"

  lw.setTitle '7 min workout'
  w, h = screen.getHighestResolution!
  --w, h = 640,480 -- @TODO change due to windows problems
  screen.setSize w, h, W, H


love.update = (dt) ->
  if running
    t += dt
    wentOver = true

    if atRest and t > restSecs
      atRest = false
    else if not atRest and t > exerciseSecs
      currEx += 1
      atRest = true
      if currEx > 12
        running = false
        currEx = 1
    else
      wentOver = false

    if wentOver
      if atRest
        play true
      t = 0
    else if not atRest and not ( math.floor(t) == math.floor(t - dt) )
      play false


love.draw = () ->
  local pi2, r, y1, y2, y3, dy, action
  dy = 20
  y1 = dy * 1
  y2 = dy * 2
  y3 = H - dy * 2.5

  pi2 = 3.1415927*2

  screen.startDraw!

  lg.setColor 255, 255, 255
  lg.rectangle 'fill', 0, 0, W, H

  if atRest
    lg.setBlendMode 'alpha', 'premultiplied'
    lg.setColor 96, 96, 96--, 0.5
    lg.draw imgs[currEx], W2, H2, 0, 0.75, 0.75, iw/2, ih/2
    lg.setBlendMode 'alpha', 'alphamultiply'
  else
    lg.draw imgs[currEx], W2, H2, 0, 0.75, 0.75, iw/2, ih/2

  lg.setLineWidth 5
  top = if atRest then restSecs else exerciseSecs

  -- task ring
  lg.setColor 200, 0, 200
  r = currEx/12
  if atRest
    r -= 1/24
  lg.arc 'line', 'open', W2, H2, 197.5, pi2, (1-r) * pi2, 64

  -- secs ring
  lg.setColor 0, 200, 200
  r = t / top
  lg.arc 'line', 'open', W2, H2, 192.5, pi2, (1-r) * pi2, 64

  -- labels
  lg.setColor 255, 255, 255

  tt = top - t
  lg.printf "time left: #{round(tt, 0)}", 0, y1, W, 'center'

  if atRest
    lg.printf "#{rest} (#{exercises[currEx]})", 0, y2, W, 'center'
  else
    lg.printf exercises[currEx], 0, y2, W, 'center'

  if running
    action = 'pause'
  else
    action = 'resume'

  lg.printf "click/touch to #{action}", 0, y3, W, 'center'

  screen.endDraw!


love.keypressed = (k) ->
  if k == 'escape'
    le.quit!


love.pressed = (x, y) ->
  running = not running


mouseAndTouch love, screen
