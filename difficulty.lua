difficulty = {}

local levels = {
  {pawnSpeed = 2.00},
  {pawnSpeed = 2.30},
  {pawnSpeed = 2.70},
  {pawnSpeed = 3.00},
  {pawnSpeed = 3.20},

  {pawnSpeed = 3.40},
  {pawnSpeed = 3.60},
  {pawnSpeed = 3.80},
  {pawnSpeed = 4.00},
  {pawnSpeed = 4.05},

  {pawnSpeed = 4.10},
  {pawnSpeed = 4.15},
  {pawnSpeed = 4.20},
  {pawnSpeed = 4.25},
  {pawnSpeed = 4.30},

  {pawnSpeed = 4.31},
  {pawnSpeed = 4.32},
  {pawnSpeed = 4.33},
  {pawnSpeed = 4.34},
  {pawnSpeed = 4.35},

  {pawnSpeed = 4.36},
  {pawnSpeed = 4.37},
  {pawnSpeed = 4.38},
  {pawnSpeed = 4.39},
  {pawnSpeed = 4.40},
}

local time = 0
local lastLevel = 0

function difficulty.reset()
  time = 0
  lastLevel = -1
  difficulty.update(0)
end

function difficulty.update(dt)
  time = time + dt
  local level = math.floor(time / 10)
  
  if level > lastLevel then
    lastLevel = level
    local lv = levels[level + 1]

    if lv then
      difficulty.pawnSpeed = lv.pawnSpeed or difficulty.pawnSpeed
    end
  end
end
