-----------------------------------------------------------------------------------------
--
-- endgame.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

function scene:create(event)
	sceneGroup = self.view

	numOfTests = event.params.numOfTests
	username = event.params.username

	results = display.newText("Name of file:\n"..username..".json", halfW, halfH/2, deafult, 20)
	error_text = display.newText("", halfW, halfH/2+50, deafult, 20)
	error_text:setFillColor(1,0,0)
	testsText=""

	for i=1, numOfTests,1 do
		local path = system.pathForFile( "test"..i.."-"..username..".json", system.TemporaryDirectory)
		local file, errorString = io.open( path, "r" )
		if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
		else
		    -- Read data from file
		    local contents = file:read( "*a" )
		    -- Output the file contents
		    testsText=testsText..contents
		end

		local result, reason = os.remove( system.pathForFile( "test"..i.."-"..username..".json", system.TemporaryDirectory ) )
		  
		if result then
		   error_text.text = "File removed" 
		else
		  error_text.text = "File does not exist".. reason   --> File does not exist    apple.txt: No such file or directory
		end
	end

	local t = os.date( '*t' )
	testsText="{\n".."\t\"timestamp\":\""..os.date( "%X").." "..t.day.."."..t.month.."."..t.year.."\",\n\t\"username\":\""..username.."\",\n\t\"tests\":\n\t{"..testsText.."\n\t}\n}"
	
	local path = system.pathForFile(username..".json", system.DocumentsDirectory)
	local file, errorString = io.open( path, "w" )
	if not file then
	-- Error occurred; output the cause
	    print("File error: " .. errorString)
	else
	    -- Write data to file
	    file:write( testsText )
	    -- Close the file handle
	    io.close( file )
	end

	saveButton = display.newText("Save details as JSON", halfW, screenH-halfH/2, deafult, 100)
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

		-- Handle press events for the checkbox
		local function onSwitchPress( event )
		    local switch = event.target
		    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
		    if switch.isOn then
		    	local t = os.date( '*t' )
				timestamp=t.day..t.month..t.year
		    else
		    	timestamp=""
		    end
				results.text="Name of file:\n"..username..timestamp..".json"
		end
		 
		-- Create the widget
		local addTimestampCheckbox = widget.newSwitch(
		    {
		        x=halfW/2, 
                y=halfH,        
                width = screenW/12,
        		height = screenW/12,
		        style = "checkbox",
		        id = "Checkbox",
		        onPress = onSwitchPress
		    }
		)
		addTimestampText=display.newText("Add timestamp", halfW/2+screenW/12, halfH, deafult, screenW/12)
		addTimestampText.anchorX=0
		sceneGroup:insert(addTimestampCheckbox)
		sceneGroup:insert(addTimestampText)

	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onBackButtonTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "main_menu", "crossFade", 300 )
	end
end

function onSaveButtonTouch( event )
	if event.phase == "ended" then
		local options =
		{
		   to = "antonio.bradicic@hotmail.com",
		   subject = "Results",
		   body = "",
		   attachment = { baseDir=system.DocumentsDirectory, filename=username..timestamp..".json", type="application/json" }
		}
		native.showPopup( "mail", options )
	end
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
