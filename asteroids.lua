local create_interval = 0.5
local roid = { speed = 200, img = nil, active_asteroids = {}, lost_roid_cb = nil }
local create_timer = create_interval

asteroids = roid

function roid.load(arg)
   roid.img = love.graphics.newImage('images/asteroid.png')
end

function roid.create(dt)
   create_timer = create_timer - (1 * dt)
   if create_timer < 0 then
      -- Create new enemy
      local rnd_num = math.random(0, love.graphics.getWidth() -
				     roid.img:getWidth())
      new_asteroid = { x = rnd_num, y = -100, img = roid.img }
      table.insert(roid.active_asteroids, new_asteroid)
      create_timer = create_interval
   end
end

function roid.set_decrease_score_cb(cb)
   roid.lost_roid_cb = cb
end

function roid.move(dt)
   for i, asteroid in ipairs(roid.active_asteroids) do
      asteroid.y = asteroid.y + (roid.speed * dt)
      if (asteroid.y > love.graphics.getHeight()) then
	     table.remove(roid.active_asteroids, i)
	     if roid.lost_roid_cb ~= nil then
		roid.lost_roid_cb()
	     end
      end
   end
end

function roid.draw(dt)
   for i, asteroid in ipairs(roid.active_asteroids) do
      love.graphics.draw(asteroid.img, asteroid.x, asteroid.y)
   end
end

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
local function check_collision(x1, y1, w1, h1, x2, y2, w2, h2)
   return x1 < x2+w2 and
      x2 < x1+w1 and
      y1 < y2+h2 and
      y2 < y1+h1
end

function roid.check_collision(x, y, w, h)
   for i, asteroid in ipairs(roid.active_asteroids) do
      if check_collision(x, y, w, h, asteroid.x, asteroid.y,
			 asteroid.img:getWidth(), asteroid.img:getHeight()) then
	 table.remove(roid.active_asteroids, i)
	 return true
      end
   end
   return false
end

function roid.reset()
   roid.active_asteroids = {}
end

return roid
