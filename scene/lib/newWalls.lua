
local function getTopAndBottomWallCenterY()
     local variability = 35
     local minWallHeight = display.contentCenterY - variability
     local maxWallHeight = display.contentCenterY + variability

     -- pick random center of space
     local spaceCenterY = math.random(minWallHeight, maxWallHeight)

     -- innerSpaceHeight must extend up and under
     -- the final space is 2 * innerSpaceHeight
     local innerHalfSpaceHeight = 56

     -- compute centers side point Y of two walls
     local topWallBottomSideY = spaceCenterY - innerHalfSpaceHeight
     local topWallTopSideY = topLeftY

     local bottomWallTopSideY = spaceCenterY + innerHalfSpaceHeight
     local bottomWallBottomSideY = bottomRightY

     -- compute the height: half height <- center -> half height
     local topWallHeight = topWallBottomSideY - topWallTopSideY
     local bottomWallHeight = bottomWallBottomSideY - bottomWallTopSideY

     -- compute the center in Y axe
     local topWallCenterY = (topWallTopSideY + topWallBottomSideY) / 2
     -- OR topWallTopSideY + topWallHeight / 2
     local bottomWallCenterY = (bottomWallTopSideY + bottomWallBottomSideY) / 2

     return {
          top = topWallCenterY,
          bottom = bottomWallCenterY,
          topHeight = topWallHeight + 30,    -- for go outside display
          bottomHeight = bottomWallHeight + 30
     }
end

local function printTable(table)
     print("newWalls: printTable")
     for index, data in ipairs(table) do
          print(index)
          print(data)
          if data ~= 0 then
               for key, value in pairs(data) do
                 print('\t', key, value)
               end
          end
     end
end

local physics = require "physics"

local distance = 180
local wallWidth = 30
local wallsCacheLength = 4
local wallsSpeed = 2.9

function addWalls(scene, topWalls, bottomWalls)

     scene:insert(topWalls)
     scene:insert(bottomWalls)

     for i = 1, wallsCacheLength do
          local coordsX = bottomRightX + wallWidth -- outside right screen side
          local coordsY = getTopAndBottomWallCenterY()

          -- local topWall = display.newRect(scene, coordsX + distance * (i - 1), coordsY.top,
          --                          wallWidth, coordsY.topHeight)
          -- local bottomWall = display.newRect(scene, coordsX + distance * (i - 1), coordsY.bottom,
          --                          wallWidth, coordsY.bottomHeight)
          local topWall = display.newImageRect(scene, "assets/stalagmite_ice.png",
               wallWidth, coordsY.topHeight)
          topWall.rotation = 180
          topWall.x = coordsX + distance * (i - 1)
          topWall.y = coordsY.top

          local bottomWall = display.newImageRect(scene, "assets/stalagmite_ice.png",
               wallWidth, coordsY.bottomHeight)
          bottomWall.x = coordsX + distance * (i - 1)
          bottomWall.y = coordsY.bottom


          topWall.isAlreadyPass = false

          topWall.myName = "wall"
          bottomWall.myName = "wall"

          local topTriangleShape = {
               0, - coordsY.topHeight / 2,
               -wallWidth / 2, coordsY.top,
               wallWidth / 2, coordsY.top,
          }
          local bottomTriangleShape = {
               0, -coordsY.bottomHeight / 2,
               wallWidth / 2, coordsY.bottom / 2,
               -wallWidth / 2, coordsY.bottom / 2
          }

          physics.addBody( topWall, "static", { shape = topTriangleShape })
          physics.addBody( bottomWall, "static", { shape = bottomTriangleShape } )

          topWalls:insert(topWall)
          bottomWalls:insert(bottomWall)

          --printTable(topWall)

          --print(topWall.x)
          --print(bottomWall.x)
     end
end

function moveWalls(scene, topWalls, bottomWalls, player, onScore)
     --if next(topWalls) ~= nil and next(bottomWalls) ~= nil then  -- check empty
     if topWalls.numChildren ~= nil and bottomWalls.numChildren ~= nil then
          for i = 1, topWalls.numChildren do
               local topWall = topWalls[i]
               local bottomWall = bottomWalls[i]

               if topWall.x < -wallWidth then
                    --topWall.x = display.contentWidth + 60
                    --bottomWall.x = display.contentWidth + 60
                    local coordsX = bottomRightX + wallWidth -- outside right screen side
                    local coordsY = getTopAndBottomWallCenterY()

                    -- reset position
                    topWall.x = coordsX + distance
                    topWall.y = coordsY.top
                    topWall.height = coordsY.topHeight

                    bottomWall.x = coordsX + distance
                    bottomWall.y = coordsY.bottom
                    bottomWall.height = coordsY.bottomHeight

                    topWall.isAlreadyPass = false
                    physics.removeBody( topWall )
                    physics.removeBody( bottomWall )

                    local topTriangleShape = {
                         0, - coordsY.topHeight / 2,
                         -wallWidth / 2, coordsY.top,
                         wallWidth / 2, coordsY.top,
                    }
                    local bottomTriangleShape = {
                         0, -coordsY.bottomHeight / 2,
                         wallWidth / 2, coordsY.bottom / 2,
                         -wallWidth / 2, coordsY.bottom / 2
                    }

                    physics.addBody( topWall, "static", { shape = topTriangleShape })
                    physics.addBody( bottomWall, "static", { shape = bottomTriangleShape } )
               else
                    topWall.x = topWall.x - wallsSpeed
                    bottomWall.x = bottomWall.x - wallsSpeed
               end

               if topWall.x < player.x and topWall.isAlreadyPass == false
                  and player.myName == "player" then
                    topWall.isAlreadyPass = true
                    onScore()
               end
               -- TODO: give an invisible rectangle which collision give me the score
               -- end
          end
     end
end
