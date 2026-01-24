pwnUtils = {}

function pwnUtils.newAnimationBar(name)
	local frames = {'/', '|', '\\', '-'}
	local run = true
	local i = 1

	local animation = function()
		while run do
			io.write("\r[")
			io.write(frames[i])
			io.write(string.format("] %s", name))
			io.flush()

			i = (i % #frames) + 1
			coroutine.yield()
		end
	end

	local co = coroutine.create(animation)

	return {
		step = function()
			coroutine.resume(co)
		end,

		stop = function()
			run = false
		end
	}
end


function pwnUtils.newProgressBar(line, name)
	local progress = 0


	local bar = coroutine.create(function ()
		while progress <= 1 do 
			io.write(string.format("\27[%dA", line))
			io.write("\r\27[2k")
			io.write("[% ")
			io.write(string.format("%0.0f] %s\t\t", progress * 100, name))
			io.write(string.format("\27[%dB", line))
			io.flush()
			progress = coroutine.yield()
		end
	end)



	return {
		update = function(value)
			coroutine.resume(bar, value)
		end,

		get_progress = function()
			return progress * 100
		end,

		restart = function(value)
			progress = 0
		end
	}
end

return pwnUtils







