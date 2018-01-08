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

    sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
    sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName = display.newText("Settings", halfW, halfH/15, deafult, 70)

	amplitudesInfo = display.newText("Amplitudes:", halfW, halfH/4, deafult, 50)
	amplitudesTextField = native.newTextField(halfW, halfH/4+halfH/9, screenW-halfW/4, 60)
    amplitudesTextField.font = native.newFont( native.systemFont, 40 )
    amplitudesTextField.isEditable = true
    amplitudesTextField.text = "150;200;250;"
    
	targetSizesInfo = display.newText("Target sizes:", halfW, halfH/2, deafult, 50)
    targetSizesTextField = native.newTextField(halfW, halfH/2+halfH/9, screenW-halfW/4, 60)
    targetSizesTextField.font = native.newFont( native.systemFont, 40 )
    targetSizesTextField.isEditable = true
    targetSizesTextField.text = "60;90;120;"

    playerSizesInfo = display.newText("Player sizes:", halfW, 3*halfH/4, deafult, 50)
    playerSizesTextField = native.newTextField(halfW, 3*halfH/4+halfH/9, screenW-halfW/4, 60)
    playerSizesTextField.font = native.newFont( native.systemFont, 40 )
    playerSizesTextField.isEditable = true
    playerSizesTextField.text = "30;"

    targetNumberInfo = display.newText("Number of targets:", halfW, halfH, deafult, 50)
    targetNumberTextField = native.newTextField(halfW, halfH+halfH/9, screenW-halfW/4, 60)
    targetNumberTextField.font = native.newFont( native.systemFont, 40 )
    targetNumberTextField.isEditable = true
    targetNumberTextField.text = "11;"

	testNumberInfo = display.newText("Number of tests:", halfW, halfH+halfH/4, deafult, 50)
	testNumber = display.newText("3*3*1*1=9", halfW, halfH+halfH/4+halfH/9, deafult, 50)
	
    nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)
    checkButton = display.newText("CHECK", halfW, screenH-halfH/3, deafult, 100)
    backButton = display.newRect( 50, 50, 80, 80 )

    sceneGroup:insert(sceneNameBg)
    sceneGroup:insert(sceneName)
    sceneGroup:insert(amplitudesInfo)
    sceneGroup:insert(amplitudesTextField)
    sceneGroup:insert(targetSizesInfo)
    sceneGroup:insert(targetSizesTextField)
    sceneGroup:insert(playerSizesInfo)
    sceneGroup:insert(playerSizesTextField)
    sceneGroup:insert(targetNumberInfo)
    sceneGroup:insert(targetNumberTextField)
	sceneGroup:insert(testNumberInfo)
	sceneGroup:insert(testNumber)
    sceneGroup:insert(checkButton)
    sceneGroup:insert(nextButton)
    sceneGroup:insert(backButton)
end

function onBackButtonTouch( event )
    if event.phase == "ended" then
        composer.gotoScene( "main_menu", "crossFade", 300 )
    end
end

function scene:show(event)
	if event.phase == "will" then
        print("adv_settings_scene:show_will") 
        composer.removeScene("main_menu")
        composer.removeScene("adv_settings_2")
        nextButton:addEventListener("touch", onNextButtonTouch)
        checkButton:addEventListener("touch", onCheckButtonTouch)
        backButton:addEventListener("touch", onBackButtonTouch)
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

        str = amplitudesTextField.text
        i=1
        for w in str:gmatch("(.-);") do 
            numAmplitudes[i] = tonumber(w)
            i=i+1
        end

        str = targetSizesTextField.text
        i=1
        for w in str:gmatch("(.-);") do 
            numTargetSizes[i] = tonumber(w)
            i=i+1
        end

        str = playerSizesTextField.text
        i=1
        for w in str:gmatch("(.-);") do 
            numPlayerSizes[i] = tonumber(w)
            i=i+1
        end

        str = targetNumberTextField.text
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
