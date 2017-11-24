-----------------------------------------------------------------------------------------
--
-- test_screen.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local scene = composer.newScene()
system.setAccelerometerInterval( 50 )
local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local x = {}
local y = {}

--variables to store x and y coordinates and time when submit pressed
local x_submitted  = {}
local y_submitted  = {}
local time_submitted = {}


function scene:create(event)
	sceneGroup = self.view

	activeIndex = 0
	xPos = 0
	yPos = 0
	zPos = 0
	count = 0
	circleCounter = 0 
	endgame = 0

	numCircles = event.params.numCircles
  	radius = event.params.radius
  	circleSize = event.params.circleSize
  	playerSize = event.params.playerSize

	testNumber = event.params.testNumber
	testsArray = event.params.testsArray
	switchAccelerometer = event.params.switchAccelerometer
	numOfTests = event.params.numOfTests
	thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue

	sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
	sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName = display.newText("Test["..testNumber.."]: "..testsArray[testNumber][1]..", "..testsArray[testNumber][2]
						..", "..testsArray[testNumber][3]..", "..testsArray[testNumber][4], halfW, halfH/15, deafult, 60)

	if switchAccelerometer == true then
		Runtime:addEventListener( "accelerometer", onAccelerateRaw )
		infoSwitchLabel = display.newText("onAccelerateRaw",halfW, screenH-halfH/2, deafult, 20)
	else
		Runtime:addEventListener( "accelerometer", onAccelerateGravity )
		infoSwitchLabel = display.newText("onAccelerateGravity",halfW, screenH-halfH/2, deafult, 20)
	end
	circlePlayer = display.newCircle( halfW, halfH, playerSize )
	circlePlayer:setFillColor( 0, 0, 1 )

	circle1 = display.newCircle( halfW, halfH, radius )    
	circle1:setFillColor(1,1,1,0)
	circle1.strokeWidth = 2
	circle1:setStrokeColor( 1, 1, 1 )

	submitButton = display.newRect( halfW+200, halfH+500, 150, 150 )

	for i=0,numCircles,1 do
		x[i]=(-math.cos(math.pi/2+2*math.pi/numCircles*i)*radius)+halfW
		y[i]=(-math.sin(math.pi/2+2*math.pi/numCircles*i)*radius)+halfH
    end
    drawCircles()

	textX = display.newText("X:"..xPos, halfW, halfH+450, deafult, 20)
	textY = display.newText("Y:"..yPos, halfW, halfH+500, deafult, 20)
	textZ = display.newText("Z:"..zPos, halfW, halfH+550, deafult, 20)
	countText = display.newText( "0", halfW, halfH-100, deafult, 20)
	coordinates = display.newText( "KOORDINATE", halfW, halfH-450, deafult, 20)
	screenSize = display.newText( "SCREEN WIDTH"..display.pixelWidth.."\nSCREEN HEIGHT"..screenH, halfW, halfH-550, deafult, 20)

	targetCircle = display.newCircle( -200, -200, circleSize )
	changeTarget(activeIndex)

	testNumber=testNumber+1

	sceneGroup:insert(sceneNameBg)
	sceneGroup:insert(sceneName)
	sceneGroup:insert(textX)
	sceneGroup:insert(textY)
	sceneGroup:insert(textZ)
	sceneGroup:insert(countText)
	sceneGroup:insert(coordinates)
	sceneGroup:insert(screenSize)
	sceneGroup:insert(circle1)
	sceneGroup:insert(targetCircle)
	sceneGroup:insert(circlePlayer)
	sceneGroup:insert(submitButton)
	sceneGroup:insert(infoSwitchLabel)
end

function scene:show(event)
	if event.phase == "will" then
		composer.removeScene("test_counter")
	end
	if event.phase == "did" then
		submitButton:addEventListener("touch", onSubmitTouch)
	end

end

function scene:hide(event)
end

function scene:destroy(event)
	targetCircle:removeSelf()
	Runtime:removeEventListener( "accelerometer", onAccelerateRaw )
	Runtime:removeEventListener( "accelerometer", onAccelerateGravity )
end

function drawCircles( event )
	for i=0,numCircles,1 do
		circles=display.newCircle( x[i], y[i], circleSize )
		circles:setFillColor(1,1,1,0)
		circles.strokeWidth = 2
		circles:setStrokeColor( 1, 1, 1 )
		circles:toBack()
		sceneGroup:insert(circles)
	end
end

function changeTarget(index)
	if endgame == 0 then
		time_submitted[circleCounter]=system.getTimer()
		targetCircle:removeSelf()
		targetCircle = display.newCircle( x[index], y[index], circleSize )
		targetCircle:setFillColor( 1,0,0,1)
		targetCircle.strokeWidth = 5
		targetCircle:setStrokeColor( 1, 0, 0 )
		sceneGroup:insert(targetCircle)
		circlePlayer:toFront()
	end
end

function updateIndex( event )
	numCircles=tonumber(numCircles)
	local halfNumCircles=math.floor(numCircles/2)

	if activeIndex+halfNumCircles > numCircles then
		activeIndex=activeIndex-(halfNumCircles+1)
	else
		activeIndex=activeIndex+halfNumCircles
	end
end

function onSubmitTouch( event )
	if event.phase == "ended" then
		x_submitted[activeIndex] = circlePlayer.x
		y_submitted[activeIndex] = circlePlayer.y
		local x_diff = math.abs(circlePlayer.x-x[activeIndex])
		local y_diff = math.abs(circlePlayer.y-y[activeIndex])
		updateIndex()	
		if circleCounter == numCircles then
			local options = 
	        { 
	            effect = "crossFade", time = 300, 
	            params = 
	            { 
	                x_submitted = x_submitted,
	                y_submitted = y_submitted,
	                x_real = x,
	                y_real = y,
	                numCircles = numCircles,
	                time_submitted = time_submitted,

					testNumber = testNumber,
					thresholdValue = thresholdValue,
					gainValue = gainValue,
		            switchAccelerometer = switchAccelerometer,
		            numOfTests = numOfTests,
					testsArray = testsArray
	            } 
	        }
			composer.gotoScene( "test_counter", options )
			endgame = 1
		end
		circleCounter = circleCounter + 1
		changeTarget(activeIndex)
	end
end

function onAccelerateRaw( event )
	if endgame == 0 then
		count = count + 1
		countText.text=count
	    textX.text = "X:"..event.xRaw
	    textY.text = "Y:"..event.yRaw
	    textZ.text = "Z:"..event.zRaw

	    circlePlayer.x = circlePlayer.x + event.xRaw*20
	    circlePlayer.y = circlePlayer.y - event.yRaw*20
	    coordinates.text= "X:"..circlePlayer.x.."\n Y:"..circlePlayer.y
	end
end

function onAccelerateGravity( event )
	if endgame == 0 then
		count = count + 1
		countText.text=count
	    textX.text = "X:"..event.xGravity
	    textY.text = "Y:"..event.yGravity
	    textZ.text = "Z:"..event.zGravity

	    circlePlayer.x = circlePlayer.x + event.xGravity*20
	    circlePlayer.y = circlePlayer.y - event.yGravity*20
	    coordinates.text= "X:"..circlePlayer.x.."\n Y:"..circlePlayer.y
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
