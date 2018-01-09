-- Requirements
local composer = require "composer"

local menuUtils = require "scene.lib.menuUtils"
local jsonUtils = require "scene.lib.jsonUtils"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------


------- Functions -----------------------------------------------

local function buildStyleUi(scene, fileName, pos)
     local styleWidth = 45
     local styleHeight = 45

     local distance = 0
     local framePadding = 14

     local style = display.newImageRect(scene, "assets/" .. fileName, styleWidth, styleHeight)
     style.x = -pos * (styleWidth + distance)
     style.y = 0

     local styleFrame = display.newRect(scene,
          -pos * (styleWidth),
          0,
          styleWidth + framePadding,
          styleHeight + framePadding
     )

     styleFrame:setFillColor(1,1,1,0.15)
     styleFrame.strokeWidth = 1
     styleFrame:setStrokeColor(1,0,0, 0.42)

     styleFrame:toBack()

     style:addEventListener("tap", function()
          -- update style settings
          local style = "assets/" .. fileName
          saveStyleSetting(style)

          -- update game player if game is running
          local gameScene = composer.getScene( "scene.game" )
          if gameScene then
               gameScene:setPlayerStyle(style)
          end

          return true
     end)

     return style

end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     local fromMainMenu = false
     if event.params then
          fromMainMenu = event.params.fromMainMenu
     end

     local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

     local distance = 48

     local infoText = display.newText( {
          parent = menuGroup,
          text = "Select your flame style:",
          x = 0, y = -distance,
          font = native.systemFont,
          fontSize = 19,
          align = "center"
     } )

     local styleOne = buildStyleUi(menuGroup, "FireballReduced.png", 1.8)
     local styleTwo = buildStyleUi(menuGroup, "FireballReducedBlue.png", 0)
     local styleThree = buildStyleUi(menuGroup, "FireballReducedStrange.png", -1.8)

     local backBtn = newBackButton(menuGroup, distance + 4,
          "scene.optionsMenu", fromMainMenu)

     local menuBackground = newMenuBackgroundWH(menuGroup,
          btnWidth + backgroundMargin,
          infoText.height + styleOne.height + btnHeight + backgroundMargin + 24)
     menuBackground:toBack()

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
