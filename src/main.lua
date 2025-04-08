local screen = require('screen')
local mouseAndTouch = require('mouseAndTouch')
local la = love.audio
local le = love.event
local lg = love.graphics
local lw = love.window
local round, play
local doneSfx, tickSfx
local font, sfx, save, W, H, W2, H2, w, h, iw, ih
local rest, exercises, exerciseSecs, restSecs, atRest, running, currEx
local iw, ih, img

round = function(num, idp)
  local mult = 10 ^ (idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

play = function(isDone)
  local s
  if isDone then
    s = doneSfx
  else
    s = tickSfx
  end
  if s:isPlaying() then
    s:stop()
  end
  return s:play()
end

local t = 0
W = 400
H = 400
W2 = W / 2
H2 = H / 2
iw = 200
ih = 200
atRest = true
running = true
exerciseSecs = 30
restSecs = 10

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
local imgs = { }

love.load = function()
  font = lg.newImageFont('images/font1.png', " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
  lg.setFont(font)
  tickSfx = la.newSource('sounds/tick.ogg', 'static')
  doneSfx = la.newSource('sounds/done.ogg', 'static')
  for i = 1, 12 do
    imgs[i] = lg.newImage("images/" .. tostring(i) .. ".png")
  end
  lw.setTitle('7 min workout')
  w, h = screen.getHighestResolution()
  return screen.setSize(w, h, W, H)
end

love.update = function(dt)
  if running then
    t = t + dt
    local wentOver = true
    if atRest and t > restSecs then
      atRest = false
    else
      if not atRest and t > exerciseSecs then
        currEx = currEx + 1
        atRest = true
        if currEx > 12 then
          running = false
          currEx = 1
        end
      else
        wentOver = false
      end
    end
    if wentOver then
      if atRest then
        play(true)
      end
      t = 0
    else
      if not atRest and not (math.floor(t) == math.floor(t - dt)) then
        return play(false)
      end
    end
  end
end

love.draw = function()
  local pi2, r, y1, y2, y3, dy, action
  dy = 20
  y1 = dy * 1
  y2 = dy * 2
  y3 = H - dy * 2.5
  pi2 = 3.1415927 * 2
  screen.startDraw()
  lg.setColor(255, 255, 255)
  lg.rectangle('fill', 0, 0, W, H)

  if atRest then
    lg.setBlendMode('alpha', 'premultiplied')
    lg.setColor(96, 96, 96)
    lg.draw(imgs[currEx], W2, H2, 0, 0.75, 0.75, iw / 2, ih / 2)
    lg.setBlendMode('alpha', 'alphamultiply')
  else
    lg.draw(imgs[currEx], W2, H2, 0, 0.75, 0.75, iw / 2, ih / 2)
  end

  lg.setLineWidth(5)
  local top

  if atRest then
    top = restSecs
  else
    top = exerciseSecs
  end

  lg.setColor(200, 0, 200)
  r = currEx / 12
  if atRest then
    r = r - (1 / 24)
  end
  lg.arc('line', 'open', W2, H2, 197.5, pi2, (1 - r) * pi2, 64)
  lg.setColor(0, 200, 200)
  r = t / top
  lg.arc('line', 'open', W2, H2, 192.5, pi2, (1 - r) * pi2, 64)
  lg.setColor(255, 255, 255)
  local tt = top - t
  lg.printf("time left: " .. tostring(round(tt, 0)), 0, y1, W, 'center')

  if atRest then
    lg.printf(tostring(rest) .. " (" .. tostring(exercises[currEx]) .. ")", 0, y2, W, 'center')
  else
    lg.printf(exercises[currEx], 0, y2, W, 'center')
  end

  if running then
    action = 'pause'
  else
    action = 'resume'
  end
  
  lg.printf("click/touch to " .. tostring(action), 0, y3, W, 'center')
  return screen.endDraw()
end

love.keypressed = function(k)
  if k == 'escape' then
    return le.quit()
  end
end

love.pressed = function(x, y)
  running = not running
end
return mouseAndTouch(love, screen)

