-- Requirements
local composer = require "composer"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

-- display elements
local buttons

local fromMainMenu = false

-------- FUNCTION LISTENER --------------------------------------------------

local function onPlayTapped(event)
     composer.hideOverlay()
     composer.gotoScene( "scene.game" )
end

local function onResumeTapped(event)
     composer:hideOverlay()

     local gameScene = composer.getScene("scene.game")
     print("Resume Game-scene object")
     gameScene:onResume()

     return true
end

local function onHelpTapped(event)
     composer.showOverlay( "scene.helpMenu", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu}
     } )
     return true
end

local function onOptionsTapped(event)
     composer.showOverlay( "scene.optionsMenu", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu}
     } )

     return true
end

local function onBestScoreTapped(event)
     composer.showOverlay( "scene.highestScore", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu}
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
     end

     if fromMainMenu then
          buttons = newMainMenu(sceneGroup, 90)

          buttons.playBtn:setLabel("Play")
          buttons.playBtn:addEventListener("tap", onPlayTapped)
     else
          buttons = newMainMenu(sceneGroup)
          buttons.playBtn:addEventListener("tap", onResumeTapped)
     end

     buttons.helpBtn:addEventListener("tap", onHelpTapped)
     buttons.optionsBtn:addEventListener("tap", onOptionsTapped)
     buttons.bestscoreBtn:addEventListener("tap", onBestScoreTapped)
     buttons.exitBtn:addEventListener("tap", onExitTapped)

     -- menuBackground = newMenuBackground(sceneGroup)
     --
     -- resumeText = display.newText({
     --      parent = sceneGroup,
     --      text = "Resume",
     --      x = display.contentCenterX,
     --      y = display.contentCenterY - distance,
     --      font = native.systemFont,
     --      fontSize = fontSizeUi
     -- })
     -- resumeText:addEventListener("tap", onResumeTapped)
     --
     -- optionsText = display.newText({
     --      parent = sceneGroup,
     --      text = "Options",
     --      x = display.contentCenterX,
     --      y = display.contentCenterY,
     --      font = native.systemFont,
     --      fontSize = fontSizeUi
     -- })
     -- optionsText:addEventListener("tap", onOptionsTapped)
     --
     -- exitText = display.newText({
     --      parent = sceneGroup,
     --      text = "Exit",
     --      x = display.contentCenterX,
     --      y = display.contentCenterY + distance,
     --      font = native.systemFont,
     --      fontSize = fontSizeUi
     -- })
     -- exitText:addEventListener("tap", onExitTapped)

     --widget.newButton()
end

-- local function enterFrame(event)
--   local elapsed = event.time
-- end

function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    --Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then

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
