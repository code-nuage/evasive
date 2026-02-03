local util = require("http.util")

local request = {}
request.__index = request

-- Constructor
function request.new(headers, body)
   local i = setmetatable({}, request)

   i.headers = {}
   i.params = {}
   i.query_params = {}

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

function request:set_params(params)
   assert(type(params) == "table",
      "Argument <params>: Must be a table.")
   self.params = params
   return self
end

function request:set_param(key, value)
   assert(type(key) == "string" and type(value) == "string",
      "Argument <key> & <value>: Must be strings.")
   self.params[key] = value
   return self
end

function request:set_query_params(query_params)
   assert(type(query_params) == "table",
      "Argument <query_params>: Must be a table.")
   self.query_params = query_params
   return self
end

function request:set_query_param(key, value)
   assert(type(key) == "string" and type(value) == "string",
      "Argument <key> & <value>: Must be strings.")
   self.query_params[key] = value
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

function request:get_query_params()
   return self.query_params
end

function request:get_query_param(key)
   assert(type(key) == "string",
      "Argument <key>: Must be a string.")
   return self:get_query_params()[key]
end

-- Logic
function request:build(headers, body)
   local method = headers:get(":method")
   local path = headers:get(":path")
   local query
   path, query = path:match("^([^?]*)%??(.*)$")
   local query_params = {}

   if query and query ~= "" then
      for k, v in util.query_args(query) do
         query_params[k] = v
      end
   end

   self
   :set_method(method)
   :set_path(path)
   :set_query_params(query_params)

   for name, value, _ in headers:each() do
      if not (name:sub(1, 1) == ":") then
         self:set_header(name, value)
      end
   end

   self:set_body(body)
end

return request
