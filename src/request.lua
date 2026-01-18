local request = {}
request.__index = request

-- Constructor
function request.new(headers, body)
   local i = setmetatable({}, request)

   i.headers = {}
   i.params = {}
   i:build(headers, body)

   return i
end

-- Setters
function request:set_method(method)
   assert(type(method) == "string",
      "Argument <method>: Must be a string.")
   self.method = method
   return self
end

function request:set_path(path)
   assert(type(path) == "string",
      "Argument <path>: Must be a string.")
   self.path = path
   return self
end

function request:set_header(key, value)
   assert(type(key) == "string" and type(value) == "string",
      "Argument <key> & <value>: Must be strings.")
   self.headers[string.lower(key)] = value
   return self
end

function request:set_body(body)
   assert(type(body) == "string",
      "Argument <body>: Must be a string.")
   self.body = body
   return self
end

function request:set_param(key, value)
   assert(type(key) == "string" and type(value) == "string",
      "Argument <key> & <value>: Must be strings.")
   self.params[key] = value
   return self
end

-- Getters
function request:get_method()
   return self.method or "?"
end

function request:get_path()
   return self.path or "/"
end

function request:get_headers()
   return self.headers
end

function request:get_body()
   return self.body
end

function request:get_header(key)
   assert(type(key) == "string",
      "Argument <key>: Must be a string.")
   return self:get_headers()[string.lower(key)]
end

function request:get_params()
   return self.params
end

function request:get_param(key)
   assert(type(key) == "string",
      "Argument <key>: Must be a string.")
   return self:get_params()[key]
end

-- Logic
function request:build(headers, body)
   local method = headers:get(":method")
   local path = headers:get(":path")

   self
   :set_method(method)
   :set_path(path)

   for name, value, _ in headers:each() do
      if not (name:sub(1, 1) == ":") then
         self:set_header(name, value)
      end
   end

   self:set_body(body)
end

return request
