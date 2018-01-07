-- Requirements
local composer = require "composer"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

-- display elements
local menuBackground

local resumeText
local optionsText
local exitText

-------- FUNCTION LISTENER --------------------------------------------------

local function onResumeTapped(event)
     composer:hideOverlay()

     local gameScene = composer.getScene("scene.game")
     print("Game-scene object")
     print(gameScene)
     gameScene:onResume()

     return true
end

local function onOptionsTapped(event)
     composer:hideOverlay()
     composer.showOverlay( "scene.optionsMenu")

     return true
end

local function onExitTapped(event)
     composer.gotoScene( "scene.menu" )

     local gameScene = composer.getScene("scene.game")
     gameScene:setDeathPlayer()

     return true
end

-------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     local distance = 34

     menuBackground = newMenuBackground(sceneGroup)

     resumeText = display.newText({
          parent = sceneGroup,
          text = "Resume",
          x = display.contentCenterX,
          y = display.contentCenterY - distance,
          font = native.systemFont,
          fontSize = fontSizeUi
     })
     resumeText:addEventListener("tap", onResumeTapped)

     optionsText = display.newText({
          parent = sceneGroup,
          text = "Options",
          x = display.contentCenterX,
          y = display.contentCenterY,
          font = native.systemFont,
          fontSize = fontSizeUi
     })
     optionsText:addEventListener("tap", onOptionsTapped)

     exitText = display.newText({
          parent = sceneGroup,
          text = "Exit",
          x = display.contentCenterX,
          y = display.contentCenterY + distance,
          font = native.systemFont,
          fontSize = fontSizeUi
     })
     exitText:addEventListener("tap", onExitTapped)

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
