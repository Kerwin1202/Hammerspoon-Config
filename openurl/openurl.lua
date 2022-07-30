-- https://stackoverflow.com/questions/22831701/lua-read-beginning-of-a-string
function string.starts(String,Start)
	  return string.sub(String,1,string.len(Start))==Start
end

function open_url()
	local str = hs.pasteboard.readString()
	if str ~= nil and (string.starts(str, "http://") or string.starts(str, "https://")) then
		-- com.microsoft.edgemac
		-- "com.apple.Safari"
		hs.urlevent.openURLWithBundle(str, "com.microsoft.edgemac")
	end
	hs.alert(str)
end

hs.hotkey.bind({"cmd"}, 'Z', open_url)