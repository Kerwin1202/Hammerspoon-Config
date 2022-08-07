-- https://github.com/wangshub/hammerspoon-config
-- 应用自动切换输入法

local INPUT_CHINESE = "com.sogou.inputmethod.sogou.pinyin"
local INPUT_ABC = 'com.apple.keylayout.ABC'

local function Chinese()
    hs.keycodes.currentSourceID(INPUT_CHINESE)
end

local function English()
    hs.keycodes.currentSourceID(INPUT_ABC)
end

-- app to expected ime config
local app2Ime = {
    {'/Applications/WeChat.app', 'Chinese'},
    {'/Applications/QQ.app', 'Chinese'},
    {'/Applications/CotEditor.app', 'English'},
    {'/Applications/Microsoft Remote Desktop.app', 'English'},
    {'/Applications/WindTerm.app', 'English'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'English' then
                English()
            else
                Chinese()
            end
            break
        end
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
