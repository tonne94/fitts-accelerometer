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

function scene:create(event)
	sceneGroup = self.view

	savedTestsLabel = display.newText("", halfW, halfH, deafult, 30)

	sceneGroup:insert(savedTestsLabel)
end

function scene:show(event)
	if event.phase == "will" then
		local path = system.pathForFile("", system.DocumentsDirectory);
	    local resultOK, errorMsg;
	    k=0
	    for file in lfs.dir(path) do
	        local theFile = system.pathForFile(file, system.DocumentsDirectory);

	        for word in theFile:gmatch("([^\\]+)") do 
	        	test=word
        	end
        	
	        k=k+1

        	if k>2 then
	        	savedTestsLabel.text=savedTestsLabel.text.."\n"..test
        	end
	    end 
		
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
