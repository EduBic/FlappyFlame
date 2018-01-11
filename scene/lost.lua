-- Requirements
local composer = require "composer"
local display = require "display"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------



------- Functions callbacks -----------------------------------------------

local function restart(event)
     audio.stop(3)
     composer.gotoScene("scene.refresh")

     return true
end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view

     local distance = 20

     local gameOverView = display.newText( {
          parent = sceneGroup,
          text = "GAME OVER",
          x = display.contentCenterX,
          y = display.contentCenterY - distance - 5,
          font = native.systemFontBold,
          fontSize = 21,
          align = "center"
     } )

     local bestScore = loadHighestScoreSetting()

     local bestScoreView = display.newText( {
          parent = sceneGroup,
          text = "Best score: " .. bestScore,
          x = display.contentCenterX,
          y = display.contentCenterY,
          font = native.systemFont,
          fontSize = 16,
          align = "center"
     } )

     local infoView = display.newText( {
          parent = sceneGroup,
          text = "Tap to restart!",
          x = display.contentCenterX,
          y = display.contentCenterY + distance,
          font = native.systemFont,
          fontSize = 16,
          align = "center"
     } )

end


function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    --Runtime:addEventListener("enterFrame", enterFrame)

  elseif ( phase == "did" ) then
       Runtime:addEventListener("tap", restart)
  end
end

function scene:hide( event )
  local phase = event.phase
  if ( phase == "will" ) then
         Runtime:removeEventListener("tap", restart)
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
