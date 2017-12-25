-- Requirements
local composer = require "composer"

-- Variables local to scene
local scene = composer.newScene()

--------------------

local function gotoGame()
	composer.gotoScene( "scene.game" ) --, { time=800, effect="crossFade" }
end

local function gotoHighScores()
	composer.gotoScene( "scene.highscores", { time=800, effect="crossFade" } )
end

--------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group
	-- Code here runs when the scene is first created but has not yet appeared on screen

     print( "create menu" )

	-- local background = display.newImageRect( sceneGroup, "background.png", 800, 1400 )
	-- background.x = display.contentCenterX
	-- background.y = display.contentCenterY
     --
	-- local title = display.newImageRect( sceneGroup, "balloon.png", 500, 80 )
	-- title.x = display.contentCenterX
	-- title.y = 200

	local playButton = display.newText( sceneGroup, "Play",
                                         display.contentCenterX,
                                         display.contentCenterY,
                                         native.systemFont, 35 )
	--playButton:setFillColor( 0.82, 0.86, 1 )

	-- local highScoresButton = display.newText( sceneGroup, "High Scores",
     --                                           display.contentCenterX,
     --                                           display.contentCenterY + 30,
     --                                           native.systemFont, 35 )
	--highScoresButton:setFillColor( 0.75, 0.78, 1 )

	playButton:addEventListener( "tap", gotoGame )
	--highScoresButton:addEventListener( "tap", gotoHighScores )
end


function scene:show( event )
  -- local phase = event.phase
  -- if ( phase == "will" ) then
  --
  -- elseif ( phase == "did" ) then
  --
  -- end
end

function scene:hide( event )
  -- local phase = event.phase
  -- if ( phase == "will" ) then
  --
  -- elseif ( phase == "did" ) then
  --
  -- end
end

function scene:destroy( event )
  --collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
