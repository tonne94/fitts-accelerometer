-----------------------------------------------------------------------------------------
--
-- endgame.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

function scene:create(event)
	sceneGroup = self.view

	--x_submitted = event.params.x_submitted
	--y_submitted = event.params.y_submitted
	--x_real = event.params.x_real
	--y_real = event.params.y_real
	--numCircles = event.params.numCircles
	--time_submitted = event.params.time_submitted
	--switch = event.params.switch


	results = display.newText("", halfW, halfH, deafult, 20)

	--for i=0,numCircles,1 do
		--results.text=results.text.."\n".."["..i.."]".."Time: "..time_submitted[i]-time_submitted[0].."\nx_submitted: "..x_submitted[i].." y_submitted: "..y_submitted[i].."\nx_real: "..x_real[i].." y_real: "..y_real[i]
	--end

	local jsonOut = 
		{
			timestamp = os.date("%c"),
			user = "username_add_later",
			tests = 
			{
				["test[1]"] =
				{
					amplitude=70,
			        target_size=70,
			        player_size=50,
			        num_targets=11,
			        accelometer="gravity",
			        threshold=10,
			        gain=1.0,
			        total_time=126,
			        avg_time=10.2
				},
				["test[2]"] =
				{
					amplitude=70,
			        target_size=70,
			        player_size=50,
			        num_targets=11,
			        accelometer="gravity",
			        threshold=10,
			        gain=1.0,
			        total_time=126,
			        avg_time=10.2
				}
			}
		}

	results.text=json.encode(jsonOut, { indent=true })

	saveButton = display.newText("Save details as JSON", halfW, screenH-50, deafult, 50)
	backButton = display.newRect( 50, 50, 80, 80 )
	
	sceneGroup:insert(results)
	sceneGroup:insert(backButton)
	sceneGroup:insert(saveButton)
end

function scene:show(event)
	if event.phase == "will" then
		composer.removeScene("test_counter")
		backButton:addEventListener("touch", onBackButtonTouch)
		saveButton:addEventListener("touch", onSaveButtonTouch)
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onBackButtonTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "graphical_settings", "crossFade", 300 )
	end
end

function avamane(avama)

end

function onSaveButtonTouch( event )
	if event.phase == "ended" then

		local t = os.date( '*t' )  -- get table of current date and time
		print( t.hour..t.min..t.sec..t.day..t.month..t.year)  

		local path = system.pathForFile( t.hour..t.min..t.sec..t.day..t.month..t.year.."-user.json", system.DocumentsDirectory)
		local file, errorString = io.open( path, "w" )

		local saveData = results.text

		if not file then
    	-- Error occurred; output the cause
		    directory.text =  "File error: " .. errorString 
		else
		    -- Write data to file
		    file:write( saveData )
		    -- Close the file handle
		    io.close( file )
		end
		local file, errorString = io.open( path, "r" )
		if not file then	    -- Error occurred; output the cause
		    print( "File error: " .. errorString )
		else
		    -- Read data from file
		    local contents = file:read( "*a" )
		    -- Output the file contents
		    directory.text = path
		    -- Close the file handle
		    io.close( file )
		end
		 
		file = nil

		directory.text="ideees"
		local options =
		{
		   to = "antonio.bradicic@hotmail.com",
		   subject = "Results",
		   body = "",
		   attachment = { baseDir=system.DocumentsDirectory, filename=t.hour..t.min..t.sec..t.day..t.month..t.year.."-user.json", type="application/json" }
		}
		native.showPopup( "mail", options )
	end
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
