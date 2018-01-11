-- Requirements
local composer = require "composer"
local display = require "display"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------

local image

local goUp = true


------- Functions callbacks -----------------------------------------------

local function animate()
     if goUp then
          transition.to( image, {
               time = 600,
               y = image.y + 7,
               onComplete = animate
          } )
          goUp = false
     else
          transition.to( image, {
               time = 650,
               y = image.y - 7,
               onComplete = animate
          })
          goUp = true
     end
end

local function onTap(event)
     print("Tapped screen")
     composer.hideOverlay()

     local gameScene = composer.getScene( "scene.game" )
     gameScene:onResume()

     return true
end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     image = display.newImageRect( sceneGroup, "assets/instructions.png", 30, 71)
     image.x = display.contentCenterX
     image.y = display.contentCenterY + 10

     local text = display.newText({
          parent = sceneGroup,
          text = "Tap screen to fly",
          x = display.contentCenterX,
          y = display.contentCenterY - 38,
          font = native.systemFont,
          fontSize = 20
     })

     local padding = 10

     local textBack = display.newRect(sceneGroup, text.x, text.y,
          text.width + padding, text.height + padding)
     textBack:toBack()
     textBack:setFillColor(1,172/255,0,0.42)

     local transContainer = display.newRect(sceneGroup,
          display.contentCenterX, display.contentCenterY,
          display.contentWidth, display.contentHeight )
     transContainer:setFillColor(0,0,0,0.1)

     transContainer:addEventListener("tap", onTap)

     animate()

end


function scene:show( event )
  local phase = event.phase
  if ( phase == "will" ) then
    --Runtime:addEventListener("enterFrame", enterFrame)
  elseif ( phase == "did" ) then
     --Runtime:addEventListener("tap", onTap)

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
