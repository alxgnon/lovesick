local Top         = {0.02, 0.00,  0.98, 0.00,  0.78, 0.11,  0.22, 0.11}
local TopLeft     = {0.00, 0.02,  0.20, 0.13,  0.20, 0.42,  0.10, 0.48,  0.00, 0.42}
local TopRight    = {0.80, 0.13,  1.00, 0.02,  1.00, 0.42,  0.90, 0.48,  0.80, 0.42}
local Middle      = {0.12, 0.50,  0.22, 0.44,  0.78, 0.44,  0.88, 0.50,  0.78, 0.56,  0.22, 0.56}
local BottomLeft  = {0.00, 0.58,  0.10, 0.52,  0.20, 0.58,  0.20, 0.87,  0.00, 0.98}
local BottomRight = {0.80, 0.58,  0.90, 0.52,  1.00, 0.58,  1.00, 0.98,  0.80, 0.87}
local Bottom      = {0.02, 1.00,  0.22, 0.89,  0.78, 0.89,  0.98, 1.00}

local Zero  = {on = {Top, TopLeft, TopRight, BottomLeft, BottomRight, Bottom},  off = {Middle}}
local One   = {on = {TopRight, BottomRight},  off = {Top, TopLeft, Middle, BottomLeft, Bottom}}
local Two   = {on = {Top, TopRight, Middle, BottomLeft, Bottom},  off = {TopLeft, BottomRight}}
local Three = {on = {Top, TopRight, Middle, BottomRight, Bottom},  off = {TopLeft, BottomLeft}}
local Four  = {on = {TopLeft, TopRight, Middle, BottomRight},  off = {Top, BottomLeft, Bottom}}
local Five  = {on = {Top, TopLeft, Middle, BottomRight, Bottom},  off = {TopRight, BottomLeft}}
local Six   = {on = {Top, TopLeft, Middle, BottomLeft, BottomRight, Bottom},  off = {TopRight}}
local Seven = {on = {Top, TopRight, BottomRight},  off = {TopLeft, Middle, BottomLeft, Bottom}}
local Eight = {on = {Top, TopLeft, TopRight, Middle, BottomLeft, BottomRight, Bottom},  off = {}}
local Nine  = {on = {Top, TopLeft, TopRight, Middle, BottomRight, Bottom},  off = {BottomLeft}}

local Digits = {Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine}


lcd = {}

local function scale(source, x, y, w, h)
    local vertices = {}

    for i, v in ipairs(source) do
      if i % 2 == 1 then
        vertices[i] = x + v * w
      else
        vertices[i] = y + v * h
      end
    end

    return vertices
end

local function drawDigit(digit, x, y, w, h, bgColor, fgColor)
  local sources = Digits[digit + 1]

  love.graphics.setColor(bgColor)
  for _, source in ipairs(sources.off) do
    love.graphics.polygon("fill", scale(source, x, y, w, h))
  end

  love.graphics.setColor(fgColor)
  for _, source in ipairs(sources.on) do
    love.graphics.polygon("fill", scale(source, x, y, w, h))
  end
end

local function drawPair(number, x, y, w, h, bgColor, fgColor)
  local u, v = w / 20, w / 2
  drawDigit(math.floor(number / 10), x, y, v - u, h, bgColor, fgColor)
  drawDigit(math.floor(number % 10), x + v + u, y, v - u, h, bgColor, fgColor)
end

function lcd.draw(o)
  drawPair(
    o.number or 0,
    o.x or 0, o.y or 0, o.w or 100, o.h or 100,
    o.bgColor or {50, 50, 50}, o.fgColor or {255, 255, 255}
  )
end
