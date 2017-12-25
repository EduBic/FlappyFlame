
function newMenuBackground(sceneGroup)
     return newMenuBackgroundWH(sceneGroup, 120, 150)
end

function newMenuBackgroundWH(sceneGroup, width, height)
     local instance = display.newRect(0, 0, width, height)
     instance.x = display.contentCenterX
     instance.y = display.contentCenterY
     instance.alpha = 0.3

     sceneGroup:insert(instance)

     return instance
end

function newBackBtn(sceneGroup, _x, _y, prevScene)
     local display = require "display"
     local composer = require "composer"

     local backBtn = display.newText({
          parent = sceneGroup,
          text = "Back",
          x = _x,
          y = _y,
          font = native.systemFont,
          fontSize = fontSizeUi
     })
     backBtn:addEventListener("tap", function()
          composer.showOverlay( prevScene )
          return true
     end)

     return backBtn
end
