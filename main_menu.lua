------------------------------------------------------------------------
--
-- main_menu.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local toast = require('plugin.toast')

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

function scene:create(event)
	sceneGroup = self.view

    appName = display.newText("Fitts law accelerometer test app", halfW, halfH/8, deafult, screenH/28)
    appName:setFillColor (0.8,0.8,1)

	newTestButton = display.newText("NEW TEST", halfW, halfH-halfH/4, deafult, screenH/12)
    newTestButtonRect = display.newRect(halfW, halfH-halfH/4, newTestButton.width+halfW/20, newTestButton.height)
    newTestButtonRect:setFillColor (0.2,0.2,0.2)
    newTestButtonRect.stroke = { 0.8, 0.8, 1 }
    newTestButtonRect.strokeWidth = 4

	loadTestButton = display.newText("LOAD TEST", halfW, halfH, deafult, screenH/12)
    loadTestButtonRect = display.newRect(halfW, halfH, loadTestButton.width+halfW/20, loadTestButton.height)
    loadTestButtonRect:setFillColor (0.2,0.2,0.2)
    loadTestButtonRect.stroke = { 0.8, 0.8, 1 }
    loadTestButtonRect.strokeWidth = 4

    savedTestsButton = display.newText("SAVED TESTS", halfW, halfH+halfH/4, deafult, screenH/15)
    savedTestsButtonRect = display.newRect(halfW, halfH+halfH/4, savedTestsButton.width+halfW/20, savedTestsButton.height)
    savedTestsButtonRect:setFillColor (0.2,0.2,0.2)
    savedTestsButtonRect.stroke = { 0.8, 0.8, 1 }
    savedTestsButtonRect.strokeWidth = 4

    exitButton = display.newText("EXIT", halfW, screenH-halfH/9, deafult, screenH/12)
    exitButtonRect = display.newRect(halfW, screenH-halfH/9, exitButton.width+halfW/20, exitButton.height)
    exitButtonRect:setFillColor (0.2,0.2,0.2)
    exitButtonRect.stroke = { 0.8, 0.8, 1 }
    exitButtonRect.strokeWidth = 4

    sceneGroup:insert(appName)
    sceneGroup:insert(newTestButtonRect)
	sceneGroup:insert(newTestButton)
    sceneGroup:insert(loadTestButtonRect)
	sceneGroup:insert(loadTestButton)
    sceneGroup:insert(savedTestsButtonRect)
    sceneGroup:insert(savedTestsButton)
    sceneGroup:insert(exitButtonRect)
    sceneGroup:insert(exitButton)

end

function scene:show(event)
	if event.phase == "will" then
		print("main_menu_scene:show_will") 
    	composer.removeScene("adv_settings")
    	composer.removeScene("adv_settings_2")
    	composer.removeScene("test_settings")
    	composer.removeScene("username")
    	composer.removeScene("test_counter")
    	composer.removeScene("test_screen")
    	composer.removeScene("graphical_settings")
    	composer.removeScene("endgame")
    	composer.removeScene("loaded")
    	composer.removeScene("saved_tests")
    	composer.removeScene("show_saved_test")
		newTestButton:addEventListener("touch", onNewTestButtonTouch)
		loadTestButton:addEventListener("touch", onLoadTestButtonTouch)
        savedTestsButton:addEventListener("touch", onSavedTestsButtonTouch)
        exitButton:addEventListener("touch", onExitButtonTouch)

	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onExitButtonTouch( event )
    print(event.phase)
    if event.phase == "ended" then
        native.requestExit()
    end
end

function onNewTestButtonTouch( event )
    print(event.phase)
	if event.phase == "ended" then
		composer.gotoScene( "adv_settings", "crossFade", 300 )
	end
end

function onLoadTestButtonTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "loaded", "crossFade", 300 )
	end
end

function onSavedTestsButtonTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "saved_tests", "crossFade", 300 )
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

local function onKeyEvent( event )
 
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        if ( system.getInfo("platform") == "android" ) then
            toast.show("Back button is disabled!")
            return true
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end
 
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )

return scene
