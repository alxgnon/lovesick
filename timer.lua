timer = {}

local timers = {}

function timer.reset(name)
  timers[name] = 0
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
