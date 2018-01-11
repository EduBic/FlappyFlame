
local json = require( "json" )

--- DEBUG function -----------------

local function printTable(table)
     -- print("JsonUtils: printTable")
     -- print(table.volume)
     -- print(table.style)
     -- print(table.highestScore)
     -- print(table.showHelp)

     -- for index, data in ipairs(table) do
     --      print(index)
     --      print(data)
     --      if data ~= 0 then
     --           for key, value in pairs(data) do
     --             print('\t', key, value)
     --           end
     --      end
     -- end
end

-----------------------------------

local function loadData(filePath)
    local file = io.open( filePath, "r" )
    local gameSettings = {}

    if file then
        local contents = file:read( "*a" )
        io.close( file )
        gameSettings = json.decode( contents )
    end

    printTable(gameSettings)

    return gameSettings
end

local function saveData(filePath, newData)
     printTable(newData)

     local file = io.open( filePath, "w" )

     if file then
        file:write( json.encode( newData ) )
        io.close( file )
     end

end

-------------------------------------

local gameSettingsFile = "gameSettings.json"

local function loadDataSetting()
     print("logging: loadDataSetting")

     local gameSettings = {}
     local filePath = system.pathForFile( gameSettingsFile, system.DocumentsDirectory )

     gameSettings = loadData(filePath)

     return gameSettings
end

local function saveDataSetting(newData)
     print("logging: saveDataSetting")

     local filePath = system.pathForFile( gameSettingsFile, system.DocumentsDirectory )

     saveData(filePath, newData)
end


-- Global function
function loadVolumeSetting()
     print("logging: loadVolumeSetting")

     local gameSettings = loadDataSetting()

     if gameSettings.volume == nil then
          gameSettings.volume = 0.42 -- default value
     end

     return gameSettings.volume
end

function saveVolumeSetting(newValue)
     print("logging: saveVolumeSetting")

     local gameSettings = loadDataSetting()

     if (gameSettings ~= nil) then
          gameSettings.volume = newValue
     else
          gameSettings = {}
          gameSettings.volume = newValue
     end

     saveDataSetting(gameSettings)
end

function loadStyleSetting()
     print("logging: loadStyleSetting")

     local gameSettings = loadDataSetting()

     if gameSettings.style == nil then
          gameSettings.style = "assets/FireballReduced.png" -- default value
     end

     return gameSettings.style
end

function saveStyleSetting(newValue)
     print("logging: saveStyleSetting")

     local gameSettings = loadDataSetting()

     if (gameSettings ~= nil) then
          gameSettings.style = newValue
     else
          gameSettings = {}
          gameSettings.style = newValue
     end

     saveDataSetting(gameSettings)
end

function loadHighestScoreSetting()
     print("logging: loadHighestScoreSetting")

     local gameSettings = loadDataSetting()

     if gameSettings.highestScore == nil then
          gameSettings.highestScore = 0 -- default value
     end

     return gameSettings.highestScore
end

function saveHighestScoreSetting(newValue)
     print("logging: saveHighestScoreSetting")

     local gameSettings = loadDataSetting()

     if (gameSettings ~= nil) then
          gameSettings.highestScore = newValue
     else
          gameSettings = {}
          gameSettings.highestScore = newValue
     end

     saveDataSetting(gameSettings)
end

function loadShowHelpSetting()
     print("logging: loadHighestScoreSetting")

     local gameSettings = loadDataSetting()

     if gameSettings.showHelp == nil then
          gameSettings.showHelp = true -- default value
     end

     return gameSettings.showHelp
end

function saveShowHelpSetting(newValue)
     print("logging: saveHighestScoreSetting")

     local gameSettings = loadDataSetting()

     if (gameSettings ~= nil) then
          gameSettings.showHelp = newValue
     else
          gameSettings = {}
          gameSettings.showHelp = newValue
     end

     saveDataSetting(gameSettings)
end
