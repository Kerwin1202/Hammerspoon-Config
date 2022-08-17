-- 默认加载的功能模块
defaultConfig = {{
    -- 配置版本号
    -- 每次新增功能项，需将版本号加 1
    configVersion = '1'
}, {
    module = 'modules.window',
    name = '窗口管理',
    enable = true
}, {
    module = 'modules.emoji',
    name = '表情包搜索',
    enable = true
}, {
    module = 'modules.ime',
    name = '输入法切换',
    enable = true
} ,{
    module = 'modules.ocr',
    name = 'OCR',
    enable = true
},{
    module = 'modules.quickopen',
    name = '快捷打开',
    enable = true
},{
    module = 'modules.clipboard',
    name = '剪切板历史',
    enable = true
},{
    module = 'modules.network',
    name = '实时网速',
    enable = true
},{
    module = 'modules.hotkey',
    name = '显示快捷键',
    enable = false
},{
    module = 'modules.image',
    name = '图片 Base64',
    enable = true
},{
    module = 'modules.weather',
    name = '当地天气',
    enable = false
}}

base_path = os.getenv("HOME") .. '/.hammerspoon/'
-- 本地配置文件路径
config_path = base_path .. '.config'

-- 加载本地配置文件
function loadConfig()
    local config = hs.json.read(config_path);
    -- 文件不存在
    if config == nil then
        return defaultConfig;
    end
    return config
end

function saveConfig(config)
    -- 清空文件内容，然后写入新的文件内容
    -- https://www.hammerspoon.org/docs/hs.json.html#write
    hs.json.write(config, config_path, true, true);
end
