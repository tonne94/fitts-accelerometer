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

numTestsInfo={}

function scene:create(event)
	sceneGroup = self.view

  	numAmplitudes = event.params.numAmplitudes
    numTargetSizes = event.params.numTargetSizes
    numPlayerSizes = event.params.numPlayerSizes
    numTargets = event.params.numTargets
    thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue
	switchAccelerometer = event.params.switchAccelerometer

	sceneName= display.newText("Tests:", halfW, halfH/15, deafult, 70)

	numTests = table.getn(numAmplitudes)*table.getn(numTargetSizes)*table.getn(numPlayerSizes)*table.getn(numTargets)
	i=1

	for amplitudes=1, table.getn(numAmplitudes), 1 do
		for targetSize=1, table.getn(numTargetSizes), 1 do
			for playerSize=1, table.getn(numPlayerSizes), 1 do
				for targetNum=1, table.getn(numTargets), 1 do
					numTestsInfo[i]=display.newText("Test["..i.."]: "..numAmplitudes[amplitudes]..", "..numTargetSizes[targetSize]..", "..numPlayerSizes[playerSize]..", "..numTargets[targetNum], halfW, i*halfH/15+halfH/10, deafult, 30)
					sceneGroup:insert(numTestsInfo[i])
					i=i+1;
				end
			end
		end
	end
	
	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

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
		composer.gotoScene( "graphical_settings", "crossFade", 300 )
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
