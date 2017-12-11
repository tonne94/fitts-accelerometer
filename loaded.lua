------------------------------------------------------------------------
--
-- loaded.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

testsArray = {}
line = {}
function scene:create(event)
	sceneGroup = self.view

	displayVAriables = display.newText("", halfW, halfH, deafult, 20)
    nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

    sceneGroup:insert(nextButton)

	sceneGroup:insert(displayVAriables)
end

function scene:show(event)
	if event.phase == "will" then
        composer.removeScene("main_menu")

        nextButton:addEventListener("touch", onNextButtonTouch)

		local path = system.pathForFile( "last_test", system.TemporaryDirectory)
		local file, errorString = io.open( path, "r" )
		if not file then
		-- Error occurred; output the cause
		    print("File error: " .. errorString)
		    displayVAriables.text="NO LOADED TEST"
			nextButton.text="BACK"
		else
			-- Read data from file
		    contents = file:read( "*a" )
		    -- Close the file handle
		    io.close( file )

			displayVAriables.text=contents
			i=1
	        for w in contents:gmatch("([^:]*);") do 
	        	line[i]=w
	        	i=i+1
	        end

	        testNumber = tonumber(line[1]) 
	        numOfTests = tonumber(line[2]) 
	        if tonumber(line[3])==1 then
				switchAccelerometer = true
			else
				switchAccelerometer = false
			end
			gainValue = tonumber(line[4]) 
			thresholdValue = tonumber(line[5]) 

	 		if tonumber(line[6])==1 then
				switchSubmitStyle = true
			else
				switchSubmitStyle = false
			end

		    dwellTimeValue = tonumber(line[7])
		    
		    for i=1, numOfTests, 1 do
		    	k=1
		    	testsArray[i] = {}
				for word in line[i+7]:gmatch("(.-),") do 
		        	testsArray[i][k]=tonumber(word)
		        	k=k+1
	        	end
		    end  
		end
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
