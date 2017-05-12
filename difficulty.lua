difficulty = {}

local levels = {
  {pawnSpeed = 0.4, pawnRate = 0.1},
  {},
  {pawnSpeed = 0.2, pawnRate = 0.05},
  {},
  {pawnSpeed = 0.1, pawnRate = 0.02},
  {},

  {},
  {},
  {pawnSpeed = 0.025, pawnRate = 0.005}
}

local score = 0

function difficulty.reset()
  score = 0
  lastLevel = -1
end

function difficulty.update(s)
  score = s
  local level = math.floor(score / 10)

  difficulty.pawnSpeed = 2.4
  difficulty.pawnRate = 0.6

  local pawnSpeed = 0
  local pawnRate = 0

  for i = 0, level do
    local lv = levels[i]
    if i > 0 then
      if lv then
        pawnSpeed = lv.pawnSpeed or pawnSpeed
        pawnRate = lv.pawnRate or pawnRate
      end

      difficulty.pawnSpeed = difficulty.pawnSpeed + pawnSpeed
      difficulty.pawnRate = difficulty.pawnRate - pawnRate
    end
  end
end
