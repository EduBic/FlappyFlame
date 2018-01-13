-- Requirements
local composer = require "composer"
local widget = require "widget"
local display = require "display"
local audio = require "audio"

local menuUtils = require "scene.lib.menuUtils"
local jsonUtils = require "scene.lib.jsonUtils"

-- Variables local to scene
local scene = composer.newScene()

------- Display elements --------------------------------------------------

local menuBackground
local volumeText
local volumeSlider
local backBtn
local prevValue
local bgMusic


------- Functions callbacks -----------------------------------------------

local function onSliderChanged(event)
     print( "slider changed" .. event.value)

     -- TODO: doesnt' work
     -- if event.value > 0 then
     --      print("Play music")
     --      audio.play( bgMusic, { channel=1, loops=-1 } )
     -- end

     saveVolumeSetting(event.value/100)
     audio.setVolume( event.value/100 )

     return true
end

----------------------------------------------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     local distance = 44

     local fromMainMenu = false
     if event.params then
          fromMainMenu = event.params.fromMainMenu
     end


     local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

     volumeText = display.newText({
          parent = menuGroup,
          text = "Volume",
          x = 0,
          y = -distance,
          font = native.systemFont,
          fontSize = fontSizeUi
     })

     prevValue = loadVolumeSetting() * 100

     local volumeSlider = widget.newSlider({
        x = 0, y = 0,
        width = btnWidth,
        value = prevValue,
        listener = onSliderChanged
     })
     menuGroup:insert(volumeSlider)

     backBtn = newBackButton(menuGroup, distance, "scene.optionsMenu", event.params)

     local menuBackground = newMenuBackgroundH(menuGroup,
          volumeText.height + volumeSlider.height + btnHeight)
     menuBackground:toBack()

     bgMusic = audio.loadStream( "assets/TitleScreen.mp3" )
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
