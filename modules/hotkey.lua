-- https://github.com/zuorn/hammerspoon_config.git
-- 展示打开的应用的所有快捷键

hs.loadSpoon("ModalMgr")

-- 定义默认加载的 Spoons
if not hspoon_list then
    hspoon_list = {
        "KSheet", -- 快捷键   
	}
end

-- 加载 Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

if spoon.KSheet then
    spoon.ModalMgr:new("cheatsheetM")
    local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
    cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
    
    -- 定义快捷键
    hscheats_keys = hscheats_keys or {"alt", "S"}
    if string.len(hscheats_keys[2]) > 0 then
--         spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "显示应用快捷键", function()
--             spoon.KSheet:show()
--             spoon.ModalMgr:deactivateAll()
--             spoon.ModalMgr:activate({"cheatsheetM"})
--         end)
    end
end

spoon.ModalMgr.supervisor:enter()
