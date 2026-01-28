adb = {}

function adb.get_version()
	local result = io.popen("adb --version")
	local out = {}
	for line in result:lines() do
		table.insert(out, line)
	end
	local ok, _, code = result:close()
	return ok, code, out[2]
end


function adb.listen_devices()
	local output = io.popen("adb devices")
	devices = {}
	for line in output:lines() do
		-- skip first line 
		if line:sub(1, #"List") ~= "List" then
			table.insert(devices, line)
		end
	end 
	local ok, _, code = output:close()
	return ok, code, devices
end


function adb.restart_device()
	local output = io.popen("adb reboot")
	ok, _, code = output:close()
	return code
end

function adb.fs()

	local fs = { 
		default_dst = "/sdcard/documents"
	}

	function fs:push(src, dst) 
		local dst = dst or self.default_dst
		local cmd = string.format("adb push %s %s 2>&1", src, dst)
		local pipe = io.popen(cmd)
		local output = pipe:read("*a")
		ok, _, code = pipe:close()
		return ok
	end

	function fs:pull(src, dst)
		local cmd = string.format("adb pull %s %s 2>&1", src, dst)
		local pipe = io.popen(cmd)
		local output = pipe:read("*a")
		ok, _, code = pipe:close()
		return ok
	end

	return fs
end

function adb.utils()

	local utils = {
		default_dir = "/sdcard/documents/"
	}

	function utils:screencap(filename)
		local filename = filename or "file.png"
		local dst = self.default_dir .. filename
		local cmd = string.format("adb shell screencap %s", dst)
		local pipe = io.popen(cmd)
		local ok, _, code = pipe:close()
		return ok, dst
	end

	function utils:screenrecord(filename)
		local filename = filename or "file.mp4"
		local dst = self.default_dir .. filename
		local cmd = string.format("adb shell screenrecord %s", dst)
		local pipe = io.popen(cmd)
		local ok, _, code = pipe:close()
		return ok, dst
	end

	function utils:ls(dir)
		local dir = dir or self.default_dir
		local cmd = string.format("adb shell ")
	end

	return utils
end


return adb





