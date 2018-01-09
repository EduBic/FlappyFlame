-- Requirements
local composer = require "composer"
local widget = require "widget"

local menuUtils = require "scene.lib.menuUtils"

-- Variables local to scene
local scene = composer.newScene()

local fromMainMenu = false

--------------------

function scene:create( event )
     local sceneGroup = self.view

	if event.params then
		fromMainMenu = event.params.fromMainMenu or false
	end

	local distance = 26

	local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

	local infoView = display.newText( {
		parent = menuGroup,
		text = "Tap to jump, don't hit the\nstalagmites and do your best",
		x = 0, y = -distance,
		font = system.native,
		fontSize = 18,
		align = "center"
	} )

	local menuBackground = newMenuBackgroundH(menuGroup, infoView.height + btnHeight)
	menuBackground:toBack()

	local backBtn = newBackButton(menuGroup, distance,
		"scene.pauseMenu", event.params)

end


function scene:show( event )
  -- local phase = event.phase
  -- local prevScene = composer.getSceneName( "previous" )
  --
  -- if ( phase == "will" ) and prev ~= nil then
  --   composer.removeScene(prevScene, false)
  -- elseif ( phase == "did" ) and prev ~= nil then
  --   composer.gotoScene(prevScene)
  -- end
end

function scene:hide( event )
  -- local phase = event.phase
  -- if ( phase == "will" ) then
  --
  -- elseif ( phase == "did" ) then
  --
  -- end
end

function scene:destroy( event )
  --collectgarbage()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene
