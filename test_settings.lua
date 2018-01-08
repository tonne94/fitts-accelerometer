------------------------------------------------------------------------
--
-- test_settings
--
------------------------------------------------------------------------

local composer = require( "composer" )
local toast = require('plugin.toast')
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local numTestsInfo={}
local testsArray = {}
local numOfTests
local numAmplitudes
local numTargetSizes
local numPlayerSizes
local numTargets
local thresholdValue
local gainValu
local switchAccelerometer
local switchSubmitStyle
local dwellTimeValue

function scene:create(event)
	sceneGroup = self.view

	sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
	sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName= display.newText("Tests:", halfW, halfH/15, deafult, 70)

	prevScene = event.params.prevScene

	if prevScene == "adv_settings_2" then
		numAmplitudes = event.params.numAmplitudes
	   	numTargetSizes = event.params.numTargetSizes
	    numPlayerSizes = event.params.numPlayerSizes
	    numTargets = event.params.numTargets
	    thresholdValue = event.params.thresholdValue
		gainValue = event.params.gainValue
		switchAccelerometer = event.params.switchAccelerometer
		switchSubmitStyle = event.params.switchSubmitStyle
        dwellTimeValue = event.params.dwellTimeValue

		numOfTests = table.getn(numAmplitudes)*table.getn(numTargetSizes)*table.getn(numPlayerSizes)*table.getn(numTargets)

		--array for saving tests 
		for f=1, numOfTests do
		    testsArray[f] = {}
		    for g=1, 4 do
		        testsArray[f][g] = 0
		    end
		end

		i=1
		for amplitudes=1, table.getn(numAmplitudes), 1 do
			for targetSize=1, table.getn(numTargetSizes), 1 do
				for playerSize=1, table.getn(numPlayerSizes), 1 do
					for targetNum=1, table.getn(numTargets), 1 do
						testsArray[i][1]=numAmplitudes[amplitudes]
						testsArray[i][2]=numTargetSizes[targetSize]
						testsArray[i][3]=numPlayerSizes[playerSize]
						testsArray[i][4]=numTargets[targetNum]
						i=i+1;
					end
				end
			end
		end
	elseif prevScene == "graphical_settings" then
 		thresholdValue = event.params.thresholdValue
		gainValue = event.params.gainValue
		switchAccelerometer = event.params.switchAccelerometer
		switchSubmitStyle = event.params.switchSubmitStyle
		numOfTests = event.params.numOfTests
		testsArray = event.params.testsArray
        dwellTimeValue = event.params.dwellTimeValue

	elseif prevScene == "loaded" then
 		thresholdValue = event.params.thresholdValue
		gainValue = event.params.gainValue
		switchAccelerometer = event.params.switchAccelerometer
		switchSubmitStyle = event.params.switchSubmitStyle
		numOfTests = event.params.numOfTests
		testsArray = event.params.testsArray
        dwellTimeValue = event.params.dwellTimeValue
        isLoaded = true

    elseif prevScene == "username" then
 		thresholdValue = event.params.thresholdValue
		gainValue = event.params.gainValue
		switchAccelerometer = event.params.switchAccelerometer
		switchSubmitStyle = event.params.switchSubmitStyle
		numOfTests = event.params.numOfTests
		testsArray = event.params.testsArray
        dwellTimeValue = event.params.dwellTimeValue
        isLoaded = event.params.isLoaded
	end

	isRed=false

	for i=1, numOfTests, 1 do 
		numTestsInfo[i]=display.newText("Test["..i.."]: "..testsArray[i][1]..", "..testsArray[i][2]
						..", "..testsArray[i][3]..", "..testsArray[i][4], halfW, i*halfH/15+halfH/10, deafult, 30)
		numTestsInfo[i].index=i

		if testsArray[i][2]==testsArray[i][3] then
			numTestsInfo[i]:setFillColor(1,1,0)
		elseif testsArray[i][2]<testsArray[i][3] then
			numTestsInfo[i]:setFillColor(1,0,0)
			isRed=true
		end

		sceneGroup:insert(numTestsInfo[i])
	end

	testNumber=1

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

    backButton = display.newRect( 50, 50, 80, 80 )


	sceneGroup:insert(sceneNameBg)
	sceneGroup:insert(sceneName)
	sceneGroup:insert(nextButton)
    sceneGroup:insert(backButton)
end

function onBackButtonTouch( event )
    if event.phase == "ended" then
	    if prevScene == "loaded" then
	    	composer.gotoScene( "loaded", "crossFade", 300 )
	    else
	       	composer.gotoScene( "adv_settings_2", "crossFade", 300 )
	    end
    end
end

function scene:show(event)
	if event.phase == "will" then
        print("test_settings_scene:show_will") 
    	--composer.removeScene("adv_settings_2")
    	composer.removeScene("graphical_settings")
    	composer.removeScene("loaded")
    	composer.removeScene("username")

		nextButton:addEventListener("touch", onNextButtonTouch)
        backButton:addEventListener("touch", onBackButtonTouch)
		for j=1,numOfTests,1 do 
			numTestsInfo[j]:addEventListener("touch", onTestPress)
		end
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
		if isRed then
			toast.show("ERROR: Size of player is bigger than the size of target in one of the tests")
        else
        	--go to username screen
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
	                    isLoaded = false
			        } 
			    }
		    composer.gotoScene("username", options)
		end
	end
end


function onTestPress( event )
	if event.phase == "ended" then
		index = event.target.index
		local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            testsArray = testsArray,
                    thresholdValue = thresholdValue,
                    gainValue = gainValue,
                    switchAccelerometer = switchAccelerometer,
                    dwellTimeValue = dwellTimeValue,
                    numOfTests = numOfTests,
		            index = index
		        } 
		    }
	    composer.gotoScene("graphical_settings", options)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
