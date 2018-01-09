-- Requirements
local composer = require "composer"
local widget = require "widget"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

--
local fromMainMenu = false

----- Functions Callbacks -----------

local function onVolumeTapped()
     composer.showOverlay( "scene.volumeMenu", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu }
     } )
     return true
end

local function onCostumeTapped()
     composer.showOverlay( "scene.costumeMenu", {
          isModal = true,
          params = { fromMainMenu = fromMainMenu }
     } )
     return true
end

---------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group

     if event.params then
          fromMainMenu = event.params.fromMainMenu or false
     end

     local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

     local distance = 34

     local background = newMenuBackgroundH(menuGroup, btnHeight*3)

     local volumeBtn = widget.newButton({
          label = "Volume",
          x = 0,
          y = 0 - distance,
          labelColor = mLabelColors,
          shape = "roundedRect",
          width = btnWidth,
          height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors
     })
     volumeBtn:addEventListener("tap", onVolumeTapped)
     menuGroup:insert(volumeBtn)


     local costumeBtn = widget.newButton({
          label = "Costume",
          x = 0,
          y = 0,
		--onRelease = gotoGame,
		-- style
		labelColor = mLabelColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors
	})
     costumeBtn:addEventListener("tap", onCostumeTapped)
	menuGroup:insert(costumeBtn)


     local backBtn = newBackButton(menuGroup,
          distance, "scene.pauseMenu", fromMainMenu)
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
