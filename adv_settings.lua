------------------------------------------------------------------------
--
-- blank
--
------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local numDistances = 3
local numTargetSizes = 3

function scene:create(event)
	sceneGroup = self.view	

	sceneName = display.newText("Settings", halfW, halfH/10, deafult, 50)

	distancesInfo = display.newText("Number of different distances:", halfW, halfH/4, deafult, 30)
	distances = display.newText("3", halfW, halfH/4+halfH/9, deafult, 50)
	
	targetSizesInfo = display.newText("Number of different target sizes:", halfW, 2*halfH/3, deafult, 30)
	targetSizes = display.newText("3", halfW, 2*halfH/3+halfH/9, deafult, 50)

	testNumberInfo = display.newText("Number of tests:", halfW, halfH+halfH/4, deafult, 30)
	testNumber = display.newText("3 x 3 = 9", halfW, halfH+halfH/4+halfH/9, deafult, 50)
	
	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(sceneName)
	sceneGroup:insert(distancesInfo)
	sceneGroup:insert(distances)
	sceneGroup:insert(targetSizesInfo)
	sceneGroup:insert(targetSizes)
	sceneGroup:insert(testNumberInfo)
	sceneGroup:insert(testNumber)
	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
		nextButton:addEventListener("touch", onNextButtonTouch)

		local function onNumDistancesStepperPress( event )

            if ( "increment" == event.phase ) then
                numDistances = numDistances + 1
            elseif ( "decrement" == event.phase ) then
                numDistances = numDistances - 1
            end
            distances.text=numDistances

            --update text number of tests
            testNumber.text = numDistances.." x "..numTargetSizes.." = "..numDistances*numTargetSizes
        end

		local function onNumTargetSizesStepperPress( event )

            if ( "increment" == event.phase ) then
                numTargetSizes = numTargetSizes + 1
            elseif ( "decrement" == event.phase ) then
                numTargetSizes = numTargetSizes - 1
            end
            targetSizes.text=numTargetSizes

            --update text number of tests
            testNumber.text = numDistances.." x "..numTargetSizes.." = "..numDistances*numTargetSizes

        end

		-- Image sheet options and declaration
        local options = {
            width = screenW/5,
            height = screenW/10,
            numFrames = 5,
            sheetContentWidth = screenW,
            sheetContentHeight = screenW/10
        }
        local stepperSheet = graphics.newImageSheet( "widget-stepper.png", options )
         
        -- widget stepper for number of circles
        local numDistancesStepper = widget.newStepper(
            {
                x=halfW,
                y=halfH/4+halfH/4,
                sheet = stepperSheet,
                minimumValue = 1,
                maximumValue = 5,
                initialValue = 3,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onNumDistancesStepperPress
            }
        )

        local numTargetSizesStepper = widget.newStepper(
            {
                x=halfW,
                y=2*halfH/3+halfH/4,
                sheet = stepperSheet,
                minimumValue = 1,
                maximumValue = 5,
                initialValue = 3,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onNumTargetSizesStepperPress
            }
        )

        sceneGroup:insert(numDistancesStepper)
        sceneGroup:insert(numTargetSizesStepper)
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
		            distances = distances.text, 
		            targetSizes = targetSizes.text
		        } 
		    }
	    composer.gotoScene("adv_settings_2", options)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
