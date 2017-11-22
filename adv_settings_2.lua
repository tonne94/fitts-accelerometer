------------------------------------------------------------------------
--
-- adv_settings_2.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local switchAccelerometer = true

local thresholdValue = 10
local gainValue = 10

function scene:create(event)
	sceneGroup = self.view

  	numAmplitudes = event.params.numAmplitudes
    numTargetSizes = event.params.numTargetSizes
    numPlayerSizes = event.params.numPlayerSizes
    numTargets = event.params.numTargets

	amplitudesInfo = display.newText("Amplitudes (".. table.getn(numAmplitudes)..")", halfW, halfH/5, deafult, 40)
	amplitudesInfo.text=amplitudesInfo.text.."\n"

	for i=1,table.getn(numAmplitudes),1 do
		if i == table.getn(numAmplitudes) then
			amplitudesInfo.text=amplitudesInfo.text..numAmplitudes[i]
		else
			amplitudesInfo.text=amplitudesInfo.text..numAmplitudes[i]..", "
		end
	end

	targetSizesInfo = display.newText("Target sizes (".. table.getn(numTargetSizes)..")", halfW, 2*halfH/5, deafult, 40)
	targetSizesInfo.text=targetSizesInfo.text.."\n"

	for i=1,table.getn(numTargetSizes),1 do
		if i == table.getn(numTargetSizes) then
			targetSizesInfo.text=targetSizesInfo.text..numTargetSizes[i]
		else
			targetSizesInfo.text=targetSizesInfo.text..numTargetSizes[i]..", "
		end
	end

	playerSizesInfo = display.newText("Player sizes (".. table.getn(numPlayerSizes)..")", halfW, 3*halfH/5, deafult, 40)
	playerSizesInfo.text=playerSizesInfo.text.."\n"

	for i=1,table.getn(numPlayerSizes),1 do
		if i == table.getn(numPlayerSizes) then
			playerSizesInfo.text=playerSizesInfo.text..numPlayerSizes[i]
		else
			playerSizesInfo.text=playerSizesInfo.text..numPlayerSizes[i]..", "
		end
	end

	targetsNumInfo = display.newText("Number of targets (".. table.getn(numTargets)..")", halfW, 4*halfH/5, deafult, 40)
	targetsNumInfo.text=targetsNumInfo.text.."\n"

	for i=1,table.getn(numTargets),1 do
		if i == table.getn(numTargets) then
			targetsNumInfo.text=targetsNumInfo.text..numTargets[i]
		else
			targetsNumInfo.text=targetsNumInfo.text..numTargets[i]..", "
		end
	end

	labelThresholdInfo = display.newText("Threshold (%):", halfW/2, halfH, deafult, 35)
	labelThreshold = display.newText("10%", halfW/2, halfH+halfH/10, deafult, 40)

	labelGainInfo = display.newText("Gain:", 3*halfW/2, halfH, deafult, 35)
	labelGain = display.newText("x1.0", 3*halfW/2, halfH+halfH/10, deafult, 40)

    labelAccelerometerInput = display.newText("Accelerometer input:", halfW, screenH-halfH/2, deafult, 35)
    labelRawInput = display.newText("Raw input", halfW-halfW/3, screenH-2*halfH/5, deafult, 35)
    labelRawInput:setFillColor( 0, 1, 0 )
    labelGravityInput = display.newText("Gravity input", halfW+halfW/3, screenH-2*halfH/5, deafult, 35)

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

    sceneGroup:insert(labelRawInput)
    sceneGroup:insert(labelGravityInput)
    sceneGroup:insert(labelAccelerometerInput)

    sceneGroup:insert(labelThresholdInfo)
    sceneGroup:insert(labelThreshold)
    sceneGroup:insert(labelGainInfo)
    sceneGroup:insert(labelGain)

	sceneGroup:insert(amplitudesInfo)
	sceneGroup:insert(targetSizesInfo)
	sceneGroup:insert(playerSizesInfo)
	sceneGroup:insert(targetsNumInfo)

	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
    	composer.removeScene("adv_settings")
		nextButton:addEventListener("touch", onNextButtonTouch)
        labelRawInput:addEventListener("touch", onRawInputTouch)
        labelGravityInput:addEventListener("touch", onGravityInputTouch)

        -- Image sheet options and declaration
        local options = {
            width = screenW/5,
            height = screenW/10,
            numFrames = 5,
            sheetContentWidth = screenW,
            sheetContentHeight = screenW/10
        }
        local stepperSheet = graphics.newImageSheet( "widget-stepper.png", options )

        local function onThresholdStepperPress( event )
     
	        if ( "increment" == event.phase ) then
	            thresholdValue = thresholdValue + 1
	        elseif ( "decrement" == event.phase ) then
	            thresholdValue = thresholdValue - 1
	        end
	        labelThreshold.text = thresholdValue.."%"
        end     

        -- widget stepper for radius of player circle drawn
        local tresholdStepper = widget.newStepper(
            {
                x=halfW/2,
                y=halfH+halfH/4,
                sheet = stepperSheet,
                minimumValue = 10,
                maximumValue = 50,
                initialValue = 10,
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onThresholdStepperPress
            }
        )

        local function onGainStepperPress( event )
     
	        if ( "increment" == event.phase ) then
	            gainValue = gainValue + 1
	        elseif ( "decrement" == event.phase ) then
	            gainValue = gainValue - 1
	        end
	        labelGain.text = "x"..gainValue/10
        end     

        -- widget stepper for radius of player circle drawn
        local gainStepper = widget.newStepper(
            {
                x=3*halfW/2,
                y=halfH+halfH/4,
                sheet = stepperSheet,
                minimumValue = 5,
                maximumValue = 50,
                initialValue = 10,
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onGainStepperPress
            }
        )

        sceneGroup:insert(tresholdStepper)
        sceneGroup:insert(gainStepper)
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

--called when raw input text pressed
function onRawInputTouch( event )
    if event.phase == "ended" then
        switchAccelerometer = true
        labelRawInput:setFillColor( 0, 1, 0 )
        labelGravityInput:setFillColor( 1, 1, 1 )
    end
end

--called when raw input text pressed
function onGravityInputTouch( event )
    if event.phase == "ended" then
        switchAccelerometer = false
        labelRawInput:setFillColor( 1, 1, 1 )
        labelGravityInput:setFillColor( 0, 1, 0 )
    end
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
