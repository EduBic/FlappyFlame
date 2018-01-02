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

------- Functions -----------------------------------------------

local function buildStyleUi(scene, fileName, pos)
     local styleWidth = 45
     local styleHeight = 45

     local distance = 0

     local style = display.newImageRect(scene, "assets/" .. fileName, styleWidth, styleHeight)
     style.x = display.contentCenterX - pos * (styleWidth + distance)
     style.y = display.contentCenterY - 20

     style:addEventListener("tap", function()
          local style = "assets/" .. fileName
          local gameScene = composer.getScene( "scene.game" )

          gameScene:setPlayerStyle(style)
          saveStyleSetting(style)
          return true
     end)

     return style

end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     menuBackground = newMenuBackgroundWH(sceneGroup, 200, 120)

     local styleWidth = 60
     local styleHeight = 30

     local distance = 20

     styleOne = buildStyleUi(sceneGroup, "FireballReduced.png", 1.5)
     styleTwo = buildStyleUi(sceneGroup, "FireballReducedBlue.png", 0)
     styleThree = buildStyleUi(sceneGroup, "FireballReducedStrange.png", -1.5)

     -- styleOne = display.newRect(sceneGroup, display.contentCenterX,
     --     display.contentCenterY - styleHeight - 1.5 * distance,
     --                               styleWidth, styleHeight)
     -- styleOne:setFillColor(1, 0, 0)
     -- styleOne:addEventListener("tap", function()
     --      local style = {r = 1, g = 0, b = 0}
     --      local gameScene = composer.getScene("scene.game")
     --
     --      gameScene:setPlayerStyle(style)
     --      saveStyleSetting(style)
     --      return true
     -- end)

     -- styleTwo = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY - distance,
     --                               styleWidth, styleHeight)
     -- styleTwo:setFillColor(0, 1, 0)
     -- styleTwo:addEventListener("tap", function()
     --      local style = {r = 0, g = 1, b = 0}
     --      local gameScene = composer.getScene("scene.game")
     --
     --      gameScene:setPlayerStyle(style)
     --      saveStyleSetting(style)
     --      return true
     -- end)
     --
     -- styleThree = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY + distance,
     --                               styleWidth, styleHeight)
     -- styleThree:setFillColor(0, 0, 1)
     -- styleThree:addEventListener("tap", function()
     --      local style = {r = 0, g = 0, b = 1}
     --      local gameScene = composer.getScene("scene.game")
     --
     --      gameScene:setPlayerStyle(style)
     --      saveStyleSetting(style)
     --      return true
     -- end)

     backBtn = newBackBtn(sceneGroup, display.contentCenterX,
     display.contentCenterY + 34, "scene.optionsMenu")

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
