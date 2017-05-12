require "difficulty"
require "lcd"
require "moremath"
require "sticks"
require "timer"

STROKE = 3

PLAYER_SIZE = 15
PLAYER_CORE = 4
PLAYER_SPEED = 250

PLAYER_RANKS = {
  {0, 170, 255},
  {0, 255, 170},
  {255, 210, 0},
  {240, 0, 255},
  {255, 130, 0}
}

BULLET_SPEED = 400
BULLET_RATE = 0.1

PAWN_SIZE = 10

function reset()
  difficulty.reset()

  timer.reset("shoot")
  timer.reset("spawnPawn")

  player = {x = WIDTH / 2, y = HEIGHT / 2, r = 0}
  bullets = {}
  pawns = {}
end

function love.load()
  explosionSfx = love.audio.newSource("assets/explosion.wav", "static")
  explosionSfx:setVolume(0.2)
  hitSfx = love.audio.newSource("assets/hit.wav", "static")
  hitSfx:setVolume(0.1)
  shootSfx = love.audio.newSource("assets/shoot.wav", "static")
  secondSfx = love.audio.newSource("assets/second.wav", "static")
  secondSfx:setVolume(0.05)
  tenSecondsSfx = love.audio.newSource("assets/tenSeconds.wav", "static")
  tenSecondsSfx:setVolume(0.06)
  hundredSecondsSfx = love.audio.newSource("assets/hundredSeconds.wav", "static")
  hundredSecondsSfx:setVolume(0.1)

  WIDTH, HEIGHT = love.graphics.getDimensions()
  ENEMY_SPAWNS = {-25, WIDTH + 25}
  reset()
  timer.reset("score")

  love.graphics.setBackgroundColor(0, 8, 8)
end

function love.joystickaxis(joystick, axis, value)
  sticks.update(joystick, axis, value)
end

function love.joystickpressed(joystick, button)
  if dead then
    if (button == 9 or button == 10) and not selectScore then
      reset()
      timer.reset("score")
    end

    if button == 9 then
      timer.add("score", 10)
      selectScore = true
    elseif button == 10 then
      playing = true
      dead = false
    end
  else
    if button == 10 then
      playing = not playing
    end
  end
end

function love.focus(f)
  if not f then
    playing = false
  end
end

function love.update(dt)
  if playing then
    timer.update(dt)
    difficulty.update(timer.peek("score"))

    if sticks.shoot() then
      player.x, player.y = sticks.move(player.x, player.y, dt, PLAYER_SPEED)
    else
      player.x, player.y = sticks.move(player.x, player.y, dt, PLAYER_SPEED * 1.25)
    end

    player.x = math.min(math.max(player.x, 0), WIDTH)
    player.y = math.min(math.max(player.y, 0), HEIGHT)
    player.r = sticks.point()

    if sticks.shoot() then
      local aim = sticks.aim()
      local power = sticks.power()

      if timer.check("shoot", BULLET_RATE + power * 0.15) then
        shootSfx:setVolume(0.02 + power * 0.04)
        shootSfx:setPitch(1 - power * 0.1)
        shootSfx:play()

        table.insert(bullets, {
          power = power,
          x = player.x,
          y = player.y,
          dx = math.cos(aim) * BULLET_SPEED,
          dy = math.sin(aim) * BULLET_SPEED,
          size = 4 + power * 10
        })
      end
    end

    if timer.check("spawnPawn", difficulty.pawnRate) then
      local x = ENEMY_SPAWNS[love.math.random(2)]
      local y = love.math.random(HEIGHT * 1.2) - HEIGHT * 0.1
      table.insert(pawns, {x = x, y = y, r = 0})
    end

    for i, b in ipairs(bullets) do
      b.x, b.y = b.x + (b.dx * dt), b.y + (b.dy * dt)
      if b.x > WIDTH + 100 or b.x < -100 or b.y > HEIGHT + 100 or b.y < -100 then
        table.remove(bullets, i)
      end
    end

    for i, e in ipairs(pawns) do
      e.r = math.atan2(e.y - player.y, e.x - player.x)
      e.x = e.x - math.cos(e.r) * difficulty.pawnSpeed
      e.y = e.y - math.sin(e.r) * difficulty.pawnSpeed

      if math.absdist(player.x, player.y, e.x, e.y) <= PLAYER_CORE + PAWN_SIZE then
        explosionSfx:play()
        playing = false
        dead = true
        selectScore = false
      end

      for j, b in ipairs(bullets) do
        if math.absdist(e.x, e.y, b.x, b.y) <= b.size + PAWN_SIZE then
          hitSfx:play()
          table.remove(pawns, i)

          if b.power > 0.25 then
            b.power = b.power - 0.5
            b.size = 4 + b.power * 10
          else
            table.remove(bullets, j)
          end
        end
      end
    end
  end
end

function love.draw()
  timer.tick("score", secondSfx, tenSecondsSfx, hundredSecondsSfx)

  lcd.draw{
    number = timer.peek("score"),
    x = WIDTH / 14, y = HEIGHT / 14,
    w = 6 * WIDTH / 7, h = 6 * WIDTH / 7,
    bgColor = {8, 15, 15}, fgColor = {25, 45, 45}
  }

  love.graphics.setColor(255, 255, 255)
  for i, b in ipairs(bullets) do
    love.graphics.circle("fill", b.x, b.y, b.size)
  end

  local rank = math.floor(timer.peek("score") / 100 % table.getn(PLAYER_RANKS)) + 1

  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_SIZE + STROKE))
  love.graphics.setColor(PLAYER_RANKS[rank])
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_SIZE))
  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_CORE + STROKE))
  love.graphics.setColor(255, 255, 255)
  love.graphics.polygon("fill", math.regular(player.x, player.y, player.r, 4, PLAYER_CORE))

  for i, e in ipairs(pawns) do
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", math.regular(e.x, e.y, e.r + math.pi/3, 3, PAWN_SIZE + STROKE))
    love.graphics.setColor(255, 130, 0)
    love.graphics.polygon("fill", math.regular(e.x, e.y, e.r + math.pi/3, 3, PAWN_SIZE))
  end
end
