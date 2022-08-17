function charsize(ch)
    if not ch then return 0
    elseif ch >=252 then return 6
    elseif ch >= 248 and ch < 252 then return 5
    elseif ch >= 240 and ch < 248 then return 4
    elseif ch >= 224 and ch < 240 then return 3
    elseif ch >= 192 and ch < 224 then return 2
    elseif ch < 192 then return 1
    end
end

function utf8len(str)
    local len = 0
    local aNum = 0 --字母个数
    local hNum = 0 --汉字个数
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        local cs = charsize(char)
        currentIndex = currentIndex + cs
        len = len +1
        if cs == 1 then 
            aNum = aNum + 1
        elseif cs >= 2 then 
            hNum = hNum + 1
        end
    end
    return len, aNum, hNum
end

function utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + charsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + charsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end

function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function trim(s)
    if s == nil then
        return ''
    end
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function pushleft (list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function pushright (list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function popleft (list)
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil    -- to allow garbage collection
    list.first = first + 1
    return value
end

function popright (list)
    local last = list.last
    if list.first > last then error("list is empty") end
    local value = list[last]
    list[last] = nil     -- to allow garbage collection
    list.last = last - 1
    return value
end


-- https://stackoverflow.com/questions/22831701/lua-read-beginning-of-a-string
function string.starts(String,Start)
	  return string.sub(String,1,string.len(Start))==Start
end