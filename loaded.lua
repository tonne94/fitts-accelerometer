------------------------------------------------------------------------
--
-- loaded.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

testsArray = {}
line = {}
function scene:create(event)
	sceneGroup = self.view

	sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
    sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName = display.newText("Last test parametars loaded", halfW+halfH/15, halfH/15, deafult, screenH/28)

	displayVariables = display.newText("", halfW, 0, deafult, screenH/32)
	displayVariables.anchorY=0
	
    nextButton = display.newText("NEXT", halfW, screenH-halfH/9, deafult, screenH/12) 
    nextButtonRect = display.newRect(halfW, screenH-halfH/9, nextButton.width+halfW/20, nextButton.height)
    nextButtonRect:setFillColor (0.2,0.2,0.2)
    nextButtonRect.stroke = { 0.8, 0.8, 1 }
    nextButtonRect.strokeWidth = 4

	backButton = display.newImageRect("back_button.png", halfH/8, halfH/8 )
	backButton.x = halfH/15
	backButton.y = halfH/15

	sceneGroup:insert(sceneNameBg)
    sceneGroup:insert(sceneName)
		sceneGroup:insert(nextButtonRect)
    sceneGroup:insert(nextButton)
	--sceneGroup:insert(displayVariables)
    sceneGroup:insert(backButton)

end

function onBackButtonTouch( event )
    if event.phase == "ended" then
        composer.gotoScene( "main_menu", "crossFade", 300 )
    end
end

function scene:show(event)
	if event.phase == "will" then
		print("loaded_scene:show_will") 
        composer.removeScene("main_menu")
        composer.removeScene("test_settings")
		backButton:addEventListener("touch", onBackButtonTouch)
        nextButton:addEventListener("touch", onNextButtonTouch)

		local path = system.pathForFile( "last_test", system.TemporaryDirectory)
		local file, errorString = io.open( path, "r" )
		if not file then
		-- Error occurred; output the cause
		    print("File error: " .. errorString)
		    displayVariables.text="NO LOADED TEST"
			nextButton.text="BACK"
		else
			-- Read data from file
		    contents = file:read( "*a" )
		    -- Close the file handle
		    io.close( file )

			displayVariables.text=contents
			i=1
	        for w in contents:gmatch("([^:]*);") do 
	        	line[i]=w
	        	i=i+1
	        end

	        numOfTests = tonumber(line[1]) 
	        if tonumber(line[2])==1 then
				switchAccelerometer = true
			else
				switchAccelerometer = false
			end
			gainValue = tonumber(line[3]) 
			thresholdValue = tonumber(line[4]) 

	 		if tonumber(line[5])==1 then
				switchSubmitStyle = true
			else
				switchSubmitStyle = false
			end

		    dwellTimeValue = tonumber(line[6])
		    
		    for i=1, numOfTests, 1 do
		    	k=1
		    	testsArray[i] = {}
				for word in line[i+6]:gmatch("(.-),") do 
		        	testsArray[i][k]=tonumber(word)
		        	k=k+1
	        	end
		    end  
		end

		local scrollView = widget.newScrollView(
		    {
		         x=halfW,
                y=halfH-halfH/30,
		        width = screenW,
		        height = screenH-2*halfH/5,
		        backgroundColor = { 0.2, 0.2, 0.2 },
		        scrollWidth = 0,
		        scrollHeight = 0,
		        listener = scrollListener
		    }
		)
		scrollView:insert(displayVariables)
		sceneGroup:insert(scrollView)

	end
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
	   	--go to test_settings screen
	   	if nextButton.text=="NEXT" then
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
	                	prevScene = "loaded"
			        } 
			    }
		    composer.gotoScene("test_settings", options)

		elseif nextButton.text=="BACK" then
			composer.gotoScene("main_menu", options)
		end

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
