-- Requirements
local composer = require "composer"
local menuBackgroundFactory = require "scene.lib.MenuBackground"
local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

-- Display elements

local menuBackground
local volumeBtn
local costumeBtn
local backBtn

----- Functions Callbacks -----------

local function onVolumeTapped()
     composer.showOverlay( "scene.volumeMenu" )
     return true
end

local function onCostumeTapped()
     composer.showOverlay( "scene.costumeMenu")
     return true
end

local function onBackTapped()
     composer.showOverlay( "scene.pauseMenu" )
     return true
end

---------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     local distance = 34

     --menuBackgroundFactory.new(menuBackground, display, sceneGroup)
     menuBackground = newMenuBackground(sceneGroup)

     volumeBtn = display.newText({
          parent = sceneGroup,
          text = "Volume",
          x = display.contentCenterX,
          y = display.contentCenterY - distance,
          font = native.systemFont,
          fontSize = fontSizeUi
     })
     volumeBtn:addEventListener("tap", onVolumeTapped)

     costumeBtn = display.newText({
          parent = sceneGroup,
          text = "Costume",
          x = display.contentCenterX,
          y = display.contentCenterY,
          font = native.systemFont,
          fontSize = fontSizeUi
     })
     costumeBtn:addEventListener("tap", onCostumeTapped)

     backBtn = newBackBtn(sceneGroup, display.contentCenterX,
     display.contentCenterY + distance, "scene.pauseMenu")

end

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
