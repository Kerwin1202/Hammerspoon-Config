require 'modules.base'

local basePath = os.getenv("HOME") .. '/.hammerspoon/'
local databasePath = basePath .. 'clipboard.sqlite3';

local allowSavePaste = true;
local queryPage = 0;
local pageSize = 9;

local function initDatabase()
    local displayName = hs.fs.displayName(databasePath);
    if displayName == nil then
        local db = hs.sqlite3.open(databasePath)
        local tableHistory = [[CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY, create_time INTEGER, parent_id INTEGER, text TEXT, copy_count INTEGER, last_copy_time INTEGER, app_bundleid TEXT, last_paste_time INTEGER, paste_count INTEGER);]]
        db:exec( tableHistory )
        local tableSettings = [[CREATE TABLE IF NOT EXISTS settings (id INTEGER PRIMARY KEY, key TEXT, value TEXT);]]
        db:exec( tableSettings )
        db:close()
    end
    return true;
end

local function getFocusBundleId()
    -- http://www.hammerspoon.org/docs/hs.application.html#frontmostApplication
    return hs.application.frontmostApplication():bundleID();
end

local function showrow(udata,cols,values,names)
    
    for i=1,cols do print('',names[i],values[i]) end
    return 0
end

local function incrementText(text)
    local db = hs.sqlite3.open(databasePath)
    local sql = string.format("select id from history where text = '%s'  limit 1;", text:gsub("'", "''"));
    local exists = false;
    local nowTime = split(hs.timer.secondsSinceEpoch(), '.')[1];
    for row in db:nrows(sql) do
        exists = true;
        print(row.id)
        local updateCountSql = string.format("update history set copy_count = copy_count + 1, last_copy_time = '%s' where id = '%s' ;", nowTime, row.id);
        local result = db:exec(updateCountSql);
        if result ~= 0 then
            print('clipboard history: increment copy count failed')
            print(sql)
        end
    end
    db:close()
    return exists;
end

local function storeText(text)
    hs.console.printStyledtext(hs.pasteboard.readStyledText())
    if text == nil then
        local image = hs.pasteboard.readImage();
        print(image)
    end
    if text ~= nil and string.len(text) ~= 0 and allowSavePaste == true then
        if incrementText(text) ~= true then
            local appBundleId = getFocusBundleId();
            print(string.format("General Pasteboard Contents: %s, From: %s", text, appBundleId))
            local db = hs.sqlite3.open(databasePath)
            local nowTime = split(hs.timer.secondsSinceEpoch(), '.')[1];
            local parentId = 0;
            local sql = string.format("INSERT INTO history(create_time, parent_id, text, copy_count, last_copy_time, app_bundleid) VALUES('%s','%s','%s', '%s', '%s', '%s');", nowTime, parentId, text:gsub("'", "''"), 0, nowTime, appBundleId);
            local result = db:exec(sql);
            if result ~= 0 then
                print('clipboard history: insert failed')
                print(sql)
            end
            db:close()
        end
    end
    if allowSavePaste == false then
        allowSavePaste = true;
    end
end

local function deleteClipboard(id)
    local db = hs.sqlite3.open(databasePath)
    local sql = string.format("delete from history where id = %s;", id);
    db:exec(sql);
    db:close()
end

local function loadLatestClipboard(query)
    query = trim(query)
    local db = hs.sqlite3.open(databasePath)
    local sql = string.format("select * from history order by last_copy_time desc limit %s offset %s;", pageSize, queryPage * pageSize);
    if query ~= '' then
        sql = string.format("select * from history where text like '%s' order by last_copy_time desc limit %s offset %s;", "%" .. query .. "%", pageSize, queryPage * pageSize);
    end
    
    local clipboards = {};
    local index = 1;
    for row in db:nrows(sql) do
        -- local thisImage = hs.image.imageFromPath('./Snipaste_2022-08-07_12-46-37.png');
        -- thisImage:size({h=200, w=200});
        clipboards[index] = {
            ["text"] = string.sub(row.text, 1, 222),
            ["allText"] = row.text,
            ["subText"] = row.app_bundleid,
            ["id"] = row.id,
            -- ["image"] = thisImage
        };
        index = index + 1;
    end
    return clipboards;
end

local ok = initDatabase();
if ok then 
    generalPBWatcher = hs.pasteboard.watcher.new(storeText)
    -- hs.pasteboard.writeObjects("This is on the general pasteboard.")

    local chooser = hs.chooser.new(function(choice)
        if not choice then
            return
        end
        allowSavePaste = false;
        hs.pasteboard.setContents(choice["text"])
        hs.eventtap.keyStroke({'cmd'}, 'v')
    end)

    local thisEventTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        -- 只在 chooser 显示时，才监听键盘按下
        if not chooser:isVisible() then
            return
        end
        local keycode = event:getKeyCode()
        local key = hs.keycodes.map[keycode]
        print(key)
        if 'right' == key and event:getFlags()['shift'] then
            queryPage = queryPage + 1
            chooser:choices(loadLatestClipboard(chooser:query()))
            return
        end
        if 'left' == key and event:getFlags()['shift'] then
            if queryPage <= 0 then
                queryPage = 0
                return
            end
            queryPage = queryPage - 1
            chooser:choices(loadLatestClipboard(chooser:query()))
            return
        end
        if 'delete' == key and event:getFlags()['shift'] then
            local thisRowIndex = chooser:selectedRow()
            if thisRowIndex > 0 then
                local thisRow = chooser:selectedRowContents(thisRowIndex)
                deleteClipboard(thisRow.id);
                chooser:choices(loadLatestClipboard(chooser:query()))
                chooser:selectedRow(thisRowIndex);
            end
            return
        end
    end)

    local function showChooser()
        local query = chooser:query()
        queryPage = 0;
        chooser:choices(loadLatestClipboard())
        chooser:queryChangedCallback(function()
            hs.timer.doAfter(0.1, function()
                chooser:choices(loadLatestClipboard(chooser:query()))
            end)
        end)
        chooser:placeholderText('搜索剪切板历史')
        chooser:show()
        thisEventTap:start();
    end

    chooser:hideCallback(function() thisEventTap:stop(); end);
    chooser:queryChangedCallback(function() queryPage = 0; end);
    -- chooser:bgDark(true)

    hs.hotkey.bind({"cmd", "shift"}, "V", showChooser)
end
