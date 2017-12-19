------------------------------------------------------------------------
--
-- options.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

function scene:create(event)
	sceneGroup = self.view

	newTestButton = display.newText("NEW TEST", halfW, halfH-halfH/4, deafult, 100)
	loadTestButton = display.newText("LOAD TEST", halfW, halfH, deafult, 100)
	displaySavedTestsButton = display.newText("SHOW SAVED TESTS", halfW, halfH+halfH/4, deafult, 60)

	sceneGroup:insert(newTestButton)
	sceneGroup:insert(loadTestButton)
	sceneGroup:insert(displaySavedTestsButton)


		print("main_menu_create") 
end

function scene:show(event)
	if event.phase == "will" then
		print("main_menu_show_will") 
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
		newTestButton:addEventListener("touch", onNewTestButtonTouch)
		loadTestButton:addEventListener("touch", onLoadTestButtonTouch)
		displaySavedTestsButton:addEventListener("touch", onSavedTestsButtonTouch)

	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNewTestButtonTouch( event )
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

return scene
