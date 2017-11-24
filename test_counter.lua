------------------------------------------------------------------------
--
-- test_counter
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2
numTestsInfo={}
function scene:create(event)
	sceneGroup = self.view

	testNumber = event.params.testNumber
	testsArray = event.params.testsArray
	switchAccelerometer = event.params.switchAccelerometer
	numOfTests = event.params.numOfTests
	thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue

	if testNumber ~= 1 then
		x_submitted = event.params.x_submitted
		y_submitted = event.params.y_submitted
		x_real = event.params.x_real
		y_real = event.params.y_real
		numCircles = event.params.numCircles
		time_submitted = event.params.time_submitted
	end

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
    	composer.removeScene("test_screen")
    	composer.removeScene("test_settings")
		nextButton:addEventListener("touch", onNextButtonTouch)
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
		local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            radius = testsArray[testNumber][1],
		            circleSize = testsArray[testNumber][2],
		            playerSize = testsArray[testNumber][3],
		            numCircles = testsArray[testNumber][4],

					testNumber = testNumber,
					thresholdValue = thresholdValue,
					gainValue = gainValue,
		            switchAccelerometer = switchAccelerometer,
		            numOfTests = numOfTests,
					testsArray = testsArray
		        } 
		    }
		    composer.gotoScene("test_screen", options)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
