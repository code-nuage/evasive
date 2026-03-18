local type types = require("evasive.types")

local record request
   method:  types.method
   path:    types.path
   headers: types.headers
   body:    string
   params:  types.params

   new:         function(
      table, string                                                         -- table: lua-http headers, string: lua-http body 
   ): request

   set_method:       function(request, types.method):    request
   set_path:         function(request, types.path):      request
   set_header:       function(request, string, string):  request
   set_body:         function(request, types.body):      request
   set_params:       function(request, {string:string}): request
   set_param:        function(request, string, string):  request
   set_query_params: function(request, {string:string}): request
   set_query_param:  function(request, string, string):  request

   get_method:       function(request):                  types.method
   get_path:         function(request):                  types.path
   get_headers:      function(request):                  types.headers
   get_header:       function(request, string):          string
   get_params:       function(request):                  types.params
   get_param:        function(request, string):          string

   build:       function(
      table, string                                                         -- table: lua-http headers, string: lua-http body 
   )
end

return request
