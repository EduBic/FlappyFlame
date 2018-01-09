-- Requirements
local composer = require "composer"
local widget = require "widget"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

--------------------

local function gotoGame()
	composer.gotoScene( "scene.game" ) --, { time=800, effect="crossFade" }
end

local function gotoHighestScore()
	composer.gotoScene( "scene.highestScore", { params = { overlay = false} })
end

local function gotoHelp()
end

--------------------

function scene:create( event )
     local sceneGroup = self.view

	local titleText = display.newText( sceneGroup, "FLAPPY FLAME",
                     				display.contentCenterX, topLeftY + 40,
	                                   native.systemFontBold, 35 )
	titleText:setFillColor(1,1,1)

	-- local buttons = newMainMenu(sceneGroup, 90)
     --
	-- buttons.playBtn:addEventListener("tap", gotoGame)
	-- buttons.bestscoreBtn:addEventListener("tap", gotoHighestScore)

	local bg = display.newImageRect(sceneGroup, "assets/background.png",
          display.contentWidth * 2, display.contentHeight)
     bg.x = display.contentCenterX
     bg.y = display.contentCenterY
     bg:toBack()

end


function scene:show( event )
  local phase = event.phase

  if ( phase == "will" ) then
    --composer.removeScene(prevScene, false)
    local mParams = {
	    fromMainMenu = true
    }

    composer.showOverlay( "scene.pauseMenu", { params = mParams } )

  elseif ( phase == "did" ) then
    --composer.gotoScene(prevScene)
  end
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
