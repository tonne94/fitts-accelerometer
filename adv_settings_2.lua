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

lock = false

distancesLabels = {}
targetSizesLabels = {}

function scene:create(event)
	sceneGroup = self.view

  	distances = event.params.distances
  	targetSizes = event.params.targetSizes

	distancesInfo = display.newText("Distances:", halfW, halfH/4, deafult, 30)

	for i=1,distances,1 do
		distancesLabels[i]=display.newText("0", i*screenW/(distances+1), halfH/4+halfH/9, deafult, 50)
		sceneGroup:insert(distancesLabels[i])
	end

	targetSizesInfo = display.newText("Target sizes:", halfW, 2*halfH/3, deafult, 30)

	for i=1,targetSizes,1 do
		targetSizesLabels[i]=display.newText("0", i*screenW/(targetSizes+1), 2*halfH/3+halfH/9, deafult, 50)
		sceneGroup:insert(targetSizesLabels[i])
	end

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(distancesInfo)
	sceneGroup:insert(targetSizesInfo)
	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
    	composer.removeScene("adv_settings")
		nextButton:addEventListener("touch", onNextButtonTouch)
		for i=1,distances,1 do
			distancesLabels[i]:addEventListener("touch", onNumberTouch)
		end
		for i=1,targetSizes,1 do
			targetSizesLabels[i]:addEventListener("touch", onNumberTouch)
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

		local function onRadiusStepperPress( event )
         
            if ( "increment" == event.phase ) then
                currentRadius = currentRadius + 1
            elseif ( "decrement" == event.phase ) then
                currentRadius = currentRadius - 1
            end
            radiusLabel.text=currentRadius
            circle1.path.radius = currentRadius
            drawCircles()
        end

		local playerRadius = widget.newStepper(
            {
                x=halfW,
                y=halfH+halfH/2,
                sheet = stepperSheet,
                minimumValue = 10,
                maximumValue = 150,
                initialValue = 50,
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onPlayerRadiusStepperPress
            }
        )

	sceneGroup:insert(playerRadius)

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

function onNumberTouch( event )
	if event.phase == "ended" then
		--transition.fadeIn( circle2, { time=fadeTime } )
		print(event.target)

		--selected label is getting locked
		if lock == false then
			--save labels x and y so it can be returned to its place
			prevEventTarget_x=event.target.x
			prevEventTarget_y=event.target.y
			local params =
			{
				time = 1000,
				x = halfW,
				y = halfH+halfH/2-halfH/4,
				transition = easing.inOutSine
			}
			transition.to( event.target, params )
			event.target.size = 100

			--lock listener 
			lock = event.target
			--var prevLock to lock this listener to ONLY this text/label until is unlocked
			prevLock = lock

		--check if label is being unlocked
		elseif prevLock == event.target then

			local params =
			{
				time = 1000,
				x = prevEventTarget_x,
				y = prevEventTarget_y,
				transition = easing.inOutSine
			}
			transition.to( event.target, params )
			event.target.size = 50
			lock = false
		end
		
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
