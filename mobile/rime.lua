select_character_processor = require("select_character")

function date_translator(input, seg)
   if (input == "rq") then
      --- Candidate(type, start, end, text, comment)
      yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " "))
   end
end

function time_translator(input, seg)
   if (input == "tt") then
      local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M"), " ")
      cand.quality = 1
      yield(cand)
   end
end