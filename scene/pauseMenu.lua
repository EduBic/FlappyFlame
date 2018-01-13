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
local marginIconBtn = 8
-- btnIconWidth = ??? ; marginIconBtn = 8 -> 8*2 = 16; strokeWidth = 1 -> 1*2*3 = 6
local btnIconWidth = (btnWidth - marginIconBtn - 2*mStrokeWidth*3)/3 - 0.2
local btnIconHeigh = btnHeight
local btnIconSize = btnIconHeigh - 8



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
     composer.showOverlay( "scene.helpMenu", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu, isGameLost = isGameLost }
     })

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
     composer.showOverlay( "scene.highestScore", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu, isGameLost = isGameLost }
     })

     return true
end

local function onExitTapped(event)
     native.requestExit()

     return true
end

-------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     if event.params then
          fromMainMenu = event.params.fromMainMenu or false
          isGameLost = event.params.isGameLost or false
     end

     local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)


     local playBtn = widget.newButton({
		label = "Resume",
		x = 0,
		y = - btnHeight - marginTop, --topLeftY + fromTopY,
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
     menuGroup:insert(playBtn)

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
		label = "Options",
		x = 0, y = 0,
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
     menuGroup:insert(optionsBtn)
     optionsBtn:addEventListener("tap", onOptionsTapped)


     helpBtn = widget.newButton({
		x = 0, --playBtn.x  - btnWidth/2 - mStrokeWidth/2,
		y = btnHeight/2 + marginTop + btnIconHeigh/2,
		-- style
          fillColor = mFillColors,
		shape = "roundedRect",
		cornerRadius = 2,
          width = btnIconWidth,
		height = btnIconHeigh,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
     helpBtn:addEventListener("tap", onHelpTapped)
     menuGroup:insert(helpBtn)

     local helpIcon = display.newImageRect(menuGroup, "assets/question.png",
          btnIconSize, btnIconSize)
     helpIcon.x, helpIcon.y = helpBtn.x, helpBtn.y


     exitBtn = widget.newButton({
		x = btnIconWidth + marginIconBtn,
		y = btnHeight/2 + btnIconHeigh/2 + marginTop,
		-- style
          fillColor = mFillColors,
		shape = "roundedRect",
		cornerRadius = 2,
          width = btnIconWidth,
		height = btnIconHeigh,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
     exitBtn:addEventListener("tap", onExitTapped)
     menuGroup:insert(exitBtn)

     local exitIcon = display.newImageRect(menuGroup, "assets/exitRight.png",
          btnIconSize, btnIconSize)
     exitIcon.x, exitIcon.y = exitBtn.x, exitBtn.y


     bestscoreBtn = widget.newButton({
		x = - btnIconWidth - marginIconBtn,
		y = btnHeight/2 + btnIconHeigh/2 + marginTop,
		-- style
          fillColor = mFillColors,
		shape = "roundedRect",
		cornerRadius = 2,
          width = btnIconWidth,
		height = btnIconHeigh,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
     bestscoreBtn:addEventListener("tap", onBestScoreTapped)
     menuGroup:insert(bestscoreBtn)

     bestScoreBtn = display.newImageRect(menuGroup, "assets/trophy.png",
          btnIconSize, btnIconSize)
     bestScoreBtn.x, bestScoreBtn.y = bestscoreBtn.x,bestscoreBtn.y


     local menuBackground = newMenuBackgroundH(menuGroup,
          btnHeight*2 + btnIconHeigh + marginTop*2)
	menuBackground.x = 0
	menuBackground.y = 0
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
