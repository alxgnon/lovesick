timer = {}

local timers = {}
local lastValue = {}

function timer.reset(name)
  timers[name] = 0
  lastValue[name] = 0
end

function timer.update(dt)
  for name, time in pairs(timers) do
    timers[name] = time + dt
  end
end

function timer.check(name, time)
  if timers[name] < time then
    return false
  end
  timer.reset(name)
  return true
end

function timer.peek(name)
  return timers[name]
end

function timer.tick(name, secondSfx, tenSecondsSfx, hundredSecondsSfx)
  local value = math.floor(timers[name])
  if value > lastValue[name] then
    lastValue[name] = value
    if value % 100 == 0 then
      hundredSecondsSfx:play()
    elseif value % 10 == 0 then
      tenSecondsSfx:play()
    else
      secondSfx:play()
    end
  end
end
