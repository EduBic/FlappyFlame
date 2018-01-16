-- Requirements
local composer = require "composer"
local display = require "display"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------

local image, textView

local goUp = true

local params

------- Functions callbacks -----------------------------------------------

local function animate()
     if goUp then
          transition.to( image, {
               time = 590,
               y = image.y + 7,
               onComplete = animate
          } )
          goUp = false
     else
          transition.to( image, {
               time = 640,
               y = image.y - 7,
               onComplete = animate
          })
          goUp = true
     end
end

local function onTap(event)
     print("Tapped screen")
     composer.hideOverlay()
     -- composer.showOverlay( "scene.helpShakeGame", {
     --      isModal = true,
     --      params = params
     -- })
     local gameScene = composer.getScene( "scene.game" )
     gameScene:onResume()

     return true
end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group
     params = event.params

     image = display.newImageRect( sceneGroup, "assets/instruction_tap.png",
          70, 70)
     image.x = display.contentCenterX
     image.y = display.contentCenterY + 40

     textView = display.newText({
          parent = sceneGroup,
          text = "Tap screen to fly",
          x = display.contentCenterX,
          y = display.contentCenterY - 38,
          font = native.systemFont,
          fontSize = 20
     })

     local padding = 10

     local textBack = display.newRect(sceneGroup, textView.x, textView.y,
          textView.width + padding, textView.height + padding)
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
       transition.cancel()
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
