------------------------------------------------------------------------
--
-- saved_tests.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local lfs = require "lfs";
local widget = require( "widget" )

local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = screenW/2
local halfH = screenH/2

local savedTests = {}

function scene:create(event)
	sceneGroup = self.view

	sceneNameBg = display.newRect(halfW, halfH/15, screenW, 2*halfH/15)
    sceneNameBg:setFillColor(1,0,0, 0.5)
	sceneName = display.newText("Saved tests", halfW, halfH/15, deafult, 70)

	savedTestsLabel = display.newText("", halfW, halfH, deafult, 40)

	backButton = display.newRect( 50, 50, 80, 80 )

	sceneGroup:insert(sceneNameBg)
    sceneGroup:insert(sceneName)
	sceneGroup:insert(savedTestsLabel)
    sceneGroup:insert(backButton)


end

local function scrollListener( event )
 
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end
 
    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end
 
    return true
end

function onSavedTestPress( event )
	print(event.phase)
	if event.phase == "began" then
	--[[
		local name = event.target.name

		local options =
		{
		   to = "antonio.bradicic@hotmail.com",
		   subject = "Results",
		   body = "",
		   attachment = { baseDir=system.DocumentsDirectory, filename=name, type="application/json" }
		}
		native.showPopup( "mail", options )
		]]--
		local name = event.target.name
        local options = 
		    { 
		        effect = "crossFade", time = 300, 
		        params = 
		        { 
		            nameOfFile = name
		        } 
		    }
	    composer.gotoScene("show_saved_test", options)

	end
end

function scene:show(event)
	if event.phase == "will" then
		print("saved_test_scene:show_will") 
    	composer.removeScene("show_saved_test")
    	composer.removeScene("main_menu")
		
        backButton:addEventListener("touch", onBackButtonTouch)

        local scrollView = widget.newScrollView(
		    {
		        x=halfW,
                y=halfH,
		        width = screenW,
		        height = screenH-200,
		        backgroundColor = { 0.2, 0.2, 0.2 },
		        scrollWidth = 0,
		        scrollHeight = 0,
		        listener = scrollListener
		    }
		)
		local path = system.pathForFile("", system.DocumentsDirectory);
	    local resultOK, errorMsg;
	    k=-2
	    for file in lfs.dir(path) do
	        local theFile = system.pathForFile(file, system.DocumentsDirectory);

	        for word in theFile:gmatch("([^/]+)") do 
	        	nameOfFile=word
	    	end
	    	
	        k=k+1

	    	if k>0 then
		        savedTests[k]=display.newText(nameOfFile, halfW, k*halfH/10+halfH/10, deafult, 50)
				savedTests[k].name=nameOfFile
				savedTests[k].index=k
				scrollView:insert(savedTests[k])
	    	end
	    end 

	    for i=1, k, 1 do
			savedTests[i]:addEventListener("touch", onSavedTestPress)
    	end
		--local background = display.newImageRect( "assets/scrollimage.png", 768, 1024 )
		sceneGroup:insert(scrollView)
	end
end



function onBackButtonTouch( event )
    if event.phase == "ended" then
        composer.gotoScene( "main_menu", "crossFade", 300 )
    end
end



function scene:hide(event)
end

function scene:destroy(event)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
