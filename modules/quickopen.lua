-- 快捷打开链接、文件、目录
require 'modules.base'

function quick_open()
	local str = hs.pasteboard.readString()
	if str ~= nil and (string.starts(str, "http://") or string.starts(str, "https://")) then
		-- com.microsoft.edgemac
		-- "com.apple.Safari"
		hs.urlevent.openURLWithBundle(str, "com.microsoft.edgemac")
	else
		local displayName = hs.fs.displayName(str);
		-- hs.alert(displayName)
		if displayName ~= nil then
			local shell_command = "open -R \"" .. str .. "\""
			hs.execute(shell_command)
		end
	end
	-- hs.alert(str)
end

local thisWatch;
local function open_dict(text)
	hs.execute("open dict://\"" .. text .. "\""); 
	thisWatch:stop();
end

local function quick_open_dict()
	thisWatch = hs.pasteboard.watcher.new(open_dict);
	hs.eventtap.keyStroke({'cmd'}, 'C')
end

hs.hotkey.bind({"cmd"}, 'F1', quick_open)

-- 本来想着是用以快速查词 但是因为自带词典无法查询句子所以暂时不用
-- hs.hotkey.bind({}, "F6", quick_open_dict)