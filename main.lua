debug = true

local spaceship = require('spaceship')
local asteroids = require('asteroids')

-- Laser
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

-- Enemis
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemyImg = nil

enemies = {}

function love.load(arg)
   spaceship.load(arg)
   asteroids.load(arg)
   asteroids.set_decrease_score_cb(spaceship.decrease_score)
end


function love.update(dt)
   -- Exit the game
   if love.keyboard.isDown('escape', 'q') then
      love.event.push('quit')
   end

   if love.keyboard.isDown('left', 'a') then
      spaceship.move_left(dt)
   elseif love.keyboard.isDown('right', 'd') then
      spaceship.move_right(dt)
   end

   spaceship.update_shooting_interval(dt)
   if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl') then
    -- Shoot
      spaceship.shoot(dt)
   end

   spaceship.move_lasers(dt)

   asteroids.create(dt)

   asteroids.move(dt)

   -- enemies
--   createEnemyTimer = createEnemyTimer - (1 * dt)
--   if createEnemyTimer < 0 then
--      createEnemyTimer = createEnemyTimerMax

      -- create an enemy
--      randomNumber = math.random(10, love.graphics.getWidth() - 10)
--      newEnemy = { x = randomNumber, y = -100, img = enemyImg }
--      table.insert(enemies, newEnemy)
--   end

--   for i, enemy in ipairs(enemies) do
--      enemy.y = enemy.y + (200 * dt)
--      if enemy.y > 850 then
--	 table.remove(enemies, i)
--	 spaceship.decrease_score()
--      end
--   end

   local lasers_table = spaceship.get_lasers()
   for i, laser in ipairs(lasers_table) do
      if asteroids.check_collision(laser.x, laser.y, laser.img:getWidth(),
				   laser.img:getHeight()) then
	 spaceship.increase_score()
	 spaceship.remove_laser(i)
      end
   end

   if spaceship.alive and
      asteroids.check_collision(spaceship.x, spaceship.y,
				spaceship.img:getWidth(),
				spaceship.img:getHeight()) then
      spaceship.killed()
   end

--  for i, enemy in ipairs(enemies) do
--     for j, bullet in ipairs(bullets) do
--	 if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(),
--			   enemy.img:getHeight(), bullet.x, bullet.y,
--			   bullet.img:getWidth(), bullet.img:getHeight()) then
--	    table.remove(bullets, j)
--	    table.remove(enemies, i)
--	    spaceship.increase_score()
--	 end
--     end
--
--     if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(),
--			enemy.img:getHeight(), spaceship.x, spaceship.y,
--			spaceship.img:getWidth(), spaceship.img:getHeight()) and
--     isAlive then
--	 table.remove(enemies, i)
--	 isAlive = false
--     end
--  end
--
   if love.keyboard.isDown('r') then
      spaceship.revive()
      asteroids.reset()
   end

--     -- remove everything
--     bullets = {}
--     enemies = {}
--
--     -- reset timers
--     canShootTimer = canShootTimerMax
--     createEnemyTimer = createEnemyTimerMax
--
--     spaceship.x = 200
--     spaceship.y = 710
--
--     score = 0
--     spaceship.alive = true
--  end

end


function love.draw(dt)
   spaceship.draw(dt)
   asteroids.draw(dt)
--   for i, bullet in ipairs(bullets) do
--      love.graphics.draw(bullet.img, bullet.x, bullet.y)
--   end

--   for i, enemy in ipairs(enemies) do
--      love.graphics.draw(enemy.img, enemy.x, enemy.y)
--   end
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
   return x1 < x2+w2 and
      x2 < x1+w1 and
      y1 < y2+h2 and
      y2 < y1+h1
end
