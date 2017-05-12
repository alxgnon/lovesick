difficulty = {}

local levels = {
  {pawnSpeed = 2.000},
  {pawnSpeed = 2.300},
  {pawnSpeed = 2.700},
  {pawnSpeed = 3.000},
  {pawnSpeed = 3.200},

  {pawnSpeed = 3.400},
  {pawnSpeed = 3.600},
  {pawnSpeed = 3.800},
  {pawnSpeed = 4.000},
  {pawnSpeed = 4.050},

  {pawnSpeed = 4.100},
  {pawnSpeed = 4.150},
  {pawnSpeed = 4.200},
  {pawnSpeed = 4.250},
  {pawnSpeed = 4.300},

  {pawnSpeed = 4.310},
  {pawnSpeed = 4.320},
  {pawnSpeed = 4.330},
  {pawnSpeed = 4.340},
  {pawnSpeed = 4.350},

  {pawnSpeed = 4.355},
  {pawnSpeed = 4.360},
  {pawnSpeed = 4.365},
  {pawnSpeed = 4.370},
  {pawnSpeed = 4.475},

  {pawnSpeed = 4.380},
  {pawnSpeed = 4.385},
  {pawnSpeed = 4.390},
  {pawnSpeed = 4.395},
  {pawnSpeed = 4.400},

  {pawnSpeed = 4.405},
  {pawnSpeed = 4.410},
  {pawnSpeed = 4.415},
  {pawnSpeed = 4.420},
  {pawnSpeed = 4.425},

  {pawnSpeed = 4.430},
  {pawnSpeed = 4.435},
  {pawnSpeed = 4.440},
  {pawnSpeed = 4.445},
  {pawnSpeed = 4.450},

  {pawnSpeed = 4.455},
  {pawnSpeed = 4.460},
  {pawnSpeed = 4.465},
  {pawnSpeed = 4.470},
  {pawnSpeed = 4.475}
}

local score = 0
local lastLevel = 0

function difficulty.reset()
  score = 0
  lastLevel = -1
  difficulty.update(0)
end

function difficulty.update(s)
  score = s
  local level = math.floor(score / 10)
  
  if level > lastLevel then
    lastLevel = level
    local lv = levels[level + 1]
    if not lv then
      lv = levels[table.getn(levels)]
    end

    difficulty.pawnSpeed = lv.pawnSpeed or difficulty.pawnSpeed
  end
end
