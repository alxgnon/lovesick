require "moremath"

sticks = {}

local MOVE_X = 1
local MOVE_Y = 2
local SHOOT_X = 3
local SHOOT_Y = 6

local axes = {0, 0, 0, 0, 0, 0}

function sticks.update(joystick, axis, value)
  axes[axis] = value
end

function sticks.move(x, y, dt, speed)
  sx, sy = axes[MOVE_X], axes[MOVE_Y]
  return x + sx * dt * speed, y + sy * dt * speed
end

function sticks.shoot()
  sx, sy = axes[SHOOT_X], axes[SHOOT_Y]
  if math.absdist(0, 0, sx, sy) > 0.2 then
    return math.atan2(sy, sx)
  end
end
