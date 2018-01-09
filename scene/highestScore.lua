-- Requirements
local composer = require "composer"
local display = require "display"

local jsonUtils = require "scene.lib.jsonUtils"
local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------

local fromMainMenu = false


------- Functions callbacks -----------------------------------------------


----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     if event.params then
          fromMainMenu = event.params.fromMainMenu or false
     end

     local distance = 20

     local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

     local menuBackground = newMenuBackgroundH(menuGroup, 80)

     local highestScore = loadHighestScoreSetting()

     local highestScoreView = display.newText({
          parent = menuGroup,
          text = "Your highest Score: " .. highestScore,
          x = 0,
          y = -distance,
          font = native.systemFont,
          fontSize = fontSizeUi - 2,
          align = "center"
     })

     local backBtn = newBackButton(menuGroup, distance, "scene.pauseMenu", event.params)

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
