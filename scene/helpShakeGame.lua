-- Requirements
local composer = require "composer"
local display = require "display"

local jsonUtils = require "scene.lib.jsonUtils"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------

local image, textView

local goUp = true
local wait = false

-- 0: go clockwise
-- 1: go anti-clockwise
-- 2: go starting point
-- 3: wait
local state = 0
local countState = 0
local mTimerId
local params


------- Functions callbacks -----------------------------------------------

local function animate()
     if state == 0 then
          transition.to( image, {
               time = 165,
               rotation = image.rotation + 35,
               --y = image.y +10, x = image.x +10,
               onComplete = animate
          } )
          state = 1
     elseif state == 1 then
          transition.to( image, {
               time = 155,
               rotation = image.rotation - 35,
               --y = image.y -10, x = image.x -10,
               onComplete = animate
          })
          countState = countState + 1
          if countState > 2 then
               state = 2
               countState = 0
          else
               state = 0
          end
     elseif state == 2 then
          transition.to( image, {
               time = 100,
               rotation = 5,
               --y = image.y +10, x = image.x +10,
               onComplete = animate
          } )
          state = 3
     elseif state == 3 then
          mTimerId = timer.performWithDelay(700, function()
               state = 0
               animate()
          end)
     end
end

local function onTap(event)
     print("Tapped screen")

     -- composer.showOverlay( "scene.pauseMenu", {
     --      isModal = true,
     --      params = params
     -- })

     return true
end

local function onTilt(event)
     print("Tilt screen")
     if event.isShake then
          -- player learn how to use shake feature
          saveShowPauseHelpSetting(false)

          composer.showOverlay( "scene.pauseMenu", {
               isModal = true,
               params = params
          })
     end

     return true
end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group
     params = event.params

     image = display.newImageRect( sceneGroup, "assets/instructions_shake.png",
          120, 120)
     image.x = display.contentCenterX
     image.y = display.contentCenterY + 40
     image.rotation = 5

     textView = display.newText({
          parent = sceneGroup,
          text = "You can also shake your device\nto pause the game",
          x = display.contentCenterX,
          y = display.contentCenterY - 38,
          font = native.systemFont,
          fontSize = 20,
          align = "center"
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
     Runtime:addEventListener("accelerometer", onTilt)

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
       state = 4 -- stop animation
       transition.cancel( image )

       if mTimerId then
            timer.cancel( mTimerId )
       end
  elseif ( phase == "did" ) then
       Runtime:removeEventListener("accelerometer", onTilt)
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
