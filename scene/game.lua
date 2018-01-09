-- Requirements
local composer = require "composer"

local newWalls = require "scene.lib.newWalls"
local jsonUtils = require "scene.lib.jsonUtils"

-- Variables local to scene
local scene = composer.newScene()

------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 9.8 )

local runtime = 0

-- Game elements
local player, playerEffect, upWall, bottomWall
local background1, background2
local pauseBtn

local topWalls = display.newGroup()
local bottomWalls = display.newGroup()

local scoreText
local score = 0
local isAlreadyPass = false
local isGamePaused = false


-- Options game elements
local playerRadius = 10
local playerStartX = display.contentCenterX - 80
local playerStartY = display.contentCenterY

local wallStartWidth = display.contentWidth + 30


----------- Function declarations ---------------

local onEnterFrame
local onPause
local onTilt

local pushPlayer

----------------------DEBUG-----------------------
-- Called when a key event has been received
local function onKeyEvent( event )
     print( "Key '" .. event.keyName .. "' was pressed " .. event.phase )

     -- If the "back" key was pressed on Android, prevent it from backing out of the app
     if (event.keyName == "p" ) and ( event.phase == "down") then
          onPause()
     elseif (event.keyName == "n") and (event.phase == "down") then
          physics.pause()
     elseif (event.keyName == "m") and (event.phase == "down") then
          physics.start()
     elseif (event.keyName == "space") and (event.phase == "down") then
          pushPlayer()
     elseif (event.keyName == "l") and (event.phase == "down") then
          composer.gotoScene( "scene.refresh" )
     end

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end

---------------------------------------------

-- local function getDeltaTime()
--    local temp = system.getTimer()
--    local dt = (temp-runtime) / (1000/60)
--    runtime = temp
--    return dt
-- end

local function moveBackground(background)
     background.x = background.x - 0.7
     if (background.x) < (topLeftX - display.contentWidth) then
        print("logging: restore background pos")
        background:translate(display.contentWidth * 4, 0)
     end
end

onEnterFrame = function()
     --print( "enterFrame" )
     moveWalls(scene, topWalls, bottomWalls, player, function()
          score = score + 1
          scoreText.text = "SCORE: " .. score
          print("logging: new point!")
     end)

     moveBackground(background1)
     moveBackground(background2)
end

onPause = function(event)
     print("logging: onPause")
     pauseBtn.isVisible = false

     Runtime:removeEventListener("enterFrame", onEnterFrame)
     physics.pause()

     Runtime:removeEventListener("tap", pushPlayer)

     composer:showOverlay("scene.pauseMenu", { isModal = true })

     return true
end


onTilt = function(event)
     if event.isShake then
          onPause()
     end

     return true
end

----------------------------------------------

local function buildBackground(scene, x, y)
     local bg = display.newImageRect(scene, "assets/background.png",
          display.contentWidth * 2, display.contentHeight)
     bg.x = x
     bg.y = y
     bg:toBack()

     return bg
end

local function addBackgrounds(scene)
     background1 = buildBackground(scene,
          display.contentCenterX, display.contentCenterY)

     background2 = buildBackground(scene,
          display.contentCenterX + display.contentWidth * 2,
          display.contentCenterY)
end

local function addPlayer(scene)
     print( "new player!" )

     local style = loadStyleSetting()

     -- player = display.newCircle( scene,
     --                             playerStartX,
     --                             playerStartY,
     --                             playerRadius )
     player = display.newImageRect( scene, style, 20, 20 )
	player.x = playerStartX
	player.y = playerStartY

     --player.myName = "player"
     player.myName = "player"

     physics.addBody( player, "dynamic", {
          density = 0.2,
          bounce = 0.3
     } )
end

local function addBounders(scene)
     local middleDisplayX = display.contentWidth / 2

     local topBounder = display.newRect(scene,
          display.contentCenterX, topLeftY - 3,
          display.contentWidth, 1)
     topBounder.myName = "bounder"

     local bottomBounder = display.newRect(scene,
          display.contentCenterX, bottomRightY - 25,
          display.contentWidth, 1)
     bottomBounder.alpha = 0
     bottomBounder.myName = "bounder"

     physics.addBody(topBounder, "static" )
     physics.addBody(bottomBounder, "static" )
end

local function addGameUi(group)
     -- add game Ui
     scoreText = display.newText({
          text = "SCORE: " .. score,
          x = display.contentCenterX,
          y = bottomRightY - 15,
          font = native.systemFont,
          fontSize = 15,
          align = "center"
     })
     group:insert(scoreText)

     local size = 30
     local margin = 2

     pauseBtn = display.newImageRect("assets/OptionButton.png", size, size)
	pauseBtn.x = topLeftX + pauseBtn.width / 2 + margin
     pauseBtn.y = topLeftY + pauseBtn.height / 2 + margin
	pauseBtn:addEventListener("tap", onPause)
     pauseBtn:toFront()
	group:insert(pauseBtn)

     group:toFront()
end

-- listener functions

local swapImage = function(oldImage, imageFile, width, height)
     local newImage = display.newImageRect(scene.view, imageFile, width, height)
     newImage.x = oldImage.x
     newImage.y = oldImage.y
     if oldImage.myName == "player" then
          newImage.myName = "player"
     else
          newImage.myName = "deathPlayer"
     end

     physics.removeBody( oldImage )
     oldImage:removeSelf()
     oldImage = nil

     physics.addBody( newImage, "dynamic", {
          density = 0.2,
          bounce = 0.3
     } )

     return newImage
end

pushPlayer = function()
     print("tapped!")
     print(player)
     if (player.myName == "player") then
          --player.path.radius = playerRadius + 2
          --timer.performWithDelay( 200, function() player.path.radius = playerRadius end)

          -- player = swapImage(player, "balloon_flame.png", 20, 30)
          -- timer.performWithDelay( 400, function()
          --      player = swapImage(player, "balloon.png", 20, 20)
          -- end )

          -- TODO cancel prev force
          --player:applyForce(0, -20, player.x, player.y)
          player:applyLinearImpulse(0, -0.7, player.x, player.y)

          -- TODO: attach effect on bottom of player
          --local jumpEffect = display.newRect(player.x, player.y + playerRadius + 5, 5, 5 )
          --timer.performWithDelay( 400, function() display.remove(jumpEffect) end )
     end

     return false
end

local function checkCollision(obj1, obj2, name1, name2)
     return ( (obj1.myName == name1 and obj2.myName == name2) or
               (obj1.myName == name2 and obj2.myName == name1) )
end

local function onCollision(event)
     print( "onCollision" )

     local obj1 = event.object1
     local obj2 = event.object2

     if (checkCollision(obj1, obj2, "player", "wall")) or
        (checkCollision(obj1, obj2, "player", "bounder")) then

        local oldHighestScore = loadHighestScoreSetting()
        if score > oldHighestScore then
             saveHighestScoreSetting(score)
        end

        player.myName = "deathPlayer"
        composer.gotoScene( "scene.menu")--, { time = 800, effect="crossFade" })
     end
end

------------------------------------------------------------------------------

function scene:create( event )
     print("Game-scene create")
     local sceneGroup = self.view -- add display objects to this group

     physics.start()

     addBackgrounds(sceneGroup)
     addWalls(sceneGroup, topWalls, bottomWalls)
     addPlayer(sceneGroup)
     addBounders(sceneGroup)

     local gameUiGroup = display.newGroup()
     sceneGroup:insert(gameUiGroup)
     addGameUi(gameUiGroup)

     print("Game-scene object: ")
     print(scene)
end

function scene:show( event )
     local phase = event.phase
     print("Game-scene show " .. phase)

     if ( phase == "will" ) then
          physics.start()
          --Runtime:addEventListener("enterFrame", onEnterFrame)
     elseif ( phase == "did" ) then
          print("logging: add listeners")
          Runtime:addEventListener("enterFrame", onEnterFrame)
          Runtime:addEventListener("collision", onCollision )
          Runtime:addEventListener("tap", pushPlayer)
          Runtime:addEventListener("accelerometer", onTilt )
          Runtime:addEventListener("key", onKeyEvent )
          --gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
     end
end

function scene:hide( event )
     local phase = event.phase
     print("Game-scene hide " .. phase)

     if ( phase == "will" ) then
          print("logging: remove listeners")
          Runtime:removeEventListener("enterFrame", onEnterFrame)
          Runtime:removeEventListener("tap", pushPlayer)
          Runtime:removeEventListener("collision", onCollision)
          Runtime:removeEventListener("accelerometer", onTilt)
          Runtime:removeEventListener("key", onKeyEvent )

     elseif ( phase == "did" ) then
          physics.stop()

          if player.myName == "deathPlayer" then
               composer.removeScene( "scene.game" )
          end
     end
end

function scene:destroy( event )
     print("Game-scene destroy")
     --collectgarbage()
end

------------ Game scene external call functions ------------

function scene:onResume()
     pauseBtn.isVisible = true
     Runtime:addEventListener("enterFrame", onEnterFrame)
     Runtime:addEventListener("tap", pushPlayer)
     physics.start()
end

function scene:setPlayerStyle(style)
     --player:setFillColor(color.r, color.g, color.b)
     player = swapImage(player, style, 20, 20)
end

function scene:setDeathPlayer()
     player.myName = "deathPlayer"
end


scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene

------------------------------------------------------------------------------
