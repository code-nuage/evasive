local type types = require("evasive.types")

local type request = require("evasive.request")
local type response = require("evasive.response")

local type callback = function(request, response)

local record route
   method:   types.method
   path:     types.path
   callback: callback
   pattern:  string
   keys:     {string}

   new:          function(
      route, ? types.method, ? types.path, ? callback
   ): route

   set_method:   function(route, types.method):   route
   set_path:     function(route, types.path):     route
   set_callback: function(route, callback):       route
   set_pattern:  function(route, string):         route
   add_key:      function(route, string):         route

   get_method:   function(route):                 types.method
   get_path:     function(route):                 types.path
   get_callback: function(route):                 callback
   get_pattern:  function(route):                 string
   get_keys:     function(route):                 {string}

   match:        function(
      route, types.method, types.path): (boolean, types.params | nil)
   execute:      function(request, response)
end

return route
