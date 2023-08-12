-- 创建一个 menubar 对象
local menubar = hs.menubar.new()

-- 该对象用于存储全局变量，避免每次获取速度都创建新的局部变量
local timer = {}

-- 更新菜单栏中的时间显示
function updateTime()
    -- 获取当前时间
    local currentTime = os.date("*t")

    -- 星期几的名称
    local weekdays = {"日", "一", "二", "三", "四", "五", "六"}
    local weekday = weekdays[currentTime.wday]

    -- 格式化输出
    local timeString = string.format("%02d:%02d:%02d", currentTime.hour, currentTime.min, currentTime.sec)

    -- 显示 月 日 周 时间
    -- local timeString = string.format("%d月%d日 周%s %02d:%02d:%02d", currentTime.month, currentTime.day, weekday,currentTime.hour, currentTime.min, currentTime.sec)

    menubar:setTitle(timeString)

end

if timer.timer then
    timer.timer:stop()
    timer.timer = nil
end

-- 启动定时器，每隔 100 毫秒更新一次时间显示
timer.timer = hs.timer.doEvery(0.1, updateTime, true):start()

-- 第一次运行时立即更新时间显示
updateTime()
