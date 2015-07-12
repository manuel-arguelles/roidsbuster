local shooting_interval = 0.2

local sp = { x = 0, y = 0, speed = 150, img = nil, score = 0, alive = true,
             shooting_timer = shooting_interval, allow_shooting = true,
	     active_lasers = {}, shooting_sound = nil}

local laser = { x = 0, y = 0, speed = 200, img = nil }

spaceship = sp

function sp.load(arg)
   sp.img = love.graphics.newImage('images/spaceship.png')
   laser.img = love.graphics.newImage('images/laser.png')
   sp.x = (love.graphics:getWidth() / 2) - (sp.img:getWidth() / 2)
   sp.shooting_sound = love.audio.newSource('sounds/pitiu.ogg', 'static')
   --sp.shooting_sound = love.audio.newSource("sounds/pitiu.wav", 'static')
end

function sp.move_right(dt)
   if sp.x < (love.graphics.getWidth() - sp.img:getWidth()) then
      sp.x = sp.x + (sp.speed * dt)
   end
end

function sp.move_left(dt)
   if sp.x > 0 then
      sp.x = sp.x - (sp.speed * dt)
   end
end

function sp.draw(dt)
   if spaceship.alive then
      sp.y = love.graphics:getHeight() - sp.img:getHeight()
      love.graphics.draw(sp.img, sp.x, sp.y)
      for i, laser in ipairs(sp.active_lasers) do
	 love.graphics.draw(laser.img, laser.x, laser.y)
      end
   else
      love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50,
			  love.graphics:getHeight()/2-10)
   end
end

function sp.increase_score()
   sp.score = sp.score + 1
end

function sp.decrease_score()
   if sp.score > 0 then
      sp.score = sp.score - 1
   end
end

function sp.update_shooting_interval(dt)
   sp.shooting_timer = sp.shooting_timer - (1 * dt)
   if sp.shooting_timer < 0 then
      sp.allow_shooting = true
   end
end

function sp.shoot(dt)
   if sp.allow_shooting and sp.alive then
      -- Lets shoot
      new_laser = {
	 x = (sp.x + ((sp.img:getWidth()/2) - (laser.img:getWidth()/2))),
	 y = (sp.y - (laser.img:getHeight()/2)), speed = laser.speed,
	 img = laser.img }
      if sp.shooting_sound ~= nil then
	 sp.shooting_sound:rewind()
	 sp.shooting_sound:play()
      end
      table.insert(sp.active_lasers, new_laser)
      sp.shooting_timer = shooting_interval
      sp.allow_shooting = false
   end
end

function sp.move_lasers(dt)
   for i, d_laser in ipairs(sp.active_lasers) do
      d_laser.y = d_laser.y - (d_laser.speed * dt)
      if d_laser.y < 0 then
	 table.remove(sp.active_lasers, i)
      end
   end
end

function sp.get_lasers()
   return sp.active_lasers;
end

function sp.remove_laser(pos)
   table.remove(sp.active_lasers, pos)
end

function sp.killed()
   sp.alive = false
   sp.active_lasers = {}
end

function sp.revive()
   if not sp.alive then
      sp.x = (love.graphics:getWidth() / 2) - (sp.img:getWidth() / 2)
      sp.alive = true
      sp.score = 0
   end
end

return sp
