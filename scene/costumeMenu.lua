-- Requirements
local composer = require "composer"

local menuUtils = require "scene.lib.menuUtils"
local jsonUtils = require "scene.lib.jsonUtils"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------

local menuBackground
local styleOne
local styleTwo
local styleThree
local backBtn

------- Functions callbacks -----------------------------------------------


----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     menuBackground = newMenuBackgroundWH(sceneGroup, 120, 170)

     local styleWidth = 60
     local styleHeight = 30

     local distance = 20

     styleOne = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY - styleHeight - 1.5 * distance,
                                   styleWidth, styleHeight)
     styleOne:setFillColor(1, 0, 0)
     styleOne:addEventListener("tap", function()
          local style = {r = 1, g = 0, b = 0}
          local gameScene = composer.getScene("scene.game")

          gameScene:setPlayerStyle(style)
          saveStyleSetting(style)
          return true
     end)

     styleTwo = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY - distance,
                                   styleWidth, styleHeight)
     styleTwo:setFillColor(0, 1, 0)
     styleTwo:addEventListener("tap", function()
          local style = {r = 0, g = 1, b = 0}
          local gameScene = composer.getScene("scene.game")

          gameScene:setPlayerStyle(style)
          saveStyleSetting(style)
          return true
     end)

     styleThree = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + distance,
                                   styleWidth, styleHeight)
     styleThree:setFillColor(0, 0, 1)
     styleThree:addEventListener("tap", function()
          local style = {r = 0, g = 0, b = 1}
          local gameScene = composer.getScene("scene.game")

          gameScene:setPlayerStyle(style)
          saveStyleSetting(style)
          return true
     end)

     backBtn = newBackBtn(sceneGroup, display.contentCenterX,
     display.contentCenterY + styleHeight + 1.5 * distance, "scene.optionsMenu")

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
