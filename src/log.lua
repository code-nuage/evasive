local colors = require("evasive.colors")

local log_levels_colors = {
   "%{cyan}",
   "%{yellow}",
   "%{red}"
}

local log_levels = {
   log_levels_colors[1] .. "Info",
   log_levels_colors[2] .. "Warning",
   log_levels_colors[3] .. "Error",
}

return function(level, text, err)
   local i = 1
   local result
   for l in (text .. "\n"):gmatch("(.-)\n") do
      if i == 1 then
         result = log_levels[level] .. "%{reset}\t│ " .. l
      else
         result = result .. "\n" .. log_levels_colors[level] .. "...%{reset}\t│ " .. l
      end
      i = i + 1
   end
   if err then
      result = result .. ": %{red}" .. err
   end
   io.write(colors.colorize(result) .. "\n")
   io.flush()
end
