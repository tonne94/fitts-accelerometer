------------------------------------------------------------------------
--
-- test_counter
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2
numTestsInfo={}
function scene:create(event)
	sceneGroup = self.view

	testNumber = event.params.testNumber
	testsArray = event.params.testsArray
	switchAccelerometer = event.params.switchAccelerometer
	numOfTests = event.params.numOfTests
	thresholdValue = event.params.thresholdValue
	gainValue = event.params.gainValue
	username = event.params.username

	if switchAccelerometer==true then
		switchAccelerometerInfo="raw"
	else
		switchAccelerometerInfo="gravity"
	end

	if testNumber ~= 1 then
		x_submitted = event.params.x_submitted
		y_submitted = event.params.y_submitted
		x_real = event.params.x_real
		y_real = event.params.y_real
		numCircles = event.params.numCircles
		time_submitted = event.params.time_submitted
		hit = event.params.hit
				
		hitValue={}
		isHit=0
		for i=0, table.getn(hit),1 do
			if hit[i]==true then
				isHit=isHit+1
				hitValue[i]="true"
			else
				hitValue[i]="false"
			end

		end
		local subtask = ""  

			for i=0, table.getn(x_submitted),1 do
				if i==0 then
					k=0
					subtask=subtask.."\t\t\t\t\"subtask["..i.."]\":".."\n\t\t\t\t{\n\t\t\t\t\t\"x_submitted\":"..x_submitted[i]..",\n\t\t\t\t\t\"y_submitted\":"..y_submitted[i]
    				..",\n\t\t\t\t\t\"x_real\":"..x_real[i]..",\n\t\t\t\t\t\"y_real\":"..y_real[i]..",\n\t\t\t\t\t\"time_submitted\":"..(time_submitted[i]-time_submitted[k])..",\n\t\t\t\t\t\"is_hit\":\""..hitValue[i].."\"\n\t\t\t\t},\n"
				elseif i==table.getn(x_submitted) then
					k=i-1
					subtask=subtask.."\t\t\t\t\"subtask["..i.."]\":".."\n\t\t\t\t{\n\t\t\t\t\t\"x_submitted\":"..x_submitted[i]..",\n\t\t\t\t\t\"y_submitted\":"..y_submitted[i]
    				..",\n\t\t\t\t\t\"x_real\":"..x_real[i]..",\n\t\t\t\t\t\"y_real\":"..y_real[i]..",\n\t\t\t\t\t\"time_submitted\":"..(time_submitted[i]-time_submitted[k])..",\n\t\t\t\t\t\"is_hit\":\""..hitValue[i].."\"\n\t\t\t\t}\n"
				else
					k=i-1
					subtask=subtask.."\t\t\t\t\"subtask["..i.."]\":".."\n\t\t\t\t{\n\t\t\t\t\t\"x_submitted\":"..x_submitted[i]..",\n\t\t\t\t\t\"y_submitted\":"..y_submitted[i]
    				..",\n\t\t\t\t\t\"x_real\":"..x_real[i]..",\n\t\t\t\t\t\"y_real\":"..y_real[i]..",\n\t\t\t\t\t\"time_submitted\":"..(time_submitted[i]-time_submitted[k])..",\n\t\t\t\t\t\"is_hit\":\""..hitValue[i].."\"\n\t\t\t\t},\n"
				end
    			
	        end
        subtask="\n\t\t\t\"subtasks\":\n\t\t\t{\n"..subtask.."\t\t\t}\n"

        total_time=time_submitted[numCircles]-time_submitted[1]
        avg_time=(time_submitted[numCircles]-time_submitted[1])/(numCircles-1)
		
		local testJson = ""
		testJson=testJson.."\n\t\t\t\"amplitude\":"..testsArray[testNumber-1][1]..",\n\t\t\t\"target_size\":"..testsArray[testNumber-1][2]..",\n\t\t\t\"player_size\":"..testsArray[testNumber-1][3]
				..",\n\t\t\t\"num_targets\":"..testsArray[testNumber-1][4]..",\n\t\t\t\"accelerometer\":\""..switchAccelerometerInfo.."\",\n\t\t\t\"hits\":\""..isHit.."/"..(numCircles+1).."\",\n\t\t\t\"threshold\":"..thresholdValue..
				",\n\t\t\t\"gain\":"..(gainValue/10)..",\n\t\t\t\"total_time\":"..total_time..",\n\t\t\t\"avg_time\":"..avg_time..","..subtask


		if (testNumber-1)==numOfTests then
			testJson = "\n\t\t\"test["..(testNumber-1).."]\":\n\t\t{"..testJson.."\t\t}"
		else
			testJson = "\n\t\t\"test["..(testNumber-1).."]\":\n\t\t{"..testJson.."\t\t},"
		end

		local path = system.pathForFile( "test"..(testNumber-1).."-"..username..".json", system.TemporaryDirectory)
		local file, errorString = io.open( path, "w" )
		if not file then
    	-- Error occurred; output the cause
		    print("File error: " .. errorString)
		else
		    -- Write data to file
		    file:write( testJson )
		    -- Close the file handle
		    io.close( file )
		end

	end

	infoLabel = display.newText("", halfW, halfH, deafult, 70)

	nextButton = display.newText("START TEST", halfW, screenH-halfH/8, deafult, 80)

	finished = false

	if (testNumber-1)==table.getn(testsArray) then
		infoLabel.text = username.."\nAll tests finished!"
		finished = true
		nextButton.text="GO TO RESULTS"
	else
		infoLabel.text = username.."\nGet ready for:\nTest["..testNumber.."]"
	end


	sceneGroup:insert(infoLabel)
	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
    	composer.removeScene("test_screen")
    	composer.removeScene("username")
		nextButton:addEventListener("touch", onNextButtonTouch)
	end
end

function scene:hide(event)
end

function scene:destroy(event)
end

function onNextButtonTouch( event )
	if event.phase == "ended" then
		if finished==true then
			local options = 
			    { 
			        effect = "crossFade", time = 300, 
			        params = 
			        { 
			        	numOfTests=numOfTests,
			            username = username
			        } 
			    }
			    composer.gotoScene("endgame", options)
		else
			local options = 
			    { 
			        effect = "crossFade", time = 300, 
			        params = 
			        { 
			            radius = testsArray[testNumber][1],
			            circleSize = testsArray[testNumber][2],
			            playerSize = testsArray[testNumber][3],
			            numCircles = testsArray[testNumber][4],
			            username = username,

						testNumber = testNumber,
						thresholdValue = thresholdValue,
						gainValue = gainValue,
			            switchAccelerometer = switchAccelerometer,
			            numOfTests = numOfTests,
						testsArray = testsArray
			        } 
			    }
			    composer.gotoScene("test_screen", options)
		end
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
