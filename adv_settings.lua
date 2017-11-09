------------------------------------------------------------------------
--
-- blank
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

	userName = display.newText("AVAMANE", halfW, halfH, deafult, 20)
	nextButton = display.newText("NEXT", halfW, screenH-50, deafult, 50)

	sceneGroup:insert(userName)
	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
		nextButton:addEventListener("touch", onNextButtonTouch)
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "graphical_settings", "crossFade", 300 )
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
