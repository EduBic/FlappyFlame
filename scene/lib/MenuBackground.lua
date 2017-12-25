
local M = {}


function M.new(instance, display, sceneGroup)
     instance = display.newRect(0, 0, 120, 150)
     instance.x = display.contentCenterX
     instance.y = display.contentCenterY
     instance.alpha = 0.3
     sceneGroup:insert(instance)
end

return M
