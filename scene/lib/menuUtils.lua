
local display = require "display"
local composer = require "composer"
local widget = require "widget"

local function joinMyTables(t1, t2)

   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end

   return t1
end

-- Global Variables
btnHeight = 40
btnWidth = 230
fromTopYdefault = 62
marginTop = 8
mMarginTop = 8
backgroundMargin = 32

mMenuStrokeWidth = 1.4
mStrokeWidth = 1

mMainColorAlpha = {255/255, 190/255, 0/255, 140/255}
mMainColor = {255/255, 190/255, 0/255}

mLabelColors = { default={1,1,1}, over={1,1,1} }
mFillColors = { default=mMainColorAlpha, over={255/255, 190/255, 0/255, 110/255} }
mStrokeFillColors = { default=mMainColor, over=mMainColor }


function newMenuBackground(sceneGroup)
     return newMenuBackgroundWH(sceneGroup, btnWidth + backgroundMargin, 190)
end

function newMenuBackgroundH(sceneGroup, height)
     return newMenuBackgroundWH(sceneGroup, btnWidth + backgroundMargin,
                                   height + backgroundMargin)
end

function newMenuBackgroundWH(sceneGroup, width, height)
     local instance = display.newRect(0, 0, width, height)
     instance.x = sceneGroup.contentCenterX
     instance.y = sceneGroup.contentCenterY
     instance.alpha = 0.5
     instance:setFillColor(unpack(mMainColorAlpha))

     instance.strokeWidth = mMenuStrokeWidth
     instance:setStrokeColor(unpack(mMainColor))

     sceneGroup:insert(instance)

     return instance
end

-- Create the basic container for a menu
function newMenuGroup(scene, fromMainMenu)
     local marginFromTop = 0

     if fromMainMenu then marginFromTop = 28 end

     mg = display.newGroup()
     mg.x = display.contentCenterX
     mg.y = display.contentCenterY + marginFromTop

     scene:insert(mg)

     return mg
end

function newBackButton(scene, _y, prevScene, _params)
     mainMenu = mainMenu or false
     fromMainMenu = fromMainMenu or false

     local backBtn = widget.newButton({
          label = "Back",
		x = 0,
		y = _y,
          -- style
		labelColor = mLabelColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
     })
     scene:insert(backBtn)

     backBtn:addEventListener("tap", function(event)
          composer.showOverlay( prevScene, {
               isModal = true,
               params = _params
          } )
          return true
     end)

     return backBtn
end

function newGenericButton(scene, fromTopY)
     fromTopY = fromTopY or fromTopYdefault


     local genericBtn = widget.newButton({
		label = "Volume",
		x = display.contentCenterX,
		y = topLeftY + fromTopY,
		--onRelease = gotoGame,
		-- style
		labelColor = mLabelColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors
	})
	scene:insert(genericBtn)

     return genericBtn
end


-- Main menu settings

function newMainMenu(scene, fromTopY)
     fromTopY = fromTopY or fromTopYdefault

     buttons = {}

     -- menu set

	local playBtn = widget.newButton({
		label = "Resume",
		x = display.contentCenterX,
		y = display.contentCenterY, --topLeftY + fromTopY,
		-- style
		labelColor = mLabelColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
		fillColor = mFillColors,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
	scene:insert(playBtn)
     buttons.playBtn = playBtn

	-- local helpBtn = widget.newButton({
	-- 	label = "Help",
	-- 	left = playBtn.x - btnWidth/2 - mStrokeWidth/2,
	-- 	top = playBtn.y + btnHeight/2 + marginTop,
	-- 	--onRelease = gotoHelp,
	-- 	-- style
	-- 	labelColor = mLabelColors,
	-- 	fillColor = mFillColors,
	-- 	shape = "roundedRect",
	-- 	width = btnWidth,
	-- 	height = btnHeight,
	-- 	cornerRadius = 2,
     --      strokeColor = mStrokeFillColors,
     --      strokeWidth = mStrokeWidth
	-- })
	-- scene:insert(helpBtn)
     -- buttons.helpBtn = helpBtn

	local optionsBtn = widget.newButton({
		label = "Options",
		left =  playBtn.x  - btnWidth/2 - mStrokeWidth/2,
		top = playBtn.y + btnHeight/2 + marginTop,
		-- style
		labelColor = mLabelColors,
		fillColor = mFillColors,
		shape = "roundedRect",
		width = btnWidth,
		height = btnHeight,
		cornerRadius = 2,
          strokeColor = mStrokeFillColors,
          strokeWidth = mStrokeWidth
	})
	scene:insert(optionsBtn)
     buttons.optionsBtn = optionsBtn

	-- local bestscoreBtn = widget.newButton({
	-- 	label = "Best Score",
	-- 	left = optionsBtn.x - btnWidth/2 - mStrokeWidth/2,
	-- 	top = optionsBtn.y + btnHeight/2 + marginTop,
	-- 	-- style
	-- 	labelColor = mLabelColors,
	-- 	fillColor = mFillColors,
	-- 	shape = "roundedRect",
	-- 	width = btnWidth,
 	-- 	height = btnHeight,
     --    	cornerRadius = 2,
     --      strokeColor = mStrokeFillColors,
     --      strokeWidth = mStrokeWidth
	-- })
	-- scene:insert(bestscoreBtn)
     -- buttons.bestscoreBtn = bestscoreBtn

     -- local exitBtn = widget.newButton({
	-- 	label = "Exit",
	-- 	left = bestscoreBtn.x - btnWidth/2 - mStrokeWidth/2,
	-- 	top = bestscoreBtn.y + btnHeight/2 + marginTop,
	-- 	onRelease = exit,
	-- 	-- style
	-- 	labelColor = mLabelColors,
	-- 	fillColor = mFillColors,
	-- 	shape = "roundedRect",
	-- 	width = btnWidth,
 	-- 	height = btnHeight,
     --    	cornerRadius = 2,
     --      strokeColor = mStrokeFillColors,
     --      strokeWidth = mStrokeWidth
	-- })
	-- scene:insert(exitBtn)
     -- buttons.exitBtn = exitBtn

     local menuBackground = newMenuBackgroundH(scene, btnHeight*2)

	menuBackground.x = playBtn.x
	menuBackground.y = playBtn.y + (optionsBtn.y - playBtn.y)/2
	-- menuBackground.alpha = 0.28
	-- menuBackground:setFillColor(255/255, 165/255, 0/255)

     scene:insert(menuBackground)
	menuBackground:toBack()

     return buttons
end
