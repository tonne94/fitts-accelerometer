------------------------------------------------------------------------
--
-- username
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

	testNumber = event.params.testNumber
	testsArray = event.params.testsArray
	switchAccelerometer = event.params.switchAccelerometer
	numOfTests = event.params.numOfTests
	thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue

	usernameText = display.newText("Username:", halfW, 3*halfH/4, deafult, 50)
    usernameTextField = native.newTextField(halfW, 3*halfH/4+halfH/9, screenW-halfW/4, 60)
    usernameTextField.font = native.newFont( native.systemFont, 40 )
    usernameTextField.isEditable = true

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(usernameText)
    sceneGroup:insert(usernameTextField)
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
		if usernameTextField.text == "" then
			usernameTextField.text="user"
		end
		local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            testsArray = testsArray,
                    thresholdValue = thresholdValue,
                    gainValue = gainValue,
                    switchAccelerometer = switchAccelerometer,
                    numOfTests = numOfTests,
                    testNumber = testNumber,
                    username = usernameTextField.text
		        } 
		    }
	    composer.gotoScene("test_counter", options)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
