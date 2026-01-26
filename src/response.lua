local headers = require("http.headers")

local mime    = require("evasive.mime")

local response = {}
response.__index = response

function response.new()
   local i = setmetatable({}, response)

   i.headers = {}
   i.state = true

   return i
end

-- Setters
function response:set_code(code)
   assert(type(code) == "number",
      "Argument <code>: Must be a number.")
   if self:get_state() then
      self.code = code
   end
   return self
end

function response:set_header(key, value)
   assert(type(key) == "string" and type(value) == "string",
      "Argument <key> & <value>: Must be strings.")
   if self:get_state() then
      self.headers[key] = value
   end
   return self
end

function response:set_body(body)
   assert(type(body) == "string",
      "Argument <body>: Must be a string.")
   if self:get_state() then
      self.body = body
   end
   return self
end

function response:set_not_found_fallback(route)
   self.route_not_found = route
   return self
end

function response:set_state(state)
   assert(type(state) == "boolean",
      "Argument <state>: Must be a boolean.")
   self.state = state
   return self
end

-- Getters
function response:get_code()
   return self.code or 200
end

function response:get_headers()
   return self.headers or {}
end

function response:get_body()
   return self.body or ""
end

function response:get_not_found_fallback()
   return self.route_not_found
end

function response:get_state()
   return self.state
end

-- Logic
function response:not_found(req)
   local not_found_fallback = self:get_not_found_fallback()

   if not not_found_fallback then
      self
      :set_code(404)
      :set_header("Content-Type", mime.get("txt"))
      :set_body("No ressource found at " .. req:get_path())
      return
   end

   not_found_fallback:execute(req, self)
   self:set_state(false)
end

-- Build
function response:build()
   local res_headers = headers.new()
   res_headers:append(":status", tostring(self:get_code()))

   for k, v in pairs(self:get_headers()) do
      res_headers:append(k, v)
   end

   return res_headers, self:get_body()
end

return response
