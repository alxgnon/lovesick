require "moremath"

sticks = {}

local MOVE_X = 1
local MOVE_Y = 2
local SHOOT_X = 4
local SHOOT_Y = 5
local POWER = 6

local axes = {0, 0, 0, 0, 0, 0}

function sticks.update(joystick, axis, value)
  axes[axis] = value
end

function sticks.direction()
  local sx, sy = axes[MOVE_X], axes[MOVE_Y]
  return math.atan2(sy, sx)
end

function sticks.is_moving()
  local sx, sy = axes[MOVE_X], axes[MOVE_Y]
  return math.absdist(0, 0, sx, sy) > 0.2
end

function sticks.movement(x, y, dt, speed)
  local sx, sy = axes[MOVE_X], axes[MOVE_Y]
  return x + sx * dt * speed, y + sy * dt * speed
end

function sticks.aim()
  local sx, sy = axes[SHOOT_X], axes[SHOOT_Y]
  return math.atan2(sy, sx)
end

function sticks.is_shooting()
  local sx, sy = axes[SHOOT_X], axes[SHOOT_Y]
  return math.absdist(0, 0, sx, sy) > 0.2
end

function sticks.power_level()
  return axes[POWER] + 1
end
