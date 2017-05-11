function math.dist(x1, y1, x2, y2)
  return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function math.absdist(x1, y1, x2, y2)
  return math.abs(math.dist(x1, y1, x2, y2))
end
