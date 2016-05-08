screen = require 'screen'
mouseAndTouch = require 'mouseAndTouch'

local round, play
local doneSfx, tickSfx

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

la = love.audio
le = love.event
lg = love.graphics
lw = love.window
t = 0
local font, sfx, save, W, H, w, h
local rest, exercises, exerciseSecs, restSecs, atRest, running, currEx

local iw, ih, img

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
  tickSfx = la.newSource 'sounds/tick.wav', 'static'
  doneSfx = la.newSource 'sounds/done.wav', 'static'
  for i = 1, 12
    imgs[i] = lg.newImage "images/#{i}.png"

  lw.setTitle '7 min workout'
  W, H = screen.getHighestResolution!
  screen.setSize W, H, 400, 400


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
  screen.startDraw!

  lg.setColor 255, 255, 255
  lg.rectangle 'fill', 0, 0, W, H

  if atRest
    lg.setBlendMode 'alpha', 'premultiplied'
    lg.setColor 96, 96, 96--, 0.5
    lg.draw imgs[currEx], 200, 200, 0, 0.75, 0.75, 200, 200
    lg.setBlendMode 'alpha', 'alphamultiply'
  else
    lg.draw imgs[currEx], 200, 200, 0, 0.75, 0.75, 200, 200

  local pi2, r
  pi2 = 3.1415927*2
  lg.setLineWidth 5
  top = if atRest then restSecs else exerciseSecs

  -- task ring
  lg.setColor 200, 0, 200
  r = currEx/12
  lg.arc 'line', 'open', 200, 200, 197.5, pi2, (1-r) * pi2, 64

  -- secs ring
  lg.setColor 0, 200, 200
  r = t / top
  lg.arc 'line', 'open', 200, 200, 192.5, pi2, (1-r) * pi2, 64

  -- labels
  lg.setColor 255, 255, 255

  if atRest
    lg.print "#{rest} (#{exercises[currEx]})", 0, 20
  else
    lg.print exercises[currEx], 0, 20

  tt = top - t
  lg.print "time left: #{round(tt, 2)}", 0, 0

  screen.endDraw!


love.keypressed = (k) ->
  if k == 'escape'
    le.quit!


love.pressed = (x, y) ->
  running = not running


mouseAndTouch love, screen
