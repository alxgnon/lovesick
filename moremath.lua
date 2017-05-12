function math.dist(x1, y1, x2, y2)
  return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function math.absdist(x1, y1, x2, y2)
  return math.abs(math.dist(x1, y1, x2, y2))
end

function math.regular(x, y, r, n, s)
    local vertices = {}
    for i=0, n-1 do
        vertices[i*2+1] = x + s * math.cos(r + i * 2*math.pi/n)
        vertices[i*2+2] = y + s * math.sin(r + i * 2*math.pi/n)
    end
    return vertices
end
