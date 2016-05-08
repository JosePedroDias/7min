-- maximizes the screen to the dimensions given in setSize's _w and _h
-- use getHighestResolution to obtain values to put in setSize's _W and _H
-- setSize is expected to be called once
-- in the love.draw function, drawing calls should be placed between
-- startDraw and endDraw calls
-- use coords to map screen size to desired screen size

lg = love.graphics
lw = love.window
local w, h, W, H
local scale, x, y
local canvas

getHighestResolution = () ->
    wi, hi, area = 640, 480, 0
    modes = lw.getFullscreenModes!
    for _, m in ipairs modes
        areaT = m.width * m.height
        if areaT > area
            wi = m.width
            hi = m.height
            area = areaT
    wi, hi

setSize = (_W, _H, _w, _h, fullscreen=true) ->
    w, h = _w, _h
    ar = _w / _h

    W, H = _W, _H
    AR = W / H
    if AR > ar
        scale = H / h
        y = 0
        x = (W - w * scale) / 2
    else
        scale = W / w
        x = 0
        y = (H - h * scale) / 2

    lw.setMode W, H, {fullscreen:fullscreen}

    canvas = lg.newCanvas w, h
    canvas\setFilter 'nearest'

startDraw = () ->
    lg.setCanvas canvas
    lg.clear 0, 0, 0, 0

endDraw = () ->
    lg.setCanvas!
    lg.draw canvas, x, y, 0, scale, scale

coords = (_x, _y) ->
    _x = (_x - x) / scale
    _y = (_y - y) / scale
    _x, _y

{
    :getHighestResolution
    :setSize
    :startDraw
    :endDraw
    :coords
}
