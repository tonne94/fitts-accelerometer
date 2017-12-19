local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local toast = require('plugin.toast')

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local x = {}
local y = {}
local circles = {}

local currentNumCircles = 11
local prevNumCircles = 11
local currentCircleSize = 100
local currentRadius = 200
local currentPlayerRadius = 50

local switchRaw = true
local switchGravity = false

function scene:create(event)

    sceneGroup = self.view

	testsArray = event.params.testsArray
	switchAccelerometer = event.params.switchAccelerometer	
	switchSubmitStyle = event.params.switchSubmitStyle
    dwellTimeValue = event.params.dwellTimeValue
	numOfTests = event.params.numOfTests
	thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue
	index = event.params.index
	
	currentNumCircles = tonumber(testsArray[index][4])
	prevNumCircles = tonumber(testsArray[index][4])
	currentCircleSize = tonumber(testsArray[index][2])
	currentRadius = tonumber(testsArray[index][1])
	currentPlayerRadius = tonumber(testsArray[index][3])

    circleDistance = display.newCircle( halfW, halfH, currentRadius)    
    circleDistance:setFillColor(1,1,1,0)
    circleDistance.strokeWidth = 2
    circleDistance:setStrokeColor( 1, 1, 1 )

    drawCirclesFirstTime()

    --labels for info and counters

    labelInfoRadius = display.newText("Radius:", halfW-3*halfW/4, halfH/10, deafult, 25)
    radiusLabel = display.newText(testsArray[index][1], halfW-3*halfW/4, halfH/5, deafult, 50)
    
    labelInfoCircleSize = display.newText("Target size:", halfW-halfW/4, halfH/10, deafult, 25)
    circleSizeLabel = display.newText(testsArray[index][2], halfW-halfW/4, halfH/5, deafult, 50)

    labelInfoPlayerSize = display.newText("Player size:", halfW+halfW/4, halfH/10, deafult, 25)
    playerSizeLabel = display.newText(testsArray[index][3], halfW+halfW/4, halfH/5, deafult, 50)  

    labelInfoCircleNumbers = display.newText("Circle number:", halfW+3*halfW/4, halfH/10, deafult, 25)
    circleNumbersLabel = display.newText(testsArray[index][4], halfW+3*halfW/4, halfH/5, deafult, 50)  

	circlePlayer = display.newCircle( halfW, halfH, currentPlayerRadius )
	circlePlayer:setFillColor( 0, 0, 1 )

	if currentCircleSize < currentPlayerRadius then
		circleSizeLabel:setFillColor(1,0,0)
		playerSizeLabel:setFillColor(1,0,0)
	elseif 	currentCircleSize == currentPlayerRadius then
		circleSizeLabel:setFillColor(1,1,0)
		playerSizeLabel:setFillColor(1,1,0)
    else
		circleSizeLabel:setFillColor(1,1,1)
		playerSizeLabel:setFillColor(1,1,1)
    end

	--rectangle for start button
    startButton = display.newRect( halfW, screenH-100, 150, 150 )

    sceneGroup:insert(circleDistance)
    sceneGroup:insert(circlePlayer)
    sceneGroup:insert(startButton)

    sceneGroup:insert(circleNumbersLabel)
    sceneGroup:insert(radiusLabel)
    sceneGroup:insert(circleSizeLabel)
    sceneGroup:insert(playerSizeLabel)

    sceneGroup:insert(labelInfoCircleNumbers)
    sceneGroup:insert(labelInfoRadius)
    sceneGroup:insert(labelInfoCircleSize)
    sceneGroup:insert(labelInfoPlayerSize)

end

--preview circles around the radius called in stepper events
function drawCirclesFirstTime( event )

    for i=0,currentNumCircles,1 do
        x[i]=(-math.cos(math.pi/2+2*math.pi/currentNumCircles*i)*currentRadius)+halfW
        y[i]=(-math.sin(math.pi/2+2*math.pi/currentNumCircles*i)*currentRadius)+halfH
    end

    for i=0,currentNumCircles,1 do
        circles[i]=display.newCircle( x[i], y[i], currentCircleSize )
        circles[i]:setFillColor(1,1,1,0)
        circles[i].strokeWidth = 2
        circles[i]:setStrokeColor( 1, 1, 1 )
        circles[i]:toBack()
        sceneGroup:insert(circles[i])
    end
end

--preview circles around the radius called in stepper events
function drawCircles( event )
    print("Current: "..currentNumCircles.." Prev: "..prevNumCircles	)
    for i=0,prevNumCircles,1 do
        sceneGroup:remove(circles[i])
    end

    for i=0,currentNumCircles,1 do
        x[i]=(-math.cos(math.pi/2+2*math.pi/currentNumCircles*i)*currentRadius)+halfW
        y[i]=(-math.sin(math.pi/2+2*math.pi/currentNumCircles*i)*currentRadius)+halfH
    end

    for i=0,currentNumCircles,1 do
        circles[i]=display.newCircle( x[i], y[i], currentCircleSize )
        circles[i]:setFillColor(1,1,1,0)
        circles[i].strokeWidth = 2
        circles[i]:setStrokeColor( 1, 1, 1 )
        circles[i]:toBack()
        sceneGroup:insert(circles[i])
    end
end

--preview player circle called in stepper event for player size
function drawPlayerCircle()
	sceneGroup:remove(circlePlayer)
	circlePlayer = display.newCircle( halfW, halfH, currentPlayerRadius )
	circlePlayer:setFillColor( 0, 0, 1 )
	sceneGroup:insert(circlePlayer)
end

--called when start button pressed
function onStartButtonTouch( event )
    if event.phase == "ended" then
	    if currentCircleSize < currentPlayerRadius then
			toast.show('ERROR: Size of player is bigger than the size of target')
        else

        	testsArray[index][1]=tonumber(radiusLabel.text)
        	testsArray[index][2]=tonumber(circleSizeLabel.text)
        	testsArray[index][3]=tonumber(playerSizeLabel.text)
        	testsArray[index][4]=tonumber(circleNumbersLabel.text)

        	local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            testsArray = testsArray,
                    thresholdValue = thresholdValue,
                    gainValue = gainValue,
                    switchAccelerometer = switchAccelerometer,
					switchSubmitStyle = switchSubmitStyle,
	                dwellTimeValue = dwellTimeValue,
                    numOfTests = numOfTests,
                    testNumber = testNumber,
                    prevScene = "graphical_settings"
		        } 
		    }
	    composer.gotoScene("test_settings", options)
        end
        
    end
end

function scene:show(event)
    -- Handle stepper events
    if event.phase == "will" then
    	composer.removeScene("test_settings")

        startButton:addEventListener("touch", onStartButtonTouch) 
 
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
            prevNumCircles=currentNumCircles

            radiusLabel.text=currentRadius
            circleDistance.path.radius = currentRadius
            drawCircles()
        end

        -- widget stepper for radius in which are the circles drawn
        local radiusStepper = widget.newStepper(
            {
                x=halfW-3*halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 10,
                maximumValue = 1000,
                initialValue = tonumber(radiusLabel.text),
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onRadiusStepperPress
            }
        )

        local function onCircleSizeStepperPress( event )
         
            if ( "increment" == event.phase ) then
                currentCircleSize = currentCircleSize + 1
            elseif ( "decrement" == event.phase ) then
                currentCircleSize = currentCircleSize - 1
            end
            circleSizeLabel.text=currentCircleSize

            prevNumCircles=currentNumCircles
            drawCircles()
            if currentCircleSize < currentPlayerRadius then
				circleSizeLabel:setFillColor(1,0,0)
				playerSizeLabel:setFillColor(1,0,0)
            else
				circleSizeLabel:setFillColor(1,1,1)
				playerSizeLabel:setFillColor(1,1,1)
            end
        end

        -- widget stepper for radius of circles drawn (targets)
        local circleSizeStepper = widget.newStepper(
            {
            	x=halfW-halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 10,
                maximumValue = 200,
                initialValue = tonumber(circleSizeLabel.text),
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onCircleSizeStepperPress
            }
        )

        local function onPlayerRadiusStepperPress( event )
     
	        if ( "increment" == event.phase ) then
	            currentPlayerRadius = currentPlayerRadius + 1
	        elseif ( "decrement" == event.phase ) then
	            currentPlayerRadius = currentPlayerRadius - 1
	        end
	        playerSizeLabel.text=currentPlayerRadius
	        drawPlayerCircle()

	        if currentCircleSize < currentPlayerRadius then
				circleSizeLabel:setFillColor(1,0,0)
				playerSizeLabel:setFillColor(1,0,0)
			elseif 	currentCircleSize == currentPlayerRadius then
				circleSizeLabel:setFillColor(1,1,0)
				playerSizeLabel:setFillColor(1,1,0)
            else
				circleSizeLabel:setFillColor(1,1,1)
				playerSizeLabel:setFillColor(1,1,1)
            end
        end     

        -- widget stepper for radius of player circle drawn
        local playerRadius = widget.newStepper(
            {

                x=halfW+halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 5,
                maximumValue = 200,
                initialValue = tonumber(playerSizeLabel.text),
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onPlayerRadiusStepperPress
            }
        )

		local function onNumCirclesStepperPress( event )
         
            prevNumCircles=currentNumCircles

            if ( "increment" == event.phase ) then
                currentNumCircles = currentNumCircles + 2
            elseif ( "decrement" == event.phase ) then
                currentNumCircles = currentNumCircles - 2
            end
            circleNumbersLabel.text=currentNumCircles
            drawCircles()

        end

        -- widget stepper for number of circles
        local numCirclesStepper = widget.newStepper(
            { 
            	x=halfW+3*halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 8,
                maximumValue = 55,
                initialValue = tonumber(circleNumbersLabel.text),
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onNumCirclesStepperPress
            }
        ) 
        
        sceneGroup:insert(numCirclesStepper)
        sceneGroup:insert(circleSizeStepper)
        sceneGroup:insert(radiusStepper)
        sceneGroup:insert(playerRadius)
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