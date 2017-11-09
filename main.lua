------------------------------------------------------------------------
--
-- main.lua
--
------------------------------------------------------------------------

-- Use the require function to include the Corona "composer" module so 
-- we can load a scene.
local composer = require( "composer" )
-- Once we have access to composer, we can use it load or go to our scene 
-- that is stored in the "menu.lua" script file.
composer.gotoScene( "graphical_settings", "crossFade", 300 )