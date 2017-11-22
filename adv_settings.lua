------------------------------------------------------------------------
--
-- blank
--
------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local numAmplitudes = {}
local numTargetSizes = {}
local numPlayerSizes = {}
local numTargets = {}

function scene:create(event)
	sceneGroup = self.view	

	sceneName = display.newText("Settings", halfW, halfH/10, deafult, 50)

	amplitudesInfo = display.newText("Number of different amplitudes:", halfW, halfH/4, deafult, 30)
	amplitudesTextArea = native.newTextBox(halfW, halfH/4+halfH/9, screenW-halfW/4, 60)
    amplitudesTextArea.font = native.newFont( native.systemFont, 40 )
    amplitudesTextArea.isEditable = true
    amplitudesTextArea.text = "150;200;250;"

	targetSizesInfo = display.newText("Number of different target sizes:", halfW, halfH/2, deafult, 30)
    targetSizesTextArea = native.newTextBox(halfW, halfH/2+halfH/9, screenW-halfW/4, 60)
    targetSizesTextArea.font = native.newFont( native.systemFont, 40 )
    targetSizesTextArea.isEditable = true
    targetSizesTextArea.text = "50;80;110;"

    playerSizesInfo = display.newText("Number of different player sizes:", halfW, 3*halfH/4, deafult, 30)
    playerSizesTextArea = native.newTextBox(halfW, 3*halfH/4+halfH/9, screenW-halfW/4, 60)
    playerSizesTextArea.font = native.newFont( native.systemFont, 40 )
    playerSizesTextArea.isEditable = true
    playerSizesTextArea.text = "50;"

    targetNumberInfo = display.newText("Number of targets:", halfW, halfH, deafult, 30)
    targetNumberTextArea = native.newTextBox(halfW, halfH+halfH/9, screenW-halfW/4, 60)
    targetNumberTextArea.font = native.newFont( native.systemFont, 40 )
    targetNumberTextArea.isEditable = true
    targetNumberTextArea.text = "11;"

	testNumberInfo = display.newText("Number of tests:", halfW, halfH+halfH/4, deafult, 30)
	testNumber = display.newText("3 x 3 x 1 x 1= 9", halfW, halfH+halfH/4+halfH/9, deafult, 50)
	
    nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)
    checkButton = display.newText("CHECK", halfW, screenH-halfH/3, deafult, 100)

	sceneGroup:insert(sceneName)
    sceneGroup:insert(amplitudesInfo)
    sceneGroup:insert(amplitudesTextArea)
    sceneGroup:insert(targetSizesInfo)
    sceneGroup:insert(targetSizesTextArea)
    sceneGroup:insert(playerSizesInfo)
    sceneGroup:insert(playerSizesTextArea)
    sceneGroup:insert(targetNumberInfo)
    sceneGroup:insert(targetNumberTextArea)
	sceneGroup:insert(testNumberInfo)
	sceneGroup:insert(testNumber)
    sceneGroup:insert(checkButton)
    sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
        nextButton:addEventListener("touch", onNextButtonTouch)
        checkButton:addEventListener("touch", onCheckButtonTouch)
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
        checkTests()
		local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            numAmplitudes = numAmplitudes, 
                    numTargetSizes = numTargetSizes,
                    numPlayerSizes = numPlayerSizes,
                    numTargets = numTargets
		        } 
		    }
	    composer.gotoScene("adv_settings_2", options)
	end
end

function onCheckButtonTouch( event )
    if event.phase == "ended" then
        checkTests()
    end
end

function checkTests()

        numAmplitudes = {}
        numTargetSizes = {}
        numPlayerSizes = {}
        numTargets = {}

        str = amplitudesTextArea.text
        i=1
        for w in str:gmatch("(.-);") do 
            numAmplitudes[i] = tonumber(w)
            i=i+1
        end

        str = targetSizesTextArea.text
        i=1
        for w in str:gmatch("(.-);") do 
            numTargetSizes[i] = tonumber(w)
            i=i+1
        end

        str = playerSizesTextArea.text
        i=1
        for w in str:gmatch("(.-);") do 
            numPlayerSizes[i] = tonumber(w)
            i=i+1
        end

        str = targetNumberTextArea.text
        i=1
        for w in str:gmatch("(.-);") do 
            numTargets[i] = tonumber(w)
            i=i+1
        end

        testNumber.text = table.getn(numAmplitudes) .. "*" .. table.getn(numTargetSizes) .. "*" 
                            .. table.getn(numPlayerSizes) .. "*" .. table.getn(numTargets) .. "=" .. 
                            table.getn(numAmplitudes)*table.getn(numTargetSizes)*table.getn(numPlayerSizes)*table.getn(numTargets)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
