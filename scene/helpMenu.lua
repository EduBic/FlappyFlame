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

	local distance = 8

	local menuGroup = newMenuGroup(sceneGroup, fromMainMenu)

     local infoTxt = "Tap screen to jump. " ..
          "Don't hit\nthe stalagmites, the floor or\nthe sky and do your best.\n" ..
          "You can shake your device\nto pause the game."

	local infoView = display.newText( {
		parent = menuGroup,
		text = infoTxt, -- "Tap to jump, don't hit the\nstalagmites and do your best",
		x = 0, y = -distance - 20,
		font = system.native,
		fontSize = 17,
		align = "left"
	} )

	local menuBackground = newMenuBackgroundH(menuGroup, infoView.height + btnHeight)
	menuBackground:toBack()

	local backBtn = newBackButton(menuGroup, infoView.height/2 + distance,
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
