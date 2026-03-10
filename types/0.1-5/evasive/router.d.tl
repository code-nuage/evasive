local type types = require("evasive.types")

local type route = require("evasive.route")
local type request = require("evasive.request")
local type response = require("evasive.response")

local type callback = function(request, response)
local type middleware = function(request, response, function)

local record router
   host: types.host
   port: types.port
   routes: {route}
   route_not_found: route
   middlewares: {middleware}

   record options
      host: types.host
      port: types.port
   end

   new: function(self, ? options): router

   set_host:                function(self, types.host): router
   set_port:                function(self, types.port): router
   add_route:               function(
      self, types.method, types.path, callback):       router
   set_route_not_found:      function(self, callback):   router
   set_server_error_handler: function(self, callback):   router
   add_middleware:           function(self, middleware): router

   get_host:                 function(self):             types.host
   get_port:                 function(self):             types.port
   get_routes:               function(self):             {route}
   get_route:                function(
      self, types.method, types.path):                   route
   get_route_not_found:      function(self):             route
   get_server_error_handler: function(self):             callback
   get_middlewares:          function(self):             {middleware}
   get_middleware:           function(self, integer):    middleware

   execute_middlewares:      function(
      self, request, response, route)
   execute_not_found:        function(
      self, request, response)
   start: function(self)
end

return router
