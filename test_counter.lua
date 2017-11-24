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
					subtask=subtask.."\t\t\"subtask["..i.."]\":".."\n\t\t{\n\t\t\t\"x_submitted\":"..x_submitted[i]..",\n\t\t\t\"y_submitted\":"..y_submitted[i]
    				..",\n\t\t\t\"x_real\":"..x_real[i]..",\n\t\t\t\"y_real\":"..y_real[i]..",\n\t\t\t\"time_submitted\":"..(time_submitted[i]-time_submitted[k])..",\n\t\t\t\"is_hit\":"..hitValue[i].."\n\t\t},\n"
				elseif i==table.getn(x_submitted) then
					k=i-1
					subtask=subtask.."\t\t\"subtask["..i.."]\":".."\n\t\t{\n\t\t\t\"x_submitted\":"..x_submitted[i]..",\n\t\t\t\"y_submitted\":"..y_submitted[i]
    				..",\n\t\t\t\"x_real\":"..x_real[i]..",\n\t\t\t\"y_real\":"..y_real[i]..",\n\t\t\t\"time_submitted\":"..(time_submitted[i]-time_submitted[k])..",\n\t\t\t\"is_hit\":"..hitValue[i].."\n\t\t}\n"
				else
					k=i-1
					subtask=subtask.."\t\t\"subtask["..i.."]\":".."\n\t\t{\n\t\t\t\"x_submitted\":"..x_submitted[i]..",\n\t\t\t\"y_submitted\":"..y_submitted[i]
    				..",\n\t\t\t\"x_real\":"..x_real[i]..",\n\t\t\t\"y_real\":"..y_real[i]..",\n\t\t\t\"time_submitted\":"..(time_submitted[i]-time_submitted[k])..",\n\t\t\t\"is_hit\":"..hitValue[i].."\n\t\t},\n"
				end
    			
	        end
	        subtask="{\n\t\"subtasks\":\n\t{\n"..subtask.."\t}\n}"

		local jsonOut = 
		{
			["test["..(testNumber-1).."]"] =
			{
				amplitude=testsArray[testNumber-1][1],
		        target_size=testsArray[testNumber-1][2],
		        player_size=testsArray[testNumber-1][3],
		        num_targets=testsArray[testNumber-1][4],
		        accelometer=switchAccelerometerInfo,
		        threshold=thresholdValue,
		        hit=isHit.."/"..numCircles,
		        gain=gainValue/10,
		        total_time=time_submitted[numCircles]-time_submitted[1],
		        avg_time=(time_submitted[numCircles]-time_submitted[1])/(numCircles-1),
		        subtask=subtask
			}				
			
		}

		results = display.newText("", halfW, halfH, deafult, 20)
		results.text=table.getn(time_submitted)
		print(results.text)
		sceneGroup:insert(results)

		local path = system.pathForFile( "test"..(testNumber-1).."-user.json", system.TemporaryDirectory)
		local file, errorString = io.open( path, "w" )
		if not file then
    	-- Error occurred; output the cause
		    print("File error: " .. errorString)
		else
		    -- Write data to file
		    file:write( subtask )
		    -- Close the file handle
		    io.close( file )
		end

	end


	print(os.date("%c")) 
	nextButton = display.newText("NEXT", halfW, screenH-halfH/10, deafult, 100)

	sceneGroup:insert(nextButton)
end

function scene:show(event)
	if event.phase == "will" then
    	composer.removeScene("test_screen")
    	composer.removeScene("test_settings")
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
		            radius = testsArray[testNumber][1],
		            circleSize = testsArray[testNumber][2],
		            playerSize = testsArray[testNumber][3],
		            numCircles = testsArray[testNumber][4],

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

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
