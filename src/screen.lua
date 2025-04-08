local lg = love.graphics
local lw = love.window
local w, h, W, H
local scale, x, y
local canvas

-- maximizes the screen to the dimensions given in setSize's _w and _h
-- use getHighestResolution to obtain values to put in setSize's _W and _H
-- setSize is expected to be called once
-- in the love.draw function, drawing calls should be placed between
-- startDraw and endDraw calls
-- use coords to map screen size to desired screen size

local getHighestResolution
getHighestResolution = function()
  local wi, hi, area = 640, 480, 0
  local modes = lw.getFullscreenModes()
  for _, m in ipairs(modes) do
    local areaT = m.width * m.height
    if areaT > area then
      wi = m.width
      hi = m.height
      area = areaT
    end
  end
  return wi, hi
end

local setSize
setSize = function(_W, _H, _w, _h, fullscreen)
  if fullscreen == nil then
    fullscreen = true
  end
  w, h = _w, _h
  local ar = _w / _h
  W, H = _W, _H
  local AR = W / H
  if AR > ar then
    scale = H / h
    y = 0
    x = (W - w * scale) / 2
  else
    scale = W / w
    x = 0
    y = (H - h * scale) / 2
  end
  lw.setMode(W, H, {
    fullscreen = fullscreen
  })
  canvas = lg.newCanvas(w, h)
  return canvas:setFilter('nearest')
end

local startDraw
startDraw = function()
  lg.setCanvas(canvas)
  return lg.clear(0, 0, 0, 0)
end

local endDraw
endDraw = function()
  lg.setCanvas()
  return lg.draw(canvas, x, y, 0, scale, scale)
end

local coords
coords = function(_x, _y)
  _x = (_x - x) / scale
  _y = (_y - y) / scale
  return _x, _y
end

return {
  getHighestResolution = getHighestResolution,
  setSize = setSize,
  startDraw = startDraw,
  endDraw = endDraw,
  coords = coords
}

