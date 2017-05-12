require "lcd"
require "moremath"
require "sticks"
require "timer"

STROKE = 3

PLAYER_SIZE = 15
PLAYER_CORE = 4
PLAYER_SPEED = 250

BULLET_SPEED = 400
BULLET_RATE = 0.1

ENEMY_SIZE = 10
ENEMY_SPEED = 3
ENEMY_RATE = 0.4

function reset()
  timer.reset("shoot")
  timer.reset("spawnEnemy")

  score = 0
  player = {x = WIDTH / 2, y = HEIGHT / 2, r = 0}
  bullets = {}
  enemies = {}
end

function love.load()
  WIDTH, HEIGHT = love.graphics.getDimensions()
  ENEMY_SPAWNS = {-25, WIDTH + 25}
  reset()

  love.graphics.setBackgroundColor(0, 8, 8)
end

function love.joystickaxis(joystick, axis, value)
  sticks.update(joystick, axis, value)
end

function love.update(dt)
  timer.update(dt)

  player.x, player.y = sticks.move(player.x, player.y, dt, PLAYER_SPEED)
  player.x = math.min(math.max(player.x, 0), WIDTH)
  player.y = math.min(math.max(player.y, 0), HEIGHT)
  player.r = sticks.point()

  if sticks.shoot() then
    local aim = sticks.aim()
    if timer.check("shoot", BULLET_RATE) then
      table.insert(bullets, {
        x = player.x,
        y = player.y,
        dx = math.cos(aim) * BULLET_SPEED,
        dy = math.sin(aim) * BULLET_SPEED,
        size = 5
      })
    end
  end

  if timer.check("spawnEnemy", ENEMY_RATE) then
    local x = ENEMY_SPAWNS[love.math.random(2)]
    local y = love.math.random(HEIGHT * 1.5) - HEIGHT * 0.25
    table.insert(enemies, {x = x, y = y, r = 0})
  end

  for i, b in ipairs(bullets) do
    b.x, b.y = b.x + (b.dx * dt), b.y + (b.dy * dt)
    if b.x > WIDTH + 100 or b.x < -100 or b.y > HEIGHT + 100 or b.y < -100 then
      table.remove(bullets, i)
    end
  end

  for i, e in ipairs(enemies) do
    e.r = math.atan2(e.y - player.y, e.x - player.x)
    e.x = e.x - math.cos(e.r) * ENEMY_SPEED
    e.y = e.y - math.sin(e.r) * ENEMY_SPEED

    if math.absdist(player.x, player.y, e.x, e.y) <= PLAYER_CORE + ENEMY_SIZE then
      table.remove(enemies, i)
      score = 0
    end

    for j, b in ipairs(bullets) do
      if math.absdist(e.x, e.y, b.x, b.y) <= b.size + ENEMY_SIZE then
        table.remove(enemies, i)
        score = score + 1
      end
    end
  end
end

function love.draw()
  lcd.draw{
    number = score,
    x = WIDTH / 14, y = HEIGHT / 14,
    w = 6 * WIDTH / 7, h = 6 * WIDTH / 7,
    bgColor = {8, 20, 20}, fgColor = {25, 45, 45}
  }

  love.graphics.setColor(255, 255, 255)
  for i, b in ipairs(bullets) do
    love.graphics.circle("fill", b.x, b.y, b.size)
  end

  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_SIZE + STROKE))
  love.graphics.setColor(0, 170, 255)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_SIZE))
  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_CORE + STROKE))
  love.graphics.setColor(255, 255, 255)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_CORE))

  for i, e in ipairs(enemies) do
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", math.regular(e.x, e.y, e.r + math.pi/3, 3, ENEMY_SIZE + STROKE))
    love.graphics.setColor(255, 130, 0)
    love.graphics.polygon("fill", math.regular(e.x, e.y, e.r + math.pi/3, 3, ENEMY_SIZE))
  end
end
