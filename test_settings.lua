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
	end
  	
	if prevScene == "graphical_settings" then
 		thresholdValue = event.params.thresholdValue
		gainValue = event.params.gainValue
		switchAccelerometer = event.params.switchAccelerometer
		numOfTests = event.params.numOfTests
		testsArray = event.params.testsArray
	end

	isRed=false

	for i=1, numOfTests, 1 do 
		numTestsInfo[i]=display.newText("Test["..i.."]: "..testsArray[i][1]..", "..testsArray[i][2]
						..", "..testsArray[i][3]..", "..testsArray[i][4], halfW, i*halfH/15+halfH/10, deafult, 30)
		numTestsInfo[i].index=i

		if testsArray[i][2]==testsArray[i][3] then
			numTestsInfo[i]:setFillColor(1,1,0)
		elseif
			testsArray[i][2]<testsArray[i][3] then
			numTestsInfo[i]:setFillColor(1,0,0)
			isRed=true
		end

		sceneGroup:insert(numTestsInfo[i])
	end

	testNumber=1

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(sceneNameBg)
	sceneGroup:insert(sceneName)
	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then

    	composer.removeScene("adv_settings_2")
    	composer.removeScene("graphical_settings")

		nextButton:addEventListener("touch", onNextButtonTouch)
		for j=1,i-1,1 do 
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
	                    testNumber = testNumber
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
