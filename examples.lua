-- Examples

-- Create progressbar with animation
local utils = require('pwnUtils') -- Import module
local bar = utils.newAnimationBar("Charge...")

for i = 1, 10 do
	os.execute('sleep 1')
	bar.step()
end

bar.stop()


-- Create a progressbar with percentage
print("") -- line reserved 
local percentagebar = utils.newProgressBar(1, "Charge more...") -- number of line and text
percentagebar.update(0) -- Initialize the percentage

for i = 1, 10 do
	os.execute('sleep 0.5')
	percentagebar.update(i / 10) -- Update percentage from 0.0 to 1
end

