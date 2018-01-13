-- Requirements
local composer = require "composer"
local widget = require "widget"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

--
local fromMainMenu = false
local mParams

----- Functions Callbacks -----------

local function onVolumeTapped()
     composer.showOverlay( "scene.volumeMenu", {
          isModal = true,
          params = mParams
     } )
     return true
end

local function onCostumeTapped()
     composer.showOverlay( "scene.costumeMenu", {
          isModal = true,
          params = mParams
     } )
     return true
end

---------------------------------------

function scene:create( event )
     local sceneGroup = self.view -- add display objects to this group
     mParams = event.params

     if mParams then
          fromMainMenu = event.params.fromMainMenu or false
     end

     local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

     local distance = 8

     local background = newMenuBackgroundH(menuGroup, btnHeight*3)

     local volumeBtn = widget.newButton({
          label = "Volume",
          x = 0,
          y = 0 - btnHeight - distance,
          labelColor = mLabelColors,
          shape = "roundedRect",
          width = btnWidth,
          height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
     })
     volumeBtn:addEventListener("tap", onVolumeTapped)
     menuGroup:insert(volumeBtn)


     local costumeBtn = widget.newButton({
          label = "Costume",
          x = 0,
          y = 0,
		labelColor = mLabelColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
     costumeBtn:addEventListener("tap", onCostumeTapped)
	menuGroup:insert(costumeBtn)


     local backBtn = newBackButton(menuGroup,
          btnHeight + distance, "scene.pauseMenu", mParams)
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
