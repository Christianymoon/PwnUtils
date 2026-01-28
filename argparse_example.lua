local utils = require('argparse.argparse')

argparse = utils.ArgumentParse(arg)
argparse.setopts("h", "This call helps")
argparse.setopts("a", "This are doing a parameter")
argparse.setopts("b", "This are doing b parameter")
argparse.setopts("c", "This are doing c parameter")
argparse.setopts("v", "Verbosity")

if argparse.verify("-h") then
	argparse.help() -- Prints help for the user in the console
end

if argparse.verify("-c") then -- Verify if is registered and is declared on script
	print("Execute -c option successfully")
end

if argparse.verify("-b") then
	print("Execute -b option successfully")
end

if argparse.verify("-v") then
	print("Verbosity habilited")
end
