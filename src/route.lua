local route = {}
route.mt = {
   __index = route
}

-- Constructor
function route:new(method, path, callback)
   method = (method and type(method) == "string") and method or "GET"
   path = (path and type(path) == "string") and path or "/"
   callback = (callback and type(callback) == "function") and callback or function(req, res)
      res:set_body("Welcome at " .. path)
   end
   self = setmetatable({}, route.mt)

   self.keys = {}

   local pattern = path:gsub("(:%w+)", function(key)
      self:add_key(key:sub(2))
      return "([^/:]+)"
   end)

   self
   :set_method(method)
   :set_path(path)
   :set_callback(callback)
   :set_pattern("^" .. pattern .. "$")

   return self
end

-- Setters
function route:set_method(method)
   self.method = method
   return self
end

function route:set_path(path)
   self.path = path
   return self
end

function route:set_callback(callback)
   self.callback = callback
   return self
end

function route:set_pattern(pattern)
   self.pattern = pattern
   return self
end

function route:add_key(key)
   table.insert(self.keys, key)
   return self
end

-- Getters
function route:get_method()
   return self.method
end

function route:get_path()
   return self.path
end

function route:get_callback()
   return self.callback
end

function route:get_pattern()
   return self.pattern
end

function route:get_keys()
   return self.keys
end

-- Logic
function route:match(method, path)
   if method == self:get_method() then
      if self.path == path and #self.keys == 0 then
         return true, nil
      end

      local match = path:match(self:get_pattern())
      if match then
         local params = {}
         local captures = {path:match(self:get_pattern())}

         for i, key in ipairs(self:get_keys()) do
            params[key] = captures[i]
         end

         return true, params
      end
   end
end

function route:execute(req, res)
   self:get_callback()(req, res)
end

return route
