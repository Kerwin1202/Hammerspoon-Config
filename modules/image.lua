require 'modules.base'

local function convertPasteboardImage2Bas64()
    local image = hs.pasteboard.readImage();
    if image ~= nil  then
        hs.pasteboard.setContents(image:encodeAsURLString())
    end
end

local function convertBase642Image()
    local base64 = hs.pasteboard.readString();
    if base64 ~= nil and string.starts(base64, "data:image/") then
        hs.pasteboard.writeObjects(hs.image.imageFromURL(base64))
    end
end

hs.hotkey.bind({"cmd"}, 'F6', convertPasteboardImage2Bas64)
hs.hotkey.bind({"cmd"}, 'F7', convertBase642Image)