------------------------------------------------------------------------
--
-- blank
--
------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local numAmplitudes = {}
local numTargetSizes = {}
local numPlayerSizes = {}
local numTargets = {}
local resultNumberOfTests = 0

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
    amplitudesTextField:addEventListener( "userInput", textListener )
    
	targetSizesInfo = display.newText("Target sizes:", halfW, halfH/2, deafult, 50)
    targetSizesTextField = native.newTextField(halfW, halfH/2+halfH/9, screenW-halfW/4, 60)
    targetSizesTextField.font = native.newFont( native.systemFont, 40 )
    targetSizesTextField.isEditable = true
    targetSizesTextField.text = "60;90;120;"
    targetSizesTextField:addEventListener( "userInput", textListener )

    playerSizesInfo = display.newText("Player sizes:", halfW, 3*halfH/4, deafult, 50)
    playerSizesTextField = native.newTextField(halfW, 3*halfH/4+halfH/9, screenW-halfW/4, 60)
    playerSizesTextField.font = native.newFont( native.systemFont, 40 )
    playerSizesTextField.isEditable = true
    playerSizesTextField.text = "30;"
    playerSizesTextField:addEventListener( "userInput", textListener )

    targetNumberInfo = display.newText("Number of targets:", halfW, halfH, deafult, 50)
    targetNumberTextField = native.newTextField(halfW, halfH+halfH/9, screenW-halfW/4, 60)
    targetNumberTextField.font = native.newFont( native.systemFont, 40 )
    targetNumberTextField.isEditable = true
    targetNumberTextField.text = "11;"
    targetNumberTextField:addEventListener( "userInput", textListener )

	testNumberInfo = display.newText("Number of tests:", halfW, halfH+halfH/4, deafult, 50)
    testNumber = display.newText("", halfW, halfH+halfH/4+halfH/9, deafult, 50)

    errorInfo = display.newText("Check for the ; symbol in textboxes", halfW, screenH-halfH/3, deafult, 40)
	errorInfo:setFillColor(1,0,0)
    errorInfo.isVisible = false

    nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)
    backButton = display.newImageRect("back_button.png", halfH/8, halfH/8 )
    backButton.x = halfH/15
    backButton.y = halfH/15

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
    sceneGroup:insert(nextButton)
    sceneGroup:insert(errorInfo)
    sceneGroup:insert(backButton)
end

function onBackButtonTouch( event )
    if event.phase == "ended" then
        composer.gotoScene( "main_menu", "crossFade", 300 )
    end
end

function textListener( event )
 
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"ž
 
    elseif ( event.phase == "editing" ) then
        checkTests()
    end
end

function scene:show(event)
	if event.phase == "will" then
        print("adv_settings_scene:show_will") 
        composer.removeScene("main_menu")
        composer.removeScene("adv_settings_2")
        nextButton:addEventListener("touch", onNextButtonTouch)
        backButton:addEventListener("touch", onBackButtonTouch)
        checkTests();
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
        checkTests()
        if(resultNumberOfTests==0) then
            toast.show("ERROR: Number of tests is 0")
            errorInfo.isVisible=true
        else
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
        resultNumberOfTests=table.getn(numAmplitudes)*table.getn(numTargetSizes)*table.getn(numPlayerSizes)*table.getn(numTargets)
        testNumber.text = table.getn(numAmplitudes) .. "*" .. table.getn(numTargetSizes) .. "*" 
                            .. table.getn(numPlayerSizes) .. "*" .. table.getn(numTargets) .. "=" ..resultNumberOfTests
                            
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
