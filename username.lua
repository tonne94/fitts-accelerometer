------------------------------------------------------------------------
--
-- username
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local isLoaded = false

function scene:create(event)
	sceneGroup = self.view

	if isLoaded == false then	
		testNumber = event.params.testNumber
		testsArray = event.params.testsArray
		switchAccelerometer = event.params.switchAccelerometer
		numOfTests = event.params.numOfTests
		thresholdValue = event.params.thresholdValue
		gainValue = event.params.gainValue
		switchSubmitStyle = event.params.switchSubmitStyle
	    dwellTimeValue = event.params.dwellTimeValue

    	last_test_file_string = "testNumber:"..testNumber..";"
    	last_test_file_string = last_test_file_string.."\nnumOfTests:"..numOfTests..";"

    	if switchAccelerometer then
    		last_test_file_string = last_test_file_string.."\nswitchAccelerometer:1"..";"
    	else
    		last_test_file_string = last_test_file_string.."\nswitchAccelerometer:0"..";"
    	end

    	last_test_file_string = last_test_file_string.."\ngainValue:"..gainValue..";"
    	last_test_file_string = last_test_file_string.."\nthresholdValue:"..thresholdValue..";"

    	if switchSubmitStyle then
    		last_test_file_string = last_test_file_string.."\nswitchSubmitStyle:1"..";"
    	else
    		last_test_file_string = last_test_file_string.."\nswitchSubmitStyle:0"..";"
    	end

    	last_test_file_string = last_test_file_string.."\ndwellTimeValue:"..dwellTimeValue..";"

    	for i=1, numOfTests, 1 do
    		last_test_file_string = last_test_file_string.."\ntest"..i..":"..testsArray[i][1]..","
    		last_test_file_string = last_test_file_string..testsArray[i][2]..","
    		last_test_file_string = last_test_file_string..testsArray[i][3]..","
    		last_test_file_string = last_test_file_string..testsArray[i][4]..",;"
    	end

    	--save last test file
    	local path = system.pathForFile( "last_test", system.TemporaryDirectory)
		local file, errorString = io.open( path, "w" )
		if not file then
		-- Error occurred; output the cause
		    print("File error: " .. errorString)
		else
		    -- Write data to file
		    file:write(last_test_file_string)
		    -- Close the file handle
		    io.close( file )
		end
	end


	usernameText = display.newText("Username:", halfW, 3*halfH/4, deafult, 50)
    usernameTextField = native.newTextField(halfW, 3*halfH/4+halfH/9, screenW-halfW/4, 60)
    usernameTextField.font = native.newFont( native.systemFont, 40 )
    usernameTextField.isEditable = true
	usernameTextField.text="user"

	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(usernameText)
    sceneGroup:insert(usernameTextField)
	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
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
                    switchSubmitStyle = switchSubmitStyle,
                    numOfTests = numOfTests,
                    testNumber = testNumber,
                    dwellTimeValue = dwellTimeValue,
                    username = usernameTextField.text
		        } 
		    }
	    composer.gotoScene("test_counter", options)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
