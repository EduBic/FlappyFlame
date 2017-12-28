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
local player, upWall, bottomWall
local topWalls = display.newGroup()
local bottomWalls = display.newGroup()

local scoreText
local score = 0
local isAlreadyPass = false


-- Options game elements
local scrollSpeed = 1

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
          return onPause()
     elseif (event.keyName == "n") and (event.phase == "down") then
          physics.pause()
     elseif (event.keyName == "m") and (event.phase == "down") then
          physics.start()
     elseif (event.keyName == "space") and (event.phase == "down") then
          pushPlayer()
     elseif (event.keyName == "l") and (event.phase == "down") then
          return onTilt()
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

onEnterFrame = function()
     --print( "enterFrame" )
     moveWalls(scene, topWalls, bottomWalls, player, function()
          score = score + 1
          scoreText.text = "Score: " .. score
          print("logging: new point!")
     end)
     --movebackground(getDeltaTime())
end

onPause = function()
     Runtime:removeEventListener("enterFrame", onEnterFrame)
     physics.pause()

     composer:showOverlay("scene.pauseMenu", { isModal = true})

     return true
end


onTilt = function(event)
     if event.isShake then
          onPause()
     end
     -- xGravity.text = event.xGravity
     -- yGravity.text = event.yGravity
     -- zGravity.text = event.zGravity
     -- xInstant.text = event.xInstant
     -- yInstant.text = event.yInstant
     -- zInstant.text = event.zInstant

     return true
end

----------------------------------------------

local function addPlayer(scene)
     print( "new player!" )

     player = display.newCircle( scene,
                                 playerStartX,
                                 playerStartY,
                                 playerRadius )
     player.myName = "player"

     local style = loadStyleSetting()
     player:setFillColor(style.r, style.g, style.b)

     physics.addBody( player, "dynamic", {
          radius = playerRadius,
          density = 0.2,
          bounce = 0.3
     })
     print(player)
end

local function addBounders(scene)
     local middleDisplayX = display.contentWidth / 2

     local topBounder = display.newLine(scene, topLeftX, topLeftY - 1,
                                        topLeftX + display.contentWidth, topLeftY - 1)
     topBounder.myName = "bounder"

     local bottomBounder = display.newRect(scene,
          display.contentCenterX, bottomRightY,
          display.contentWidth, 1)
     bottomBounder.myName = "bounder"

     physics.addBody(topBounder, "static" )
     physics.addBody(bottomBounder, "static" )
end

local function addGameUi(group)
     -- add game Ui
     scoreText = display.newText({
          text = "Score: " .. score,
          x = display.contentCenterX,
          y = bottomRightY - 30,
          font = native.systemFont,
          fontSize = 20,
          align = "center"
     })
     group:insert(scoreText)

     local size = 30
     local pauseBtn = display.newRect(0, 0, size, size)
	pauseBtn.x = topLeftX + pauseBtn.width / 2
     pauseBtn.y = topLeftY + pauseBtn.height / 2
	pauseBtn:addEventListener("tap", onPause)
	group:insert(pauseBtn)

     group:toFront()
end

-- listener functions

pushPlayer = function()
     print("tapped!")
     print(player)
     if (player.myName == "player") then
          -- TODO cancel prev force
          player:applyForce(0, -20, player.x, player.y)
     end
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
          player.myName = "deathPlayer"
          composer.gotoScene( "scene.menu", { time = 800, effect="crossFade" })
     end
end

------------------------------------------------------------------------------

function scene:create( event )
     print("Game-scene create")
     local sceneGroup = self.view -- add display objects to this group

     physics.start()

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
          Runtime:addEventListener( "key", onKeyEvent )
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
     Runtime:addEventListener("enterFrame", onEnterFrame)
     physics.start()
end

function scene:setPlayerStyle(color)
     player:setFillColor(color.r, color.g, color.b)
end


scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene

------------------------------------------------------------------------------
