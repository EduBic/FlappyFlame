-- Requirements
local composer = require "composer"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

-- display elements
local buttons

local fromMainMenu = false
local isGameLost = false

local bgMusic

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
     } )
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
     } )

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

     if fromMainMenu then
          buttons = newMainMenu(sceneGroup, 90)

          buttons.playBtn:setLabel("Play")
          buttons.playBtn:addEventListener("tap", onPlayTapped)
     elseif isGameLost then
          buttons = newMainMenu(sceneGroup)

          buttons.playBtn:setLabel("Restart")
          buttons.playBtn:addEventListener("tap", onRestartTapped)
     else
          buttons = newMainMenu(sceneGroup)
          buttons.playBtn:addEventListener("tap", onResumeTapped)
     end

     buttons.helpBtn:addEventListener("tap", onHelpTapped)
     buttons.optionsBtn:addEventListener("tap", onOptionsTapped)
     buttons.bestscoreBtn:addEventListener("tap", onBestScoreTapped)
     buttons.exitBtn:addEventListener("tap", onExitTapped)

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
