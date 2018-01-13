-- Requirements
local composer = require "composer"
local widget = require "widget"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

-- display elements
local buttons

local helpBtn, bestScoreBtn, exitBtn

local fromMainMenu = false
local isGameLost = false

local bgMusic

-- Global settings
local btnSize = 44
local btnZoomSize = 10
local margin = 8

-------- FUNCTION LISTENER --------------------------------------------------

local function onPlayTapped(event)
     composer.hideOverlay()
     audio.fadeOut( { channel=1, time=500 } )
     timer.performWithDelay( 1005, function()
          audio.stop(1)  -- Stop all audio
     	audio.dispose( bgMusic )
     end)

     composer.gotoScene( "scene.game" )
end

local function onResumeTapped(event)
     composer:hideOverlay()
     audio.fadeOut( { channel=1, time=1000 } )
     timer.performWithDelay( 1005, function()
          audio.stop(1)  -- Stop all audio
     	audio.dispose( bgMusic )
     end)

     local gameScene = composer.getScene("scene.game")
     print("Resume Game-scene object")
     gameScene:onResume()

     return true
end

local function onRestartTapped(event)
     composer.hideOverlay()
     audio.fadeOut( { channel=1, time=1000 } )
     timer.performWithDelay( 1005, function()
          audio.stop(1)  -- Stop all audio
     	audio.dispose( bgMusic )
     end)

     composer.gotoScene( "scene.refresh" )

     return true
end

local function onHelpTapped(event)
     local phase = event.phase

     if phase == "began" then
          helpBtn.width = btnSize + btnZoomSize
          helpBtn.height = btnSize + btnZoomSize
     elseif phase == "ended" then
          helpBtn.width = btnSize
          helpBtn.height = btnSize

          composer.showOverlay( "scene.helpMenu", {
               isModal = true,
               params = { fromMainMenu = fromMainMenu, isGameLost = isGameLost }
          })
     end

     return true
end

local function onOptionsTapped(event)
     composer.showOverlay( "scene.optionsMenu", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu, isGameLost = isGameLost }
     } )

     return true
end

local function onBestScoreTapped(event)
     local phase = event.phase

     if phase == "began" then
          bestScoreBtn.width = btnSize + btnZoomSize
          bestScoreBtn.height = btnSize + btnZoomSize
     elseif phase == "ended" then
          bestScoreBtn.width = btnSize
          bestScoreBtn.height = btnSize

          composer.showOverlay( "scene.highestScore", {
               isModal = true,
               params = { fromMainMenu = fromMainMenu, isGameLost = isGameLost }
          })
     end

     return true
end

local function onExitTapped(event)
     local phase = event.phase

     if phase == "began" then
          exitBtn.width = btnSize + btnZoomSize
          exitBtn.height = btnSize + btnZoomSize
     elseif phase == "ended" then
          exitBtn.width = btnSize
          exitBtn.height = btnSize

          native.requestExit()
     end

     return true
end

-------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     if event.params then
          fromMainMenu = event.params.fromMainMenu or false
          isGameLost = event.params.isGameLost or false
     end


     local playBtn = widget.newButton({
          parent = sceneGroup,
		label = "Resume",
		x = display.contentCenterX,
		y = display.contentCenterY, --topLeftY + fromTopY,
		-- style
		labelColor = mLabelColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})

     if fromMainMenu then
          playBtn:setLabel("Play")
          playBtn:addEventListener("tap", onPlayTapped)
     elseif isGameLost then
          playBtn:setLabel("Restart")
          playBtn:addEventListener("tap", onRestartTapped)
     else
          playBtn:addEventListener("tap", onResumeTapped)
     end


     local optionsBtn = widget.newButton({
          parent = sceneGroup,
		label = "Options",
		left =  playBtn.x  - btnWidth/2 - mStrokeWidth/2,
		top = playBtn.y + btnHeight/2 + marginTop,
		-- style
		labelColor = mLabelColors,
		fillColor = mFillColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
     optionsBtn:addEventListener("tap", onOptionsTapped)


     exitBtn = display.newImageRect(sceneGroup, "assets/exitRight.png",
          btnSize, btnSize)
     exitBtn.x = bottomRightX - btnSize/2 - margin
     exitBtn.y = bottomRightY - btnSize/2 - margin
     exitBtn:addEventListener("touch", onExitTapped)

     helpBtn = display.newImageRect(sceneGroup, "assets/information.png",
          btnSize, btnSize)
     helpBtn.x = bottomRightX - btnSize/2 - margin
     helpBtn.y = topLeftY + btnSize/2 + margin
     helpBtn:addEventListener("touch", onHelpTapped)


     bestScoreBtn = display.newImageRect(sceneGroup, "assets/trophy.png",
          btnSize, btnSize)
     bestScoreBtn.x = topLeftX + btnSize/2 + margin
     bestScoreBtn.y = bottomRightY - btnSize/2 - margin
     bestScoreBtn:addEventListener("touch", onBestScoreTapped)


     local menuBackground = newMenuBackgroundH(sceneGroup, btnHeight*2)
	menuBackground.x = playBtn.x
	menuBackground.y = playBtn.y + (optionsBtn.y - playBtn.y)/2
     menuBackground:toBack()

     bgMusic = audio.loadStream( "assets/TitleScreen.mp3" )
end

function scene:show( event )
     local phase = event.phase
     if ( phase == "will" ) then
     --Runtime:addEventListener("enterFrame", enterFrame)
     elseif ( phase == "did" ) then
          audio.setVolume( loadVolumeSetting(), { channel=1 } )
          audio.play( bgMusic, { channel=1, loops=-1, fadein=2000 } )
     end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    --Runtime:removeEventListener("enterFrame", enterFrame)
  end
end

function scene:destroy( event )
     --collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
