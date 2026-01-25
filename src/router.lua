local server = require("http.server")

local route = require("evasive.route")
local request = require("evasive.request")
local response = require("evasive.response")
local mime   = require("evasive.mime")

local router = {}

router.mt = {
   __index = router
}

-- Constructor
function router:new(options)
   assert(not options or type(options) == "table",
      "Argument <options>: (Optional) Must be a table.")
   self = setmetatable({}, router.mt)

   if options then
      if type(options.host) == "string" then
         self:set_host(options.host)
      end
      if type(options.port) == "number" then
         self:set_port(options.port)
      end
   end

   self.routes = {}
   self.middlewares = {}
   self:set_route_not_found(function(req, res)
      res
      :set_code(404)
      :set_header("Content-Type", "text/plain")
      :set_body("No ressource found at " .. req:get_path())
   end)

   return self
end

-- Setters
function router:set_host(host)
   assert(type(host) == "string",
      "Argument <host>: Must be a string.")
   self.host = host
   return self
end

function router:set_port(port)
   assert(type(port) == "number",
      "Argument <port>: Must be a number.")
   self.port = port
   return self
end

function router:add_route(method, path, callback)
   table.insert(self.routes, route:new(method, path, callback))

   table.sort(self.routes, function(a, b)
      return #(a:get_keys()) > #(b:get_keys())
   end)

   return self
end

function router:set_route_not_found(callback)
   self.route_not_found = route:new(nil, nil, callback)
   return self
end

function router:add_middleware(callback)
   assert(type(callback) == "function",
      "Argument <callback>: Must be a string")
   table.insert(self.middlewares, callback)
   return self
end

-- Getters
function router:get_host()
   return (self.host and type(self.host) == "string") and self.host or "127.0.0.1"
end

function router:get_port()
   return (self.port and type(self.port) == "number") and self.port or 0
end

function router:get_routes()
   return self.routes
end

function router:get_route(method, path)
   for _, r in ipairs(self:get_routes()) do
      local match, params = r:match(method, path)
      if match then
         return r, params
      end
   end
   return self:get_route_not_found()
end

function router:get_route_not_found()
   return self.route_not_found
end

function router:get_middlewares()
   return self.middlewares
end

function router:get_middleware(index)
   return self.middlewares[index]
end

-- Logic
function router:execute_middlewares(req, res, final)
   local i = 0

   local function next()
      i = i + 1
      local mw = self:get_middleware(i)
      if mw then
         mw(req, res, next)
      else
         final()
      end
   end

   next()
end

function router:start()
   local app = server.listen {
      host = self:get_host(),
      port = self:get_port(),
      onstream = function(_, stream)
         local ok
         local req_headers = stream:get_headers()
         local req_body = stream:get_body_as_string()

         local req = request.new(req_headers, req_body)
         local res = response.new()

         local r, params = self:get_route(req:get_method(), req:get_path())
         if params then
            for k, v in pairs(params) do
               req:set_param(k, v)
            end
         end

         ok, _ = xpcall(function()
            res:set_not_found_fallback(self:get_route_not_found())
            self:execute_middlewares(req, res, function()
               r:execute(req, res)
            end)
         end, function(err)
            print(debug.traceback(err, 2))
         end)

         if not ok then
            res
            :set_code(500)
            :set_body("Internal server error")
         end

         ok, _ = xpcall(function()
            local res_headers, res_body = res:build()
            stream:write_headers(res_headers, false)
            stream:write_chunk(res_body, true)
         end, function(err)
            print(debug.traceback(err, 2))
         end)

         if not ok then
            res
            :set_code(500)
            :set_header("Content-Type", mime.get("text"))
            :set_body("Internal server error")
         end
      end
   }
   app:loop()
end

return router
