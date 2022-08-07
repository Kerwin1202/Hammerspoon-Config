-- 识别图片并复制到剪切板
-- https://github.com/schappim/macOCR
-- /opt/homebrew/bin/ocr -l zh-Hans 

local function ocr()
	-- hs.shortcuts.run("复制文本")
	local beforeStr = hs.pasteboard.readString();
	hs.execute('/opt/homebrew/bin/ocr -l zh-Hans ')
	local afterStr = hs.pasteboard.readString()
	if afterStr ~= nil and afterStr ~= beforeStr then
		hs.alert(afterStr)
	end
end

hs.hotkey.bind({}, 'F4', ocr)