---@class Graphics
local Graphics = {}

function Graphics.init(video)
    Graphics.video = video
end

function Graphics.cls(color)
    Graphics.video:clear(color or 0)
end

function Graphics.color(color)
    color = color or 0
    Graphics.video:setColor(color)
end

function Graphics.pixel(x, y, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:setPixel(x, y, color)
    -- Graphics.video:setColor(currentColor)
end

function Graphics.print(text, x, y, color)
    x = x or 0
    y = y or 0
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawText(x, y, text, color)
end

function Graphics.line(x1, y1, x2, y2, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor

    Graphics.video:drawLine(x1, y1, x2, y2, color)
end

function Graphics.rect(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawRect(x, y, width, height, color)
end

function Graphics.rect_fill(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor

    Graphics.video:fillRect(x, y, width, height)
end


function Graphics.circle(cx, cy, radius, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawCircle(cx, cy, radius, color)
end

function Graphics.circle_fill(cx, cy, radius, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:fillCircle(cx, cy, radius, color)
end

function Graphics.ellipse(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor

    Graphics.video:drawEllipse(x, y, width, height)
end


function Graphics.ellipse_fill(x, y, width, height, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor

    Graphics.video:fillEllipse(x, y, width, height)
end


function Graphics.triangle(x1, y1, x2, y2, x3, y3, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawTriangle(x1, y1, x2, y2, x3, y3, color)
end

function Graphics.triangle_fill(x1, y1, x2, y2, x3, y3, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:fillTriangle(x1, y1, x2, y2, x3, y3, color)
end

function Graphics.polygone(points, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:drawPolygon(points, color)
end

function Graphics.polygone_fill(points, color)
    local currentColor = Graphics.video:getColor()
    color = color or currentColor
    Graphics.video:fillPolygon(points, color)
end

return Graphics
