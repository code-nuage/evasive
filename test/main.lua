local json = require("cjson")

local router = require("evasive.router")
local mime = require("evasive.mime")
local colors = require("evasive.colors")

local app = router:new(require("options"))
app:add_middleware(function(req, res, next)
   local start = os.clock()

   next()

   print(string.format(
      "%s %s %s %s",
      colors.colorize_method(req:get_method(), " " .. req:get_method() .. " "),
      colors.colorize("%{bright blue}" .. req:get_path()),
      colors.colorize_code(res:get_code()),
      string.format("%.2fms", (os.clock() - start) * 1000)
   ))
end)
:add_middleware(function(req, res, next)
   if string.match(req:get_path(), "^/admin") then
      res
      :set_code(401)
      :set_header("Content-Type", mime.get("json"))
      :set_body(json.encode({error = "User not authenticated as administrator"}))
      return
   end
   next()
end)
:set_server_error_handler(function(req, res)
   res
   :set_code(500)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Watch out! Internal server error."}))
end)
:set_route_not_found(function(req, res)
   res
   :set_code(404)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Can't find " .. req:get_path() .. " with " .. req:get_method()}))
end)
:add_route("GET", "/", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome home"}))
end)
:add_route("GET", "/app", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at /app"}))
end)
:add_route("GET", "/err", function(req, res) -- Should throw an error
   missing_value()
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at /app"}))
end)
:add_route("GET", "/admin/dashboard", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at admin dashboard"}))
end)
:add_route("GET", "/not_found", function(req, res)
   app:execute_not_found(req, res) -- Should NOT set a 200 code and fallback to router's route not found
end)
:add_route("GET", "/user/:id", function(req, res)
   res:not_found(req) -- Should NOT set a 200 code and fallback to router's route not found
   return
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at /not_found"}))
end)

app:start()
