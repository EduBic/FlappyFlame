-- Requirements
local composer = require "composer"
local display = require "display"

local jsonUtils = require "scene.lib.jsonUtils"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------



------- Functions callbacks -----------------------------------------------


----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     local highestScore = loadHighestScoreSetting()

     local highestScoreView = display.newText({
          parent = sceneGroup,
          text = "Your highest Score: " .. highestScore,
          x = display.contentCenterX,
          y = display.contentCenterY,
          font = native.systemFont,
          fontSize = fontSizeUi
     })

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
