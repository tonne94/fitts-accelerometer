------------------------------------------------------------------------
--
-- saved_tests.lua
--
------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local lfs = require "lfs";

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

	local path = system.pathForFile("", system.DocumentsDirectory);
    local resultOK, errorMsg;
    k=-2
    for file in lfs.dir(path) do
        local theFile = system.pathForFile(file, system.DocumentsDirectory);

        for word in theFile:gmatch("([^\\]+)") do 
        	nameOfFile=word
    	end
    	
        k=k+1

    	if k>0 then
	        savedTests[k]=display.newText(nameOfFile, halfW, k*halfH/15+halfH/10, deafult, 30)
			savedTests[k].name=nameOfFile
			savedTests[k].index=k
			sceneGroup:insert(savedTests[k])
    	end
    end 

    backButton = display.newRect( 50, 50, 80, 80 )

	sceneGroup:insert(sceneNameBg)
    sceneGroup:insert(sceneName)
	sceneGroup:insert(savedTestsLabel)
    sceneGroup:insert(backButton)


end

function scene:show(event)
	if event.phase == "will" then
		for i=1,k,1 do 
			savedTests[i]:addEventListener("touch", onSavedTestPress)
		end
        backButton:addEventListener("touch", onBackButtonTouch)
	end
end

function onBackButtonTouch( event )
    if event.phase == "ended" then
        composer.gotoScene( "main_menu", "crossFade", 300 )
    end
end

function onSavedTestPress( event )
	if event.phase == "ended" then
		local name = event.target.name

		local options =
		{
		   to = "antonio.bradicic@hotmail.com",
		   subject = "Results",
		   body = "",
		   attachment = { baseDir=system.DocumentsDirectory, filename=name, type="application/json" }
		}
		native.showPopup( "mail", options )
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
