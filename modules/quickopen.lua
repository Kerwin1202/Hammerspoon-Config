-- 快捷打开链接、文件、目录

-- https://stackoverflow.com/questions/22831701/lua-read-beginning-of-a-string
function string.starts(String,Start)
	  return string.sub(String,1,string.len(Start))==Start
end

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
hs.hotkey.bind({"cmd"}, 'F1', quick_open)