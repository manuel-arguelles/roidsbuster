debug = true

local spaceship = require('spaceship')
local asteroids = require('asteroids')

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

   if love.keyboard.isDown('r') then
      spaceship.revive()
      asteroids.reset()
   end

end


function love.draw(dt)
   spaceship.draw(dt)
   asteroids.draw(dt)
end

