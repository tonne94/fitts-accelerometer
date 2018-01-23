-----------------------------------------------------------------------------------------
--
-- endgame.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
local toast = require('plugin.toast')

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local numOfTests
local username
local testsText
local timestamp=""

function scene:create(event)
	sceneGroup = self.view

	numOfTests = event.params.numOfTests
	username = event.params.username
	
	nameOfFileText = display.newText("Name of file:", halfW, halfH/5, deafult, screenH/21)
	nameOfFile = display.newText(username..".json", halfW, halfH/3, deafult, screenH/30)
	nameOfFile:setFillColor(0.8,0.8,1)

	local options = 
	{
	    text = "Hello World",     
	    x = halfW,
	    y = halfH/2,
	    width = screenW,
	    font = native.systemFont,   
	    fontSize = 20,
	    align = "center"  -- Alignment parameter
	}
	errorText = display.newText(options)
	errorText:setFillColor(1,0,0)
	errorText.isVisible = false
	
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
		   	errorText.text = "File removed" 
		else
			errorText.isVisible = true
			errorText.width = screenW
	  		errorText.text = "File not removed. Reason: ".. reason   --> File does not exist    apple.txt: No such file or directory
		end
	end

	local t = os.date( '*t' )
	testsText="{\n".."\t\"timestamp\":\""..os.date( "%X").." "..t.day.."."..t.month.."."..t.year.."\",\n\t\"username\":\""..username.."\",\n\t\"tests\":\n\t{"..testsText.."\n\t}\n}"
	
	saveButton = display.newText("Save JSON", halfW, screenH-8*halfH/12, deafult, screenH/16)
	saveButtonRect = display.newRect(halfW, screenH-8*halfH/12, saveButton.width+halfW/20, saveButton.height)
	saveButtonRect:setFillColor	(0.2,0.2,0.2)
	saveButtonRect.stroke = { 0.8, 0.8, 1 }
	saveButtonRect.strokeWidth = 4

	shareButton = display.newText("Share JSON", halfW, screenH-5*halfH/12, deafult, screenH/16)
	shareButtonRect = display.newRect(halfW, screenH-5*halfH/12, shareButton.width+halfW/20, shareButton.height)
	shareButtonRect:setFillColor (0.2,0.2,0.2)
	shareButtonRect.stroke = { 0.8, 0.8, 1 }
	shareButtonRect.strokeWidth = 4

    mainMenuButton = display.newText("MAIN MENU", halfW, screenH-halfH/9, deafult, screenH/14)
    mainMenuButtonRect = display.newRect(halfW, screenH-halfH/9, mainMenuButton.width+halfW/20, mainMenuButton.height)
    mainMenuButtonRect:setFillColor (0.2,0.2,0.2)
    mainMenuButtonRect.stroke = { 0.8, 0.8, 1 }
    mainMenuButtonRect.strokeWidth = 4

	moreTextLabel = display.newText("Add more info in file name:", halfW, 3*halfH/4, deafult, screenH/25)
	-- Create text field
	moreText = native.newTextField(halfW, 3*halfH/4+halfH/9, screenW-halfW/4, screenH/21)
    moreText.font = native.newFont( native.systemFont, screenH/21 )
    moreText.isEditable = true
	moreText:addEventListener( "userInput", textListener )

	sceneGroup:insert(nameOfFile)
	sceneGroup:insert(nameOfFileText)
	sceneGroup:insert(errorText)
	sceneGroup:insert(mainMenuButtonRect)
	sceneGroup:insert(mainMenuButton)
	sceneGroup:insert(saveButtonRect)
	sceneGroup:insert(saveButton)
	sceneGroup:insert(shareButtonRect)
	sceneGroup:insert(shareButton)
	sceneGroup:insert(moreText)
	sceneGroup:insert(moreTextLabel)
end

function textListener( event )
 
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"ž
 
    elseif ( event.phase == "editing" ) then
    	nameOfFile.text = username..timestamp..moreText.text..".json"
    end
end
 
function scene:show(event)
	if event.phase == "will" then
        print("endgame:show_will")
		composer.removeScene("test_counter")
		mainMenuButton:addEventListener("touch", onMainMenuTouch)
		shareButton:addEventListener("touch", onShareButtonTouch)
		saveButton:addEventListener("touch", onSaveButtonTouch)
		-- Handle press events for the checkbox
		local function onSwitchPress( event )
		    local switch = event.target
		    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
		    if switch.isOn then
		    	local t = os.date( '*t' )
				timestamp=t.day.."-"..t.month.."-"..t.year
		    else
		    	timestamp=""
		    end
				nameOfFile.text=username..timestamp..moreText.text..".json"
		end
		 
		-- Create the widget
		local addTimestampCheckbox = widget.newSwitch(
		    {
		        x=halfW/2-halfH/12, 
                y=halfH,        
                width = screenW/12,
        		height = screenW/12,
		        style = "checkbox",
		        id = "Checkbox",
		        onPress = onSwitchPress
		    }
		)
		addTimestampText=display.newText("Add timestamp", halfW/2+screenW/12-halfH/23, halfH, deafult, screenW/12)
		addTimestampText.anchorX=0
		sceneGroup:insert(addTimestampCheckbox)
		sceneGroup:insert(addTimestampText)

	end
end

function scene:hide(event)
end

function scene:destroy(event)
end
function onSaveButtonTouch( event )
	print(event)
	if event.phase == "ended" then
		local path = system.pathForFile(nameOfFile.text, system.DocumentsDirectory)
		local file, errorString = io.open( path, "w" )
		if not file then
		-- Error occurred; output the cause
		    print("File error: " .. errorString)
		    toast.show("ERROR: File not saved")
		else
		    -- Write data to file
		    file:write( testsText )
		    -- Close the file handle
		    io.close( file )
		    toast.show("File "..nameOfFile.text.." saved!")
		end
	elseif event == "share" then
		local path = system.pathForFile(nameOfFile.text, system.DocumentsDirectory)
		local file, errorString = io.open( path, "w" )
		if not file then
		-- Error occurred; output the cause
		    print("File error: " .. errorString)
		    toast.show("ERROR: File not saved")
		else
		    -- Write data to file
		    file:write( testsText )
		    -- Close the file handle
		    io.close( file )
		    toast.show("File "..nameOfFile.text.." saved!")
		end
	end
end

function onMainMenuTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "main_menu", "crossFade", 300 )
	end
end

function onShareButtonTouch( event )
	if event.phase == "ended" then
		onSaveButtonTouch("share")
		local options =
		{
		   to = "antonio.bradicic@hotmail.com",
		   subject = "Results",
		   body = "",
		   attachment = { baseDir=system.DocumentsDirectory, filename=nameOfFile.text, type="application/json" }
		}
		native.showPopup( "mail", options )
	end
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
