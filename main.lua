-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require( "physics" )

physics.setDrawMode( "normal" )

-- Display info
topLeftX = display.screenOriginX
topLeftY = display.screenOriginY

bottomRightX = display.contentWidth - display.screenOriginX
bottomRightY = display.contentHeight - display.screenOriginY

-- Global options
fontSizeUi = 23

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- DEBUG
-- print("logging: display = " .. topLeftX .. ":" .. topLeftY)
-- print("logging: display = " .. bottomRightX .. ":" .. bottomRightY)
-- display.newLine(topLeftX, topLeftY, bottomRightX, bottomRightY)

print("Origin x = "..tostring(display.screenOriginX))
print("Origin y = "..tostring(display.screenOriginY))

-- Seed the random number generator
math.randomseed( os.time() )

-- Go to the menu screen
composer.gotoScene( "scene.menu" )
