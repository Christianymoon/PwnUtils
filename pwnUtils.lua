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


function pwnUtils.ArgumentParse(args)
	local parseOptions = {}
	local args = args

	function getHelp()
		io.write("Get Help using -h \n")
		for i, opt in ipairs(parseOptions) do
			io.write(string.format("[%d] Option: %s - %s\n", i, opt.option, opt.help))
		end
	end

	function verifyOpt(val)
		for i, arg in ipairs(args) do
			if arg == val then
				for j, opt in ipairs(parseOptions) do
					if opt.option == val then
						return true
					end
				end
			end
		end
		return false
	end

	return {
		setopts = function(letter, help)
			table.insert(parseOptions, { option = string.format('-%s', letter), help = help})
		end,
		getopts = function()
			return parseOptions
		end,
		setargs = function(args)
			args = args
		end,
		getargs = function()
			return args 
		end,
		verify = function(opt)
			return verifyOpt(opt)
		end,
		help = function()
			getHelp()
		end
	}
end

return pwnUtils







