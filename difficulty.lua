difficulty = {}

local levels = {
  {pawnSpeed = 2.000, pawnRate = 0.600},
  {pawnSpeed = 2.300, pawnRate = 0.570},
  {pawnSpeed = 2.700, pawnRate = 0.530},
  {pawnSpeed = 3.000, pawnRate = 0.500},
  {pawnSpeed = 3.200, pawnRate = 0.480},

  {pawnSpeed = 3.400, pawnRate = 0.460},
  {pawnSpeed = 3.600, pawnRate = 0.440},
  {pawnSpeed = 3.800, pawnRate = 0.420},
  {pawnSpeed = 4.000, pawnRate = 0.400},
  {pawnSpeed = 4.050, pawnRate = 0.390},

  {pawnSpeed = 4.100, pawnRate = 0.380},
  {pawnSpeed = 4.150, pawnRate = 0.370},
  {pawnSpeed = 4.200, pawnRate = 0.365},
  {pawnSpeed = 4.250, pawnRate = 0.360},
  {pawnSpeed = 4.300, pawnRate = 0.355},

  {pawnSpeed = 4.310, pawnRate = 0.350},
  {pawnSpeed = 4.320, pawnRate = 0.345},
  {pawnSpeed = 4.330, pawnRate = 0.340},
  {pawnSpeed = 4.340, pawnRate = 0.335},
  {pawnSpeed = 4.350, pawnRate = 0.330},

  {pawnSpeed = 4.355, pawnRate = 0.325},
  {pawnSpeed = 4.360, pawnRate = 0.320},
  {pawnSpeed = 4.365, pawnRate = 0.315},
  {pawnSpeed = 4.370, pawnRate = 0.310},
  {pawnSpeed = 4.475, pawnRate = 0.305},

  {pawnSpeed = 4.380, pawnRate = 0.300},
  {pawnSpeed = 4.385, pawnRate = 0.295},
  {pawnSpeed = 4.390, pawnRate = 0.290},
  {pawnSpeed = 4.395, pawnRate = 0.285},
  {pawnSpeed = 4.400, pawnRate = 0.280},

  {pawnSpeed = 4.405, pawnRate = 0.275},
  {pawnSpeed = 4.410, pawnRate = 0.270},
  {pawnSpeed = 4.415, pawnRate = 0.265},
  {pawnSpeed = 4.420, pawnRate = 0.260},
  {pawnSpeed = 4.425, pawnRate = 0.255},

  {pawnSpeed = 4.430, pawnRate = 0.250},
  {pawnSpeed = 4.435, pawnRate = 0.245},
  {pawnSpeed = 4.440, pawnRate = 0.240},
  {pawnSpeed = 4.445, pawnRate = 0.235},
  {pawnSpeed = 4.450, pawnRate = 0.230},

  {pawnSpeed = 4.455, pawnRate = 0.225},
  {pawnSpeed = 4.460, pawnRate = 0.220},
  {pawnSpeed = 4.465, pawnRate = 0.215},
  {pawnSpeed = 4.470, pawnRate = 0.210},
  {pawnSpeed = 4.475, pawnRate = 0.205}
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
    difficulty.pawnRate = lv.pawnRate or difficulty.pawnRate
  end
end
