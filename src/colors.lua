local ansicolors = require("ansicolors")

local colors = {}

colors.method = {
   ["get"] = "green",
   ["post"] = "yellow",
   ["put"] = "blue",
   ["patch"] = "cyan",
   ["delete"] = "red",
   ["options"] = "magenta",
   ["head"] = "green",
   ["trace"] = "yellow",
   ["connect"] = "blue"
}
colors.code = {
   [1] = "blue",
   [2] = "green",
   [3] = "magenta",
   [4] = "red",
   [5] = "red"
}

function colors.colorize(text)
   assert(type(text) == "string",
      "Argument <text>: Must be a string.")
   return ansicolors(text)
end

function colors.colorize_method(method, method_text)
   assert(type(method) == "string",
      "Argument <method>: Must be a string.")
   method_text = method_text or method
   local color = colors.method[string.lower(method)] or "black"
   return ansicolors("%{bright " .. color .. "bg}" .. method_text)
end

function colors.colorize_code(code, code_text)
   assert(type(code) == "number",
      "Argument <code>: Must be a number.")
   code_text = code_text or code
   local cxx = math.floor(code / 100)
   local color = colors.code[cxx] or "black"
   return ansicolors("%{bright " .. color .. "}" .. code)
end

return colors