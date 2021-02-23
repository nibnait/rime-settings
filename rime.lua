-- select_character_processor: 以词定字
-- 详见 `lua/select_character.lua`
select_character_processor = require("select_character")
local function date_conversion(type)
  -- 日期类型转换函数
  local result = ""

  if (type == "upper") then
    -- 大写
    local yearNumberUpper = {[0] = "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖", "拾"}
    local monthNumberUpper = {[0] = "零", "零壹", "零贰", "零叁", "零肆", "零伍", "零陆", "零柒", "零捌", "零玖", "零壹拾", "壹拾壹", "壹拾贰"}
    local dayNumberUpper = {[0] = "零", "零壹", "零贰", "零叁", "零肆", "零伍", "零陆", "零柒", "零捌", "零玖", "零壹拾", "壹拾壹", "壹拾贰", "壹拾叁", "壹拾肆", "壹拾伍", "壹拾陆", "壹拾柒", "壹拾捌", "壹拾玖", "贰拾", "贰拾壹", "贰拾贰", "贰拾叁", "贰拾肆", "贰拾伍", "贰拾陆", "贰拾柒", "贰拾捌", "贰拾玖", "叁拾", "叁拾壹"}
    local yearUpper = os.date("%Y")
    for i = 0, 9 do
      yearUpper = string.gsub(yearUpper, i, yearNumberUpper[i])
    end
    local monthUpper = monthNumberUpper[os.date("%m")*1]
    local dayUpper = dayNumberUpper[os.date("%d")*1]
    result = yearUpper.."年"..monthUpper.."月"..dayUpper.."日"
  elseif (type == "lower") then
    -- 小写
    local yearNumberLower = {[0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}
    local monthNumberLower = {[0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" , "十", "十一", "十二"}
    local dayNumberLower = {[0] = "零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九", "三十", "三十一"}
    local yearLower = os.date("%Y")
    for j = 0, 9 do
      yearLower = string.gsub(yearLower, j, yearNumberLower[j])
    end
    local monthLower = monthNumberLower[os.date("%m")*1]
    local dayLower = dayNumberLower[os.date("%d")*1]
    result = yearLower.."年"..monthLower.."月"..dayLower.."日"
  end

  return result
end

function date_translator(input, seg, env)
  -- 如果输入串为 `date` 则翻译
  if (input == "date") then
    --[[ 用 `yield` 产生一个候选项
           候选项的构造函数是 `Candidate`，它有五个参数：
            - type: 字符串，表示候选项的类型
            - start: 候选项对应的输入串的起始位置
            - _end:  候选项对应的输入串的结束位置
            - text:  候选项的文本
            - comment: 候选项的注释
       --]]
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " 日期 -"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), " 日期中文"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), " 日期 ."))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), " 日期 /"))
    yield(Candidate("date", seg.start, seg._end, date_conversion("lower"), " 日期中文小写"))
    yield(Candidate("date", seg.start, seg._end, date_conversion("upper"), " 日期中文大写"))
  end
end

function time_translator(input, seg)
  -- 如果输入串为 `time` 则翻译
  if (input == "time") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " 时间"))
    yield(Candidate("time", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), " 时间日期"))
    yield(Candidate("time", seg.start, seg._end, os.date("%H时%M分%S秒"), " 时间中文"))
    yield(Candidate("time", seg.start, seg._end, os.date("%Y年%m月%d日 %H时%M分%S秒"), " 时间日期中文"))
  end
end
