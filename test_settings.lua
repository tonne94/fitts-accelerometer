------------------------------------------------------------------------
--
-- test_settings
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local numTestsInfo={}
local testsArray = {}

function scene:create(event)
	sceneGroup = self.view

  	numAmplitudes = event.params.numAmplitudes
    numTargetSizes = event.params.numTargetSizes
    numPlayerSizes = event.params.numPlayerSizes
    numTargets = event.params.numTargets
    thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue
	switchAccelerometer = event.params.switchAccelerometer

	sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
	sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName= display.newText("Tests:", halfW, halfH/15, deafult, 70)

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
					numTestsInfo[i]=display.newText("Test["..i.."]: "..testsArray[i][1]..", "..testsArray[i][2]
						..", "..testsArray[i][3]..", "..testsArray[i][4], halfW, i*halfH/15+halfH/10, deafult, 30)
					sceneGroup:insert(numTestsInfo[i])
					i=i+1;
				end
			end
		end
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
		nextButton:addEventListener("touch", onNextButtonTouch)
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

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
