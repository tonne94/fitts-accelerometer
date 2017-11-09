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

local switch = true
local switchRaw = true
local switchGravity = false

function scene:create(event)

    sceneGroup = self.view

    circle1 = display.newCircle( halfW, halfH, 200)    
    circle1:setFillColor(1,1,1,0)
    circle1.strokeWidth = 2
    circle1:setStrokeColor( 1, 1, 1 )

    drawCircles()

    --labels for info and counters
    labelInfoCircleNumbers = display.newText("Circle number:", halfW-3*halfW/4, halfH/10, deafult, 25)
    circleNumbersLabel = display.newText("11", halfW-3*halfW/4, halfH/5, deafult, 50)

    labelInfoRadius = display.newText("Radius:", halfW-halfW/4, halfH/10, deafult, 25)
    radiusLabel = display.newText("200", halfW-halfW/4, halfH/5, deafult, 50)

    labelInfoCircleSize = display.newText("Target size:", halfW+halfW/4, halfH/10, deafult, 25)
    circleSizeLabel = display.newText("100", halfW+halfW/4, halfH/5, deafult, 50)  

    labelInfoPlayerSize = display.newText("Player size:", halfW+3*halfW/4, halfH/10, deafult, 25)
    playerSizeLabel = display.newText("50", halfW+3*halfW/4, halfH/5, deafult, 50)  

    labelRawInput = display.newText("Raw input", halfW-halfW/3, screenH-2*halfH/5, deafult, 35)
    labelRawInput:setFillColor( 0, 1, 0 )
    labelGravityInput = display.newText("Gravity input", halfW+halfW/3, screenH-2*halfH/5, deafult, 35)
    labelAccelerometerInput = display.newText("Accelerometer input:", halfW, screenH-2*halfH/4, deafult, 35)

	circlePlayer = display.newCircle( halfW, halfH, currentPlayerRadius )
	circlePlayer:setFillColor( 0, 0, 1 )

	--rectangle for start button
    startButton = display.newRect( halfW, screenH-100, 150, 150 )

    sceneGroup:insert(circle1)
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
    sceneGroup:insert(labelRawInput)
    sceneGroup:insert(labelGravityInput)
    sceneGroup:insert(labelAccelerometerInput)

end

--preview circles around the radius called in stepper events
function drawCircles( event )
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
        	local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            numCircles = circleNumbersLabel.text, 
		            radius = radiusLabel.text, 
		            circleSize = circleSizeLabel.text,
		            playerSize = playerSizeLabel.text,
		            switch = switch
		        } 
		    }
		    composer.gotoScene("test_screen", options)
        end
        
    end
end

--called when raw input text pressed
function onRawInputTouch( event )
    if event.phase == "ended" then
        switch = true
        labelRawInput:setFillColor( 0, 1, 0 )
        labelGravityInput:setFillColor( 1, 1, 1 )
    end
end

--called when raw input text pressed
function onGravityInputTouch( event )
    if event.phase == "ended" then
        switch = false
        labelRawInput:setFillColor( 1, 1, 1 )
        labelGravityInput:setFillColor( 0, 1, 0 )
    end
end

function scene:show(event)
    -- Handle stepper events
    if event.phase == "will" then
    	composer.removeScene("adv_settings_2")
    	composer.removeScene("test_screen")
    	composer.removeScene("endgame")

        startButton:addEventListener("touch", onStartButtonTouch) 
        labelRawInput:addEventListener("touch", onRawInputTouch)
        labelGravityInput:addEventListener("touch", onGravityInputTouch)
        
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
            else
				circleSizeLabel:setFillColor(1,1,1)
				playerSizeLabel:setFillColor(1,1,1)
            end
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
        local numCirclesStepper = widget.newStepper(
            {
                x=halfW-3*halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 8,
                maximumValue = 21,
                initialValue = 11,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onNumCirclesStepperPress
            }
        ) 

        -- widget stepper for radius in which are the circles drawn
        local radiusStepper = widget.newStepper(
            {
                x=halfW-halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 50,
                maximumValue = 500,
                initialValue = 200,
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onRadiusStepperPress
            }
        )

        -- widget stepper for radius of circles drawn (targets)
        local circleSizeStepper = widget.newStepper(
            {
                x=halfW+halfW/4,
                y=halfH/3,
                sheet = stepperSheet,
                minimumValue = 50,
                maximumValue = 200,
                initialValue = 100,
                timerIncrementSpeed  = 300,
                defaultFrame = 1,
                noMinusFrame = 2,
                noPlusFrame = 3,
                minusActiveFrame = 4,
                plusActiveFrame = 5,
                onPress = onCircleSizeStepperPress
            }
        )

        -- widget stepper for radius of player circle drawn
        local playerRadius = widget.newStepper(
            {
                x=halfW+3*halfW/4,
                y=halfH/3,
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