function love.load()
    love.window.setMode(800, 600, {resizable = true, vsync = 0, minwidth = 400, minheight = 300})
    image = love.graphics.newImage('image.png')
end

function love.update(dt)

end

function love.draw()
    love.graphics.draw(image, love.math.random(0, 800), love.math.random(0, 600))
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

    local fixed_dt = 1/60
    local accumulator = 0
    local current_time = love.timer.getTime()

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

        local new_time = love.timer.getTime()
        local frame_time = new_time - current_time
        current_time = new_time
        accumulator = accumulator + frame_time


        while accumulator >= fixed_dt do 
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
        end


        --Render once per frame. 
		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end