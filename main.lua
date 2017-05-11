require "moremath"
require "timer"
require "sticks"

PLAYER_SPEED = 250

BULLET_SPEED = 400
BULLET_RATE = 0.1

ENEMY_SIZE = 10
ENEMY_SPEED = 4
ENEMY_RATE = 0.2

function reset()
  timer.reset("shoot")
  timer.reset("spawnEnemy")

  player = {x = 400, y = 400, size = 2}
  bullets = {}
  enemies = {}
end

function love.load()
  reset()
end

function love.joystickaxis(joystick, axis, value)
  sticks.update(joystick, axis, value)
end

function love.update(dt)
  timer.update(dt)

  player.x, player.y = sticks.move(player.x, player.y, dt, PLAYER_SPEED)
  local shootAngle = sticks.shoot()

  if shootAngle and timer.check("shoot", BULLET_RATE) then
    table.insert(bullets, {
      x = player.x,
      y = player.y,
      dx = math.cos(shootAngle) * BULLET_SPEED,
      dy = math.sin(shootAngle) * BULLET_SPEED
    })
  end

  if timer.check("spawnEnemy", ENEMY_RATE) then
    local x, y = love.math.random(800), love.math.random(800)
    if math.absdist(player.x, player.y, x, y) > 300 then
      table.insert(enemies, {x = x, y = y})
    end
  end

  for i, b in ipairs(bullets) do
    b.x, b.y = b.x + (b.dx * dt), b.y + (b.dy * dt)
  end

  for i, e in ipairs(enemies) do
    local angle = math.atan2(e.y - player.y, e.x - player.x)
    e.x = e.x - math.cos(angle) * ENEMY_SPEED
    e.y = e.y - math.sin(angle) * ENEMY_SPEED

    for j, b in ipairs(bullets) do
      if math.absdist(e.x, e.y, b.x, b.y) <= player.size + ENEMY_SIZE then
        table.remove(enemies, i)
        table.remove(bullets, j)
        player.size = player.size + 0.1
      end
    end

    if math.absdist(player.x, player.y, e.x, e.y) <= player.size + ENEMY_SIZE then
      table.remove(enemies, i)
      player.size = 2
    end
  end
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  for i, b in ipairs(bullets) do
    love.graphics.circle("fill", b.x, b.y, player.size)
	end

  love.graphics.setColor(0, 255, 255)
  love.graphics.circle("fill", player.x, player.y, player.size)

  love.graphics.setColor(255, 0, 0)
	for i, e in ipairs(enemies) do
    love.graphics.circle("fill", e.x, e.y, ENEMY_SIZE)
	end
end
