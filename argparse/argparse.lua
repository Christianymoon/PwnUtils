argparse = {}


function argparse.ArgumentParse(args)
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

return argparse