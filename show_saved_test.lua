------------------------------------------------------------------------
--
-- show_saver_test.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local toast = require('plugin.toast')

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local groupPrompt = display.newGroup()
local contents
local readText=""
function scene:create(event)
	sceneGroup = self.view

    nameOfFile = event.params.nameOfFile

	sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
    sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName = display.newText(nameOfFile, halfW+halfH/15, halfH/15, deafult, screenH/25)

	backButton = display.newImageRect("back_button.png", halfH/8, halfH/8 )
	backButton.x = halfH/15
	backButton.y = halfH/15
	
	shareButton = display.newText("SHARE", halfW/2, screenH-halfH/12, deafult, screenH/16)
    shareButtonRect = display.newRect(halfW/2, screenH-halfH/12, shareButton.width+halfW/20, shareButton.height)
    shareButtonRect:setFillColor (0.2,0.2,0.2)
    shareButtonRect.stroke = { 0.8, 0.8, 1 }
    shareButtonRect.strokeWidth = 4

	deleteButton = display.newText("DELETE", screenW-halfW/2, screenH-halfH/12, deafult, screenH/16)
    deleteButtonRect = display.newRect(screenW-halfW/2, screenH-halfH/12, deleteButton.width+halfW/20, deleteButton.height)
    deleteButtonRect:setFillColor (0.2,0.2,0.2)
    deleteButtonRect.stroke = { 0.8, 0.8, 1 }
    deleteButtonRect.strokeWidth = 4

	deleteButton:setFillColor(1,0,0)

	local path = system.pathForFile(nameOfFile, system.DocumentsDirectory)
	local file, errorString = io.open( path, "r" )
	if not file then
	-- Error occurred; output the cause
	    print("File error: " .. errorString)
	    readText="ERROR: NO LOADED TEST"
	else
		-- Read data from file
	    contents = file:read( "*a" )
	    readText=contents
	    -- Close the file handle
	    io.close( file )
	end
	moreText = native.newTextBox(halfW, halfH, screenW, screenH-halfH/3)
	moreText.text= readText
	moreText.font = native.newFont( native.systemFont, screenH/36 )
	sceneGroup:insert(moreText)

	sceneGroup:insert(sceneNameBg)
    sceneGroup:insert(sceneName)
    sceneGroup:insert(shareButtonRect)
    sceneGroup:insert(shareButton)
    sceneGroup:insert(deleteButtonRect)
	sceneGroup:insert(deleteButton)
	sceneGroup:insert(backButton)
end

local function scrollListener( event )
 
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end
 
    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end
 
    return true
end

function onShareButtonTouch( event )
	if event.phase == "ended" then
		local options =
		{
		   to = "antonio.bradicic@hotmail.com",
		   subject = "Results",
		   body = "",
		   attachment = { baseDir=system.DocumentsDirectory, filename=nameOfFile, type="application/json" }
		}
		native.showPopup( "mail", options )
	end
end

function onDeleteButtonTouch( event )
	if event.phase == "ended" then
		moreText.isVisible = false
		deletePrompt = display.newRect( halfW, halfH, screenW-halfW/4, halfH/2 )
		deletePrompt.stroke = { 0.8, 0.8, 1 }
		deletePrompt.strokeWidth = 4
		deletePrompt:setFillColor(0.2,0.2,0.2)

		promptLabel = display.newText("Are you sure you want to delete?", halfW, halfH-halfH/6, deafult, screenH/42)

		promptFileName = display.newText(nameOfFile, halfW, halfH-halfH/15, deafult, screenH/28)
		promptFileName:setFillColor(1,0,0.5)

		buttonYes = display.newText("YES", halfW-halfW/3, halfH+halfH/7, deafult, screenH/16)
		buttonYes:setFillColor(0,1,0)

		buttonNo = display.newText("NO", halfW+halfW/3, halfH+halfH/7, deafult, screenH/16)
		buttonNo:setFillColor(1,0,0)

		groupPrompt.isVisible = true

		buttonYes:addEventListener("touch", onDeleteYes)
		buttonNo:addEventListener("touch", onDeleteNo)
		
		groupPrompt:insert(deletePrompt)
		groupPrompt:insert(promptLabel)
		groupPrompt:insert(promptFileName)
		groupPrompt:insert(buttonYes)
		groupPrompt:insert(buttonNo)
		sceneGroup:insert(groupPrompt)
	end
end

function onDeleteYes( event )

	buttonYes:removeEventListener("touch", onDeleteYes)
	buttonNo:removeEventListener("touch", onDeleteNo)
	groupPrompt.isVisible = false

	local result, reason = os.remove( system.pathForFile(nameOfFile, system.DocumentsDirectory ) )
		  
	if result then
	   toast.show("File removed")
	else
	  toast.show("File does not exist".. reason)   --> File does not exist    apple.txt: No such file or directory
	end
	
	composer.gotoScene( "saved_tests", "crossFade", 300 )
end


function onDeleteNo( event )
	moreText.isVisible = true
	buttonYes:removeEventListener("touch", onDeleteYes)
	buttonNo:removeEventListener("touch", onDeleteNo)
	groupPrompt.isVisible = false
end

function onBackButtonTouch( event )
    if event.phase == "ended" then
        composer.gotoScene( "saved_tests", "crossFade", 300 )
    end
end

function scene:show(event)
	if event.phase == "will" then
		print("show_saved_test_scene:show_will") 
    	composer.removeScene("saved_tests")
		backButton:addEventListener("touch", onBackButtonTouch)
		shareButton:addEventListener("touch", onShareButtonTouch)
		deleteButton:addEventListener("touch", onDeleteButtonTouch)
		
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
