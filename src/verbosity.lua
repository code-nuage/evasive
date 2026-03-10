local log =    require("evasive.log")
local colors = require("evasive.colors")

return function(req, res, n)
   local start = os.clock()

   n()

   log(1, string.format(
      "%s %s %s %s",
      colors.colorize_method(req:get_method(), " " .. req:get_method() .. " "),
      colors.colorize("%{cyan}" .. req:get_path()),
      colors.colorize_code(res:get_code()),
      string.format("%.2fms", (os.clock() - start) * 1000)
   ))
end
