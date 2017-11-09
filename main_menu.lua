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
	loadTestButton:setFillColor(1,0,0)

	sceneGroup:insert(newTestButton)
	sceneGroup:insert(loadTestButton)
end

function scene:show(event)
	if event.phase == "will" then
		newTestButton:addEventListener("touch", onNewTestButtonTouch)
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

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
