local json = require("cjson")

local router = require("evasive.router")
local mime = require("evasive.mime")
local colors = require("evasive.colors")

local app = router:new(require("options"))
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
-- curl http://localhost:8080/
:add_route("GET", "/", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome home"}))
end)
-- curl http://localhost:8080/app
:add_route("GET", "/app", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at /app"}))
end)
-- curl http://localhost:8080/err
:add_route("GET", "/err", function(req, res) -- Should throw an error
   missing_value()
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at /app"}))
end)
-- curl http://localhost:8080/admin/dashboard
:add_route("GET", "/admin/dashboard", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Welcome at admin dashboard"}))
end)
-- curl http://localhost:8080/not_found
:add_route("GET", "/not_found", function(req, res)
   app:execute_not_found(req, res) -- Should NOT set a 200 code and fallback to router's route not found
end)
-- curl http://localhost:8080/user/1
:add_route("GET", "/user/:id", function(req, res)
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   :set_body(json.encode({message = "Get user with id " .. req:get_param("id")}))
end)
-- curl http://localhost:8080/page?page=1
:add_route("GET", "/page", function(req, res)
   local page = req:get_query_param("page")
   res
   :set_code(200)
   :set_header("Content-Type", mime.get("json"))
   if page then
      res:set_body(json.encode({message = "Your reading page " .. page}))
   else
      app:execute_not_found(req, res)
   end
end)

app:start()
