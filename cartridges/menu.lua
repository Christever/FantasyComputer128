local Config   = require("cartridges.config")
local Menu     = {}

Menu.selection = 1

function Menu.update()
    if f_btnp("UP") then
        Menu.selection = Menu.selection - 1
    end

    if f_btnp("DOWN") then
        Menu.selection = Menu.selection + 1
    end

    if Menu.selection < 1 then
        Menu.selection = #Config.MENU_ITEMS
    end

    if Menu.selection > #Config.MENU_ITEMS then
        Menu.selection = 1
    end
end

return Menu
